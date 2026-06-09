/*
    RESCOFY BULK DUMMY DATA SEED SCRIPT
    Password for all users: P@ssword12
*/

SET NOCOUNT ON;

-- 1. CONFIGURATION
DECLARE @PatientCount INT = 100;
DECLARE @DriverCount INT = 20;
DECLARE @HospitalCount INT = 10;
DECLARE @RequestCount INT = 500;
DECLARE @PasswordHash NVARCHAR(MAX) = 'AQAAAAIAAYagAAAAEGqP8Uv7X7y1f/8y6p3q1vK/7u5l5q8y3l9k1z9u5w1k8j7h6g5f4d3s2a1q=='; -- Example hash
DECLARE @SecurityStamp NVARCHAR(MAX) = '36X7X7X7X7X7X7X7X7X7X7X7X7X7X7X7';

-- 2. ENSURE ROLES EXIST
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE Name = 'SuperAdmin')
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(), 'SuperAdmin', 'SUPERADMIN', NEWID());
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE Name = 'Admin')
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(), 'Admin', 'ADMIN', NEWID());
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE Name = 'User')
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(), 'User', 'USER', NEWID());
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE Name = 'AmbulanceDriver')
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(), 'AmbulanceDriver', 'AMBULANCEDRIVER', NEWID());
IF NOT EXISTS (SELECT 1 FROM AspNetRoles WHERE Name = 'HospitalAdmin')
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) VALUES (NEWID(), 'HospitalAdmin', 'HOSPITALADMIN', NEWID());

DECLARE @RoleUser NVARCHAR(450) = (SELECT Id FROM AspNetRoles WHERE Name = 'User');
DECLARE @RoleDriver NVARCHAR(450) = (SELECT Id FROM AspNetRoles WHERE Name = 'AmbulanceDriver');
DECLARE @RoleHAdmin NVARCHAR(450) = (SELECT Id FROM AspNetRoles WHERE Name = 'HospitalAdmin');

-- 3. GENERATE HOSPITALS
DECLARE @i INT = 1;
WHILE @i <= @HospitalCount
BEGIN
    INSERT INTO Hospitals (Name, Address, ContactPhone, Latitude, Longitude, BedCapacity, AvailableBeds, ICUCapacity, AvailableICU, Status, StartingPrice, IsDeleted, CreatedAt, UpdatedAt)
    VALUES (
        'Hospital ' + CAST(@i AS VARCHAR(10)),
        CAST(@i AS VARCHAR(10)) + ' Medical St, Cairo, Egypt',
        '02-2345' + CAST(@i AS VARCHAR(10)),
        29.9 + (RAND() * 0.2), 
        31.2 + (RAND() * 0.2), 
        100 + (ABS(CHECKSUM(NEWID())) % 400),
        20 + (ABS(CHECKSUM(NEWID())) % 50),
        20 + (ABS(CHECKSUM(NEWID())) % 30),
        5 + (ABS(CHECKSUM(NEWID())) % 10),
        ABS(CHECKSUM(NEWID())) % 3, -- HospitalStatus enum (0..2)
        500 + (RAND() * 1000),
        0, GETUTCDATE(), GETUTCDATE()
    );
    SET @i = @i + 1;
END

-- 4. AMBULANCE POINTS
SET @i = 1;
WHILE @i <= 5
BEGIN
    INSERT INTO AmbulancePoints (Name, Address, Latitude, Longitude)
    VALUES (
        'Point ' + CAST(@i AS VARCHAR(10)),
        'Intersection ' + CAST(@i AS VARCHAR(10)) + ', Giza',
        29.9 + (RAND() * 0.2),
        31.1 + (RAND() * 0.2)
    );
    SET @i = @i + 1;
END

-- 5. GENERATE USERS (Patients, Drivers)
-- Temporary table to hold generated User IDs
CREATE TABLE #TempUsers (Id NVARCHAR(450), Role NVARCHAR(50));

