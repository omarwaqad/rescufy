using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Persistence.Data;
using Shared.Enums;

namespace Persistence.Seeding
{
    public class RequestSeeder(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext context)
    {
        public async Task SeedAsync()
        {
            // Check if requests already exist
            if (await context.Requests.AnyAsync())
                return;

            // ==================== CREATE DRIVERS ====================
            var drivers = await CreateDriversAsync();

            // ==================== CREATE PATIENTS ====================
            var patients = await CreatePatientsAsync();

            // ==================== UPDATE HOSPITALS WITH SPECIALTIES ====================
            await UpdateHospitalsAsync();

            // ==================== UPDATE AMBULANCES WITH DRIVERS ====================
            await UpdateAmbulancesAsync(drivers);

            // ==================== CREATE REQUESTS WITH FULL DATA ====================
            await CreateRequestsAsync(patients, drivers);
        }

        private async Task<List<ApplicationUser>> CreateDriversAsync()
        {
            var drivers = new List<ApplicationUser>();

            // Driver 1: Mohammed
            var mohammed = await userManager.FindByEmailAsync("mohammed.driver@rescufy.com");
            if (mohammed == null)
            {
                mohammed = new ApplicationUser
                {
                    UserName = "mohammeddriver",
                    Email = "mohammed.driver@rescufy.com",
                    Name = "Mohammed Ibrahim",
                    PhoneNumber = "0501234567",
                    EmailConfirmed = true
                };
                await userManager.CreateAsync(mohammed, "P@ssword12");
                await userManager.AddToRoleAsync(mohammed, Roles.AmbulanceDriver.ToString());
            }
            drivers.Add(mohammed);

            // Driver 2: Fatima (Paramedic)
            var fatima = await userManager.FindByEmailAsync("fatima.paramedic@rescufy.com");
            if (fatima == null)
            {
                fatima = new ApplicationUser
                {
                    UserName = "fatimaparamedic",
                    Email = "fatima.paramedic@rescufy.com",
                    Name = "Fatima Hassan",
                    PhoneNumber = "0509876543",
                    EmailConfirmed = true
                };
                await userManager.CreateAsync(fatima, "P@ssword12");
                await userManager.AddToRoleAsync(fatima, Roles.AmbulanceDriver.ToString());
            }
            drivers.Add(fatima);

            // Driver 3: Ahmed
            var ahmedDriver = await userManager.FindByEmailAsync("ahmed.driver@rescufy.com");
            if (ahmedDriver == null)
            {
                ahmedDriver = new ApplicationUser
                {
                    UserName = "ahmeddriver",
                    Email = "ahmed.driver@rescufy.com",
                    Name = "Ahmed Khalil",
                    PhoneNumber = "0505551234",
                    EmailConfirmed = true
                };
                await userManager.CreateAsync(ahmedDriver, "P@ssword12");
                await userManager.AddToRoleAsync(ahmedDriver, Roles.AmbulanceDriver.ToString());
            }
            drivers.Add(ahmedDriver);

            // Driver 4: Omar
            var omar = await userManager.FindByEmailAsync("omar.driver@rescufy.com");
            if (omar == null)
            {
                omar = new ApplicationUser
                {
                    UserName = "omardriver",
                    Email = "omar.driver@rescufy.com",
                    Name = "Omar Youssef",
                    PhoneNumber = "0507778899",
                    EmailConfirmed = true
                };
                await userManager.CreateAsync(omar, "P@ssword12");
                await userManager.AddToRoleAsync(omar, Roles.AmbulanceDriver.ToString());
            }
            drivers.Add(omar);

            await context.SaveChangesAsync();
            return drivers;
        }