-- Patients
SET @i = 1;
WHILE @i <= @PatientCount
BEGIN
    DECLARE @Uid NVARCHAR(450) = NEWID();
    DECLARE @Uname NVARCHAR(256) = 'patient' + CAST(@i AS VARCHAR(10));
    DECLARE @Email NVARCHAR(256) = @Uname + '@dummy.com';
    
    INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount, Name, NationalId, Gender, Age, IsBanned)
    VALUES (@Uid, @Uname, UPPER(@Uname), @Email, UPPER(@Email), 1, @PasswordHash, @SecurityStamp, NEWID(), '010' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(10)), 1, 0, 1, 0, 'Patient ' + CAST(@i AS VARCHAR(10)), 'ID' + CAST(@i AS VARCHAR(10)), CASE WHEN @i % 2 = 0 THEN 'Male' ELSE 'Female' END, 20 + (@i % 50), 0);
    
    INSERT INTO AspNetUserRoles (UserId, RoleId) VALUES (@Uid, @RoleUser);
    INSERT INTO UserProfiles (UserId, BloodType, HeightCm, WeightKg, PregnancyStatus, MedicalNotes, CreatedAt, UpdatedAt)
    VALUES (@Uid, 'O+', 170 + (@i % 20), 70 + (@i % 30), 0, 'No specific notes', GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO #TempUsers (Id, Role) VALUES (@Uid, 'Patient');
    SET @i = @i + 1;
END

-- Drivers & Ambulances
SET @i = 1;
WHILE @i <= @DriverCount
BEGIN
    SET @Uid = NEWID();
    SET @Uname = 'driver' + CAST(@i AS VARCHAR(10));
    SET @Email = @Uname + '@dummy.com';
    
    INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnabled, AccessFailedCount, Name, NationalId, Gender, Age, IsBanned)
    VALUES (@Uid, @Uname, UPPER(@Uname), @Email, UPPER(@Email), 1, @PasswordHash, @SecurityStamp, NEWID(), '011' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(10)), 1, 0, 1, 0, 'Driver ' + CAST(@i AS VARCHAR(10)), 'DID' + CAST(@i AS VARCHAR(10)), 'Male', 25 + (@i % 30), 0);
    
    INSERT INTO AspNetUserRoles (UserId, RoleId) VALUES (@Uid, @RoleDriver);
    
    DECLARE @ApId INT = (SELECT TOP 1 Id FROM AmbulancePoints ORDER BY NEWID());
    
    INSERT INTO Ambulances (Name, VehicleInfo, DriverPhone, AmbulanceStatus, SimLatitude, SimLongitude, DriverId, StartingPrice, AmbulanceNumber, AmbulancePointId, IsDeleted, CreatedAt, UpdatedAt)
    VALUES ('Ambulance ' + CAST(@i AS VARCHAR(10)), 'Mercedes Sprinter', '011' + CAST(@i AS VARCHAR(10)), ABS(CHECKSUM(NEWID())) % 4, 30.0 + (RAND() * 0.1), 31.0 + (RAND() * 0.1), @Uid, 800, 'AMB-' + CAST(@i AS VARCHAR(10)), @ApId, 0, GETUTCDATE(), GETUTCDATE());
    
    INSERT INTO #TempUsers (Id, Role) VALUES (@Uid, 'Driver');
    SET @i = @i + 1;
END

-- 6. GENERATE REQUESTS, AI ANALYSIS, ASSIGNMENTS
SET @i = 1;
WHILE @i <= @RequestCount
BEGIN
    DECLARE @PatientId NVARCHAR(450) = (SELECT TOP 1 Id FROM #TempUsers WHERE Role = 'Patient' ORDER BY NEWID());
    DECLARE @Status INT = ABS(CHECKSUM(NEWID())) % 16; -- RequestStatus enum
    
    INSERT INTO Requests (UserId, IsSelfCase, Description, Latitude, Longitude, Address, NumberOfPeopleAffected, RequestStatus, CreatedAt, UpdatedAt, Comment)
    VALUES (@PatientId, 1, 'Emergency scenario ' + CAST(@i AS VARCHAR(10)), 30.0 + (RAND() * 0.1), 31.0 + (RAND() * 0.1), 'Location ' + CAST(@i AS VARCHAR(10)), 1 + (ABS(CHECKSUM(NEWID())) % 3), @Status, DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 30), GETUTCDATE()), GETUTCDATE(), 'Urgent help needed');
    
    DECLARE @ReqId INT = SCOPE_IDENTITY();
    
    -- AI Analysis
    INSERT INTO AIAnalyses (RequestId, Summary, EmergencyType, Urgency, Condition, Confidence, CreatedAt)
    VALUES (@ReqId, 'AI analysis for request ' + CAST(@i AS VARCHAR(10)), ABS(CHECKSUM(NEWID())) % 10, CASE WHEN @i % 3 = 0 THEN 'High' ELSE 'Medium' END, 'Stable', 0.8 + (RAND() * 0.19), GETUTCDATE());
    
    -- Assignment if not pending
    IF @Status > 0
    BEGIN
        DECLARE @AmbId INT = (SELECT TOP 1 Id FROM Ambulances ORDER BY NEWID());
        DECLARE @HospId INT = (SELECT TOP 1 Id FROM Hospitals ORDER BY NEWID());
        DECLARE @DriverUid NVARCHAR(450) = (SELECT DriverId FROM Ambulances WHERE Id = @AmbId);
        
        INSERT INTO Assignments (RequestId, AmbulanceId, HospitalId, AssignedBy, AssignedAt, EtaMinutes, CompletedAt, AutoAssigned, DistanceKm, HospitalDistanceKm, AssignmentScore, ReassignmentCount, Notes, Status)
        VALUES (@ReqId, @AmbId, @HospId, @DriverUid, GETUTCDATE(), 15, CASE WHEN @Status = 15 THEN GETUTCDATE() ELSE NULL END, 1, RAND() * 10, RAND() * 15, 0.9, 0, 'Assigned via Dummy Seed', CASE WHEN @Status = 15 THEN 3 ELSE 1 END); -- 3=Completed, 1=Accepted
        
        -- Trip Report if Finished
        IF @Status = 15
        BEGIN
            INSERT INTO TripReports (RequestId, PatientId, HospitalId, MedicalProcedures, AdmissionTime, DischargeTime, CreatedAt, UpdatedAt)
            VALUES (@ReqId, @PatientId, @HospId, 'Standard emergency care', GETUTCDATE(), DATEADD(HOUR, 2, GETUTCDATE()), GETUTCDATE(), GETUTCDATE());
            
            -- Feedback
            IF @i % 5 = 0
            INSERT INTO Feedbacks (UserId, Comment, HospitalId, AmbulanceId, CreatedAt)
            VALUES (@PatientId, 'Very helpful service', @HospId, @AmbId, GETUTCDATE());
        END
    END
    
    SET @i = @i + 1;
END

DROP TABLE #TempUsers;

PRINT 'Bulk seeding completed successfully.';
GO