        private async Task<List<ApplicationUser>> CreatePatientsAsync()
        {
            var patients = new List<ApplicationUser>();

            // Patient 1: Ahmed Al-Rashid (Critical - Cardiac)
            var ahmed = await CreatePatientWithProfileAsync(
                email: "ahmed.alrashid@rescufy.com",
                userName: "ahmedalrashid",
                name: "Ahmed Al-Rashid",
                phone: "0551234567",
                bloodType: "O+",
                weight: 82f,
                height: 175f,
                medicalNotes: "Patient has history of panic attacks. Wife is accompanying the patient.",
                chronicDiseases: new[] { ("Hypertension", "Moderate", 2018), ("Type 2 Diabetes", "Moderate", 2019) },
                medications: new[] { ("Lisinopril", "20mg", "Once daily"), ("Metformin", "500mg", "Twice daily") },
                allergies: new[] { ("Penicillin", "Severe", "Causes anaphylaxis") }
            );
            patients.Add(ahmed);

            // Patient 2: Layla Mohammed (High - Respiratory)
            var layla = await CreatePatientWithProfileAsync(
                email: "layla.mohammed@rescufy.com",
                userName: "laylamohammed",
                name: "Layla Mohammed",
                phone: "0559876543",
                bloodType: "A+",
                weight: 65f,
                height: 162f,
                medicalNotes: "Elderly patient with chronic respiratory issues.",
                chronicDiseases: new[] { ("COPD", "Severe", 2015), ("Asthma", "Moderate", 2010) },
                medications: new[] { ("Albuterol Inhaler", "2 puffs", "As needed"), ("Prednisone", "10mg", "Once daily") },
                allergies: new[] { ("Aspirin", "Moderate", "Causes breathing difficulty") }
            );
            patients.Add(layla);

            // Patient 3: Khalid Hassan (Medium - Trauma)
            var khalid = await CreatePatientWithProfileAsync(
                email: "khalid.hassan@rescufy.com",
                userName: "khalidhassan",
                name: "Khalid Hassan",
                phone: "0553334444",
                bloodType: "B+",
                weight: 78f,
                height: 180f,
                medicalNotes: "Traffic accident victim. No prior medical history.",
                chronicDiseases: Array.Empty<(string, string, int)>(),
                medications: Array.Empty<(string, string, string)>(),
                allergies: new[] { ("Ibuprofen", "Mild", "Stomach upset") }
            );
            patients.Add(khalid);

            // Patient 4: Sara Abdullah (Low - General)
            var sara = await CreatePatientWithProfileAsync(
                email: "sara.abdullah@rescufy.com",
                userName: "saraabdullah",
                name: "Sara Abdullah",
                phone: "0557778888",
                bloodType: "AB+",
                weight: 58f,
                height: 165f,
                medicalNotes: "Pregnant, 28 weeks. Feeling dizzy.",
                chronicDiseases: new[] { ("Gestational Diabetes", "Mild", 2026) },
                medications: new[] { ("Prenatal Vitamins", "1 tablet", "Once daily"), ("Iron Supplement", "325mg", "Once daily") },
                allergies: Array.Empty<(string, string, string)>()
            );
            patients.Add(sara);

            // Patient 5: Youssef Ali (Critical - Stroke)
            var youssef = await CreatePatientWithProfileAsync(
                email: "youssef.ali@rescufy.com",
                userName: "youssefali",
                name: "Youssef Ali",
                phone: "0552223333",
                bloodType: "O-",
                weight: 90f,
                height: 178f,
                medicalNotes: "Found unconscious. Suspected stroke. Time-critical.",
                chronicDiseases: new[] { ("Atrial Fibrillation", "Severe", 2020), ("High Cholesterol", "Moderate", 2018) },
                medications: new[] { ("Warfarin", "5mg", "Once daily"), ("Atorvastatin", "40mg", "Once daily") },
                allergies: new[] { ("Shellfish", "Severe", "Anaphylaxis") }
            );
            patients.Add(youssef);

            return patients;
        }

        private async Task<ApplicationUser> CreatePatientWithProfileAsync(
            string email, string userName, string name, string phone,
            string bloodType, float weight, float height, string medicalNotes,
            (string Name, string Severity, int Year)[] chronicDiseases,
            (string Name, string Dosage, string Frequency)[] medications,
            (string Name, string Severity, string Notes)[] allergies)
        {
            var user = await userManager.FindByEmailAsync(email);
            if (user == null)
            {
                user = new ApplicationUser
                {
                    UserName = userName,
                    Email = email,
                    Name = name,
                    PhoneNumber = phone,
                    EmailConfirmed = true
                };
                await userManager.CreateAsync(user, "P@ssword12");
                await userManager.AddToRoleAsync(user, Roles.User.ToString());
            }

            // Create profile if not exists
            if (!await context.UserProfiles.AnyAsync(p => p.UserId == user.Id))
            {
                var profile = new UserProfile
                {
                    UserId = user.Id,
                    BloodType = bloodType,
                    WeightKg = weight,
                    HeightCm = height,
                    PregnancyStatus = medicalNotes.Contains("Pregnant"),
                    MedicalNotes = medicalNotes,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                await context.UserProfiles.AddAsync(profile);
                await context.SaveChangesAsync();

                // Add chronic diseases
                foreach (var (diseaseName, severity, year) in chronicDiseases)
                {
                    await context.ChronicDiseases.AddAsync(new ChronicDisease
                    {
                        ProfileId = profile.Id,
                        Name = diseaseName,
                        Severity = severity,
                        DiagnosedYear = year,
                        IsActive = true
                    });
                }

                // Add medications
                foreach (var (medName, dosage, frequency) in medications)
                {
                    await context.Medications.AddAsync(new Medication
                    {
                        ProfileId = profile.Id,
                        Name = medName,
                        Dosage = dosage,
                        Frequency = frequency
                    });
                }

                // Add allergies
                foreach (var (allergyName, severity, notes) in allergies)
                {
                    await context.Allergies.AddAsync(new Allergy
                    {
                        ProfileId = profile.Id,
                        Name = allergyName,
                        Severity = severity,
                        Notes = notes
                    });
                }

                await context.SaveChangesAsync();
            }

            return user;
        }

        private async Task UpdateHospitalsAsync()
        {
            // Add more hospitals if needed
            var hospitalData = new[]
            {
                ("King Fahd Medical City", "Riyadh, Saudi Arabia", "+966-11-288-9999", 24.7136m, 46.6753m, 150, 500, "Cardiology"),
                ("King Faisal Specialist Hospital", "Al Zahrawi St, Riyadh", "+966-11-464-7272", 24.6892m, 46.6868m, 100, 400, "Neurology"),
                ("Prince Sultan Medical Center", "Sulaimaniyah, Riyadh", "+966-11-479-5555", 24.7256m, 46.7123m, 80, 300, "Trauma"),
                ("Riyadh Care Hospital", "Al Olaya, Riyadh", "+966-11-465-0505", 24.7012m, 46.6912m, 60, 200, "General"),
                ("Al Hammadi Hospital", "Al Olaya District, Riyadh", "+966-11-461-9999", 24.7189m, 46.6845m, 45, 150, "Obstetrics")
            };

            foreach (var (name, address, phone, lat, lng, available, capacity, specialty) in hospitalData)
            {
                if (!await context.Hospitals.AnyAsync(h => h.Name == name))
                {
                    await context.Hospitals.AddAsync(new Hospital
                    {
                        Name = name,
                        Address = address,
                        ContactPhone = phone,
                        Latitude = lat,
                        Longitude = lng,
                        AvailableBeds = available,
                        BedCapacity = capacity,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    });
                }
            }
            await context.SaveChangesAsync();
        }

        private async Task UpdateAmbulancesAsync(List<ApplicationUser> drivers)
        {
            var ambulanceData = new[]
            {
                ("AMB-101", "Advanced Life Support", 24.7100m, 46.6700m, AmbulanceStatus.Busy, 0),
                ("AMB-102", "Basic Life Support", 24.7200m, 46.6800m, AmbulanceStatus.Available, 1),
                ("AMB-103", "Advanced Life Support", 24.6950m, 46.6650m, AmbulanceStatus.Available, 2),
                ("AMB-104", "Mobile ICU", 24.7300m, 46.7000m, AmbulanceStatus.Busy, 3),
                ("AMB-105", "Basic Life Support", 24.7050m, 46.6750m, AmbulanceStatus.Available, 1)
            };

            foreach (var (name, vehicleInfo, lat, lng, status, driverIndex) in ambulanceData)
            {
                var ambulance = await context.Ambulances.FirstOrDefaultAsync(a => a.Name == name);
                if (ambulance == null)
                {
                    ambulance = new Ambulance
                    {
                        Name = name,
                        VehicleInfo = vehicleInfo,
                        DriverPhone = drivers[driverIndex % drivers.Count].PhoneNumber ?? "0500000000",
                        AmbulanceStatus = status,
                        SimLatitude = lat,
                        SimLongitude = lng,
                        DriverId = drivers[driverIndex % drivers.Count].Id,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };
                    await context.Ambulances.AddAsync(ambulance);
                }
                else
                {
                    ambulance.VehicleInfo = vehicleInfo;
                    ambulance.DriverId = drivers[driverIndex % drivers.Count].Id;
                    ambulance.AmbulanceStatus = status;
                    context.Ambulances.Update(ambulance);
                }
            }
            await context.SaveChangesAsync();
        }

        private async Task CreateRequestsAsync(List<ApplicationUser> patients, List<ApplicationUser> drivers)
        {
            var hospitals = await context.Hospitals.ToListAsync();
            var ambulances = await context.Ambulances.ToListAsync();

            if (hospitals.Count == 0 || ambulances.Count == 0) return;

            // ==================== REQUEST 1: CRITICAL - Cardiac (Ahmed Al-Rashid) ====================
            var request1 = new Request
            {
                UserId = patients[0].Id,
                IsSelfCase = true,
                Description = "Patient reported sudden onset of chest pain and shortness of breath while at work. Pain is 8/10 intensity. No trauma. Patient is conscious and responsive.",
                Latitude = 24.7136m,
                Longitude = 46.6753m,
                Address = "King Fahd Road junction, Riyadh",
                RequestStatus = RequestStatus.Assigned,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
            await context.Requests.AddAsync(request1);
            await context.SaveChangesAsync();

            var aiAnalysis1 = new AIAnalysis
            {
                RequestId = request1.Id,
                Summary = "Likely acute coronary syndrome with anxiety component",
                EmergencyType = EmergencyType.Critical,
                Urgency = "Critical",
                Confidence = 0.85f,
                CreatedAt = DateTime.UtcNow
            };
            await context.AIAnalyses.AddAsync(aiAnalysis1);
            await context.SaveChangesAsync();
            request1.AnalysisId = aiAnalysis1.Id;

            var cardioHospital = hospitals.FirstOrDefault(h => h.Name.Contains("King Fahd")) ?? hospitals[0];
            var assignment1 = new Assignment
            {
                RequestId = request1.Id,
                AmbulanceId = ambulances[0].Id,
                HospitalId = cardioHospital.Id,
                AssignedBy = drivers[0].Id,
                AssignedAt = DateTime.UtcNow,
                EtaMinutes = 3,
                AutoAssigned = true,
                DistanceKm = 2.5f,
                HospitalDistanceKm = 2.5f,
                AssignmentScore = 95f,
                ReassignmentCount = 0,
                Notes = "Heading to King Fahd Road junction. Driver: Mohammed / Paramedic: Fatima",
                Status = AssignmentStatus.Accepted
            };
            await context.Assignments.AddAsync(assignment1);

            // ==================== REQUEST 2: HIGH - Respiratory (Layla Mohammed) ====================
            var request2 = new Request
            {
                UserId = patients[1].Id,
                IsSelfCase = true,
                Description = "Elderly patient experiencing severe breathing difficulty. History of COPD. Oxygen saturation dropping.",
                Latitude = 24.6900m,
                Longitude = 46.6500m,
                Address = "Al-Olaya District, Building 45, Riyadh",
                RequestStatus = RequestStatus.Assigned,
                CreatedAt = DateTime.UtcNow.AddMinutes(-15),
                UpdatedAt = DateTime.UtcNow.AddMinutes(-15)
            };
            await context.Requests.AddAsync(request2);
            await context.SaveChangesAsync();

            var aiAnalysis2 = new AIAnalysis
            {
                RequestId = request2.Id,
                Summary = "Acute exacerbation of COPD. Requires immediate oxygen therapy and bronchodilators.",
                EmergencyType = EmergencyType.High,
                Urgency = "High",
                Confidence = 0.92f,
                CreatedAt = DateTime.UtcNow.AddMinutes(-15)
            };
            await context.AIAnalyses.AddAsync(aiAnalysis2);
            await context.SaveChangesAsync();
            request2.AnalysisId = aiAnalysis2.Id;

            var pulmoHospital = hospitals.FirstOrDefault(h => h.Name.Contains("Faisal")) ?? hospitals[1 % hospitals.Count];
            var assignment2 = new Assignment
            {
                RequestId = request2.Id,
                AmbulanceId = ambulances[1 % ambulances.Count].Id,
                HospitalId = pulmoHospital.Id,
                AssignedBy = drivers[1].Id,
                AssignedAt = DateTime.UtcNow.AddMinutes(-14),
                EtaMinutes = 5,
                AutoAssigned = true,
                DistanceKm = 3.2f,
                HospitalDistanceKm = 4.1f,
                AssignmentScore = 88f,
                ReassignmentCount = 0,
                Notes = "Patient on supplemental oxygen. Driver: Ahmed Khalil",
                Status = AssignmentStatus.Accepted
            };
            await context.Assignments.AddAsync(assignment2);

            // ==================== REQUEST 3: MEDIUM - Trauma (Khalid Hassan) ====================
            var request3 = new Request
            {
                UserId = patients[2].Id,
                IsSelfCase = false,
                Description = "Traffic accident on Highway 40. Driver has cuts on forehead and complains of neck pain. Conscious and alert. Vehicle airbag deployed.",
                Latitude = 24.7500m,
                Longitude = 46.7000m,
                Address = "Highway 40, Exit 15, Riyadh",
                RequestStatus = RequestStatus.Pending,
                CreatedAt = DateTime.UtcNow.AddMinutes(-5),
                UpdatedAt = DateTime.UtcNow.AddMinutes(-5)
            };
            await context.Requests.AddAsync(request3);
            await context.SaveChangesAsync();

            var aiAnalysis3 = new AIAnalysis
            {
                RequestId = request3.Id,
                Summary = "Minor trauma from traffic accident. Possible whiplash injury. No life-threatening injuries detected.",
                EmergencyType = EmergencyType.Medium,
                Urgency = "Medium",
                Confidence = 0.78f,
                CreatedAt = DateTime.UtcNow.AddMinutes(-5)
            };
            await context.AIAnalyses.AddAsync(aiAnalysis3);
            await context.SaveChangesAsync();
            request3.AnalysisId = aiAnalysis3.Id;

            // ==================== REQUEST 4: LOW - Obstetrics (Sara Abdullah) ====================
            var request4 = new Request
            {
                UserId = patients[3].Id,
                IsSelfCase = true,
                Description = "Pregnant woman, 28 weeks, experiencing dizziness and mild contractions. No bleeding. Fetal movement present.",
                Latitude = 24.7189m,
                Longitude = 46.6845m,
                Address = "Al Hamra District, Villa 12, Riyadh",
                RequestStatus = RequestStatus.Assigned,
                CreatedAt = DateTime.UtcNow.AddMinutes(-30),
                UpdatedAt = DateTime.UtcNow.AddMinutes(-25)
            };
            await context.Requests.AddAsync(request4);
            await context.SaveChangesAsync();

            var aiAnalysis4 = new AIAnalysis
            {
                RequestId = request4.Id,
                Summary = "Possible preterm labor signs. Requires obstetric evaluation. Low immediate risk.",
                EmergencyType = EmergencyType.Low,
                Urgency = "Low",
                Confidence = 0.72f,
                CreatedAt = DateTime.UtcNow.AddMinutes(-30)
            };
            await context.AIAnalyses.AddAsync(aiAnalysis4);
            await context.SaveChangesAsync();
            request4.AnalysisId = aiAnalysis4.Id;

            var obHospital = hospitals.FirstOrDefault(h => h.Name.Contains("Hammadi")) ?? hospitals[hospitals.Count - 1];
            var assignment4 = new Assignment
            {
                RequestId = request4.Id,
                AmbulanceId = ambulances[2 % ambulances.Count].Id,
                HospitalId = obHospital.Id,
                AssignedBy = drivers[2].Id,
                AssignedAt = DateTime.UtcNow.AddMinutes(-28),
                EtaMinutes = 8,
                AutoAssigned = false,
                DistanceKm = 4.5f,
                HospitalDistanceKm = 3.8f,
                AssignmentScore = 82f,
                ReassignmentCount = 0,
                Notes = "Pregnant patient. Handle with care. Driver: Omar Youssef",
                Status = AssignmentStatus.Accepted
            };
            await context.Assignments.AddAsync(assignment4);

            // ==================== REQUEST 5: CRITICAL - Stroke (Youssef Ali) - COMPLETED ====================
            var request5 = new Request
            {
                UserId = patients[4].Id,
                IsSelfCase = false,
                Description = "Patient found unconscious by family member. Right side weakness observed. Unable to speak clearly. Suspected stroke.",
                Latitude = 24.6892m,
                Longitude = 46.6868m,
                Address = "Al Malaz District, Apartment 305, Riyadh",
                RequestStatus = RequestStatus.Finished,
                CreatedAt = DateTime.UtcNow.AddHours(-2),
                UpdatedAt = DateTime.UtcNow.AddHours(-1)
            };
            await context.Requests.AddAsync(request5);
            await context.SaveChangesAsync();

            var aiAnalysis5 = new AIAnalysis
            {
                RequestId = request5.Id,
                Summary = "High probability of ischemic stroke. Time-critical. Requires immediate thrombolytic evaluation.",
                EmergencyType = EmergencyType.Critical,
                Urgency = "Critical",
                Confidence = 0.94f,
                CreatedAt = DateTime.UtcNow.AddHours(-2)
            };
            await context.AIAnalyses.AddAsync(aiAnalysis5);
            await context.SaveChangesAsync();
            request5.AnalysisId = aiAnalysis5.Id;

            var neuroHospital = hospitals.FirstOrDefault(h => h.Name.Contains("Faisal")) ?? hospitals[0];
            var assignment5 = new Assignment
            {
                RequestId = request5.Id,
                AmbulanceId = ambulances[3 % ambulances.Count].Id,
                HospitalId = neuroHospital.Id,
                AssignedBy = drivers[3].Id,
                AssignedAt = DateTime.UtcNow.AddHours(-2).AddMinutes(2),
                CompletedAt = DateTime.UtcNow.AddHours(-1),
                EtaMinutes = 4,
                AutoAssigned = true,
                DistanceKm = 1.8f,
                HospitalDistanceKm = 2.2f,
                AssignmentScore = 98f,
                ReassignmentCount = 0,
                Notes = "STROKE ALERT activated. Patient delivered to ER within golden hour. Thrombolysis initiated.",
                Status = AssignmentStatus.Completed
            };
            await context.Assignments.AddAsync(assignment5);

            // ==================== REQUEST 6: CANCELLED REQUEST ====================
            var request6 = new Request
            {
                UserId = patients[0].Id,
                IsSelfCase = true,
                Description = "Mild headache and nausea. Patient cancelled - symptoms resolved.",
                Latitude = 24.7200m,
                Longitude = 46.6900m,
                Address = "Al Wurud District, Riyadh",
                RequestStatus = RequestStatus.Canceled,
                CreatedAt = DateTime.UtcNow.AddHours(-4),
                UpdatedAt = DateTime.UtcNow.AddHours(-4).AddMinutes(5)
            };
            await context.Requests.AddAsync(request6);
            await context.SaveChangesAsync();

            var aiAnalysis6 = new AIAnalysis
            {
                RequestId = request6.Id,
                Summary = "Non-emergency symptoms. Low priority assessment.",
                EmergencyType = EmergencyType.Low,
                Urgency = "Low",
                Confidence = 0.65f,
                CreatedAt = DateTime.UtcNow.AddHours(-4)
            };
            await context.AIAnalyses.AddAsync(aiAnalysis6);
            await context.SaveChangesAsync();
            request6.AnalysisId = aiAnalysis6.Id;

            await context.SaveChangesAsync();
        }
    }
}

