using Domain.Contracts;
using Domain.Models;
using Microsoft.EntityFrameworkCore;
using ServiceAbstraction;
using Shared.DTOs;
using Shared.Enums;
using Shared.DTOs.RealTime;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Service
{
    public class RequestService(IUnitOfWork unitOfWork, IAIService aiService, IAmbulanceRealTimeSender ambulanceRealTimeSender, INotificationRealTimeSender notificationRealTimeSender, UserManager<ApplicationUser> userManager, Microsoft.Extensions.Logging.ILogger<RequestService> logger) : IRequestService
    {
        public async Task<Request> CreateRequestAsync(string userId, string description, decimal latitude, decimal longitude, string address, bool isSelfCase, int numberOfPeopleAffected)
        {
            var request = new Request
            {
                UserId = userId,
                Description = description,
                IsSelfCase = isSelfCase,
                Latitude = latitude,
                Longitude = longitude,
                Address = address,
                NumberOfPeopleAffected = numberOfPeopleAffected,
                RequestStatus = RequestStatus.Pending,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<Request, int>().AddAsync(request);
            await unitOfWork.SaveChangesAsync();

            // Inline AI Processing safely wrapped to prevent blocking if an error occurs
            try
            {
                var (aiSummary, aiUrgency, aiSeverity, aiEmergencyType, aiCondition, aiConfidence) = await aiService.AnalyzeRequestAsync(description);
                
                var aiAnalysis = new AIAnalysis
                {
                    RequestId = request.Id,
                    Summary = aiSummary,
                    Urgency = aiUrgency,
                    Severity = aiSeverity,
                    Condition = aiCondition,
                    EmergencyType = aiEmergencyType,
                    Confidence = aiConfidence,
                    CreatedAt = DateTime.UtcNow
                };
                
                await unitOfWork.GetRepository<AIAnalysis, int>().AddAsync(aiAnalysis);
                await unitOfWork.SaveChangesAsync();
                request.AIAnalysis = aiAnalysis;
                
                logger.LogInformation("AI Analysis saved for Request {RequestId}: Condition={Condition}, Severity={Severity}", request.Id, aiCondition, aiSeverity);
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "AI processing failed for Request {RequestId}, request saved without AI analysis.", request.Id);
            }

            // Auto Assignment Flow - Deterministic Nearest-Neighbor Matching
            var availableAmbulances = await unitOfWork.GetRepository<Ambulance, int>()
                .GetAllAsync(
                    predicate: a => a.AmbulanceStatus == AmbulanceStatus.Available && a.DriverId != null && a.IsActive && !a.IsDeleted,
                    includes: [a => a.Driver]
                );

            var nearestAmbulanceMatch = availableAmbulances
                .Select(a => new { Ambulance = a, Distance = Helpers.GeoHelper.CalculateDistance((double)latitude, (double)longitude, (double)a.SimLatitude, (double)a.SimLongitude) })
                .OrderBy(x => x.Distance)
                .FirstOrDefault();

            var hospitals = await unitOfWork.GetRepository<Hospital, int>()
                .GetAllAsync(h => !h.IsDeleted && h.Status == HospitalStatus.Available);

            var nearestHospitalMatch = hospitals
                .Select(h => new { Hospital = h, Distance = Helpers.GeoHelper.CalculateDistance((double)latitude, (double)longitude, (double)h.Latitude, (double)h.Longitude) })
                .OrderBy(x => x.Distance)
                .FirstOrDefault();

            if (nearestAmbulanceMatch != null)
            {
                var nearestAmbulanceEntity = nearestAmbulanceMatch.Ambulance;
                var nearestAmbulanceDistance = nearestAmbulanceMatch.Distance;
                
                var assignment = new Assignment
                {
                    RequestId = request.Id,
                    AmbulanceId = nearestAmbulanceEntity.Id,
                    AssignedAt = DateTime.UtcNow,
                    AutoAssigned = true,
                    DistanceKm = (float)nearestAmbulanceDistance,
                    HospitalDistanceKm = (float)(nearestHospitalMatch?.Distance ?? 0),
                    HospitalId = nearestHospitalMatch?.Hospital.Id,
                    Status = Shared.Enums.AssignmentStatus.Pending,
                    AssignedBy = userId,
                    Notes = "Auto-assigned by system (Nearest-Neighbor)"
                };

                await unitOfWork.GetRepository<Assignment, int>().AddAsync(assignment);

                request.RequestStatus = RequestStatus.Assigned;
                request.UpdatedAt = DateTime.UtcNow;
                unitOfWork.GetRepository<Request, int>().Update(request);

                nearestAmbulanceEntity.AmbulanceStatus = AmbulanceStatus.Busy;
                nearestAmbulanceEntity.UpdatedAt = DateTime.UtcNow;
                unitOfWork.GetRepository<Ambulance, int>().Update(nearestAmbulanceEntity);

                await unitOfWork.SaveChangesAsync();

                var etaMinutes = (int)(nearestAmbulanceDistance * 2 + 3);

                // Notify User
                await notificationRealTimeSender.SendToUserAsync(request.UserId, new 
                { 
                    Event = "RequestAssigned",
                    RequestId = request.Id, 
                    Ambulance = new { nearestAmbulanceEntity.Name, nearestAmbulanceEntity.DriverPhone, nearestAmbulanceEntity.AmbulanceNumber },
                    Hospital = nearestHospitalMatch != null ? new { nearestHospitalMatch.Hospital.Name, nearestHospitalMatch.Hospital.Address } : null,
                    EstimatedArrivalMinutes = etaMinutes
                });

                // Notify Driver
                if (nearestAmbulanceEntity.DriverId != null)
                {
                    await ambulanceRealTimeSender.SendToUserAsync(nearestAmbulanceEntity.DriverId, "ReceiveRequest", request);
                }

                // Fetch updated request for broadcasting
                var updatedRequest = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                    predicate: r => r.Id == request.Id,
                    includes: [r => r.ApplicationUser, r => r.AIAnalysis, r => r.Assignments, r => r.AuditLogs]
                );

                // Notify Hospital (only if assigned)
                if (nearestHospitalMatch != null)
                {
                    await notificationRealTimeSender.SendEmergencyRequestToHospitalAsync(nearestHospitalMatch.Hospital.Id, new Shared.DTOs.RealTime.HospitalEmergencyRequestDto
                    {
                        RequestId = request.Id,
                        PatientName = updatedRequest?.ApplicationUser?.Name ?? "Unknown",
                        PatientPhone = updatedRequest?.ApplicationUser?.PhoneNumber ?? "Unknown",
                        ConditionSummary = request.AIAnalysis?.Summary ?? "No summary provided",
                        EtaMinutes = etaMinutes
                    });
                }

                var cardDto = MapToRequestCardDto(updatedRequest ?? request);
                await notificationRealTimeSender.BroadcastNewRequestAsync(cardDto);
            }
            else
            {
                // No ambulance found case
                await notificationRealTimeSender.SendToUserAsync(request.UserId, new
                {
                    Event = "NoAmbulanceAvailable",
                    RequestId = request.Id,
                    Message = "No ambulance available nearby"
                });

                // Fetch the updated request with all includes to map to RequestCardDto for Admin broadcast
                var updatedRequest = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                    predicate: r => r.Id == request.Id,
                    includes: [r => r.ApplicationUser, r => r.AIAnalysis, r => r.Assignments, r => r.AuditLogs]
                );

                var cardDto = MapToRequestCardDto(updatedRequest ?? request);
                await notificationRealTimeSender.BroadcastNewRequestAsync(cardDto);
            }

            return request;
        }

        public async Task AcceptRequestAsync(int requestId, string driverId)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                predicate: r => r.Id == requestId,
                includes: [r => r.ApplicationUser, r => r.AIAnalysis]
            );

            if (request == null) throw new Exception("Request not found");
            if (request.RequestStatus != RequestStatus.Pending) throw new Exception("Request already handled or cancelled.");

            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetFirstOrDefaultAsync(
                predicate: a => a.DriverId == driverId && !a.IsDeleted,
                includes: a => a.Driver
            );

            if (ambulance == null) throw new Exception("Ambulance not found for this driver.");
            if (ambulance.AmbulanceStatus != AmbulanceStatus.Available) throw new Exception("Ambulance is no longer available.");

            // Find nearest available hospital
            var hospitals = await unitOfWork.GetRepository<Hospital, int>().GetAllAsync(h => !h.IsDeleted && h.Status == Shared.Enums.HospitalStatus.Available);
            var nearestHospital = hospitals
                .Select(h => new { Hospital = h, Distance = Helpers.GeoHelper.CalculateDistance((double)request.Latitude, (double)request.Longitude, (double)h.Latitude, (double)h.Longitude) })
                .OrderBy(x => x.Distance)
                .FirstOrDefault();

            if (nearestHospital == null) throw new Exception("No available hospitals found.");

            var ambulanceDistance = Helpers.GeoHelper.CalculateDistance((double)request.Latitude, (double)request.Longitude, (double)ambulance.SimLatitude, (double)ambulance.SimLongitude);

            var assignment = new Assignment
            {
                RequestId = requestId,
                AmbulanceId = ambulance.Id,
                AssignedAt = DateTime.UtcNow,
                AutoAssigned = false,
                DistanceKm = (float)ambulanceDistance,
                HospitalDistanceKm = (float)nearestHospital.Distance,
                HospitalId = nearestHospital.Hospital.Id,
                Status = Shared.Enums.AssignmentStatus.Accepted,
                AssignedBy = driverId,
                Notes = "Accepted by driver"
            };

            await unitOfWork.GetRepository<Assignment, int>().AddAsync(assignment);
            
            request.RequestStatus = RequestStatus.Assigned;
            request.UpdatedAt = DateTime.UtcNow;
            unitOfWork.GetRepository<Request, int>().Update(request);

            ambulance.AmbulanceStatus = AmbulanceStatus.Busy;
            ambulance.UpdatedAt = DateTime.UtcNow;
            unitOfWork.GetRepository<Ambulance, int>().Update(ambulance);

            await unitOfWork.SaveChangesAsync();

            // Calculate ETA (simple logic: 2 mins per km + 3 mins base)
            var etaMinutes = (int)(ambulanceDistance * 2 + 3);

            // Notify User
            await notificationRealTimeSender.SendToUserAsync(request.UserId, new 
            { 
                Event = "RequestAccepted",
                RequestId = requestId, 
                Ambulance = new { ambulance.Name, ambulance.DriverPhone, ambulance.AmbulanceNumber },
                Hospital = new { nearestHospital.Hospital.Name, nearestHospital.Hospital.Address },
                EstimatedArrivalMinutes = etaMinutes
            });

            // Notify Hospital
            await notificationRealTimeSender.SendEmergencyRequestToHospitalAsync(nearestHospital.Hospital.Id, new Shared.DTOs.RealTime.HospitalEmergencyRequestDto
            {
                RequestId = requestId,
                PatientName = request.ApplicationUser?.Name ?? "Unknown",
                PatientPhone = request.ApplicationUser?.PhoneNumber ?? "Unknown",
                ConditionSummary = request.AIAnalysis?.Summary ?? "No summary provided",
                EtaMinutes = etaMinutes
            });

            // Notify Admins
            var updatedRequest = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                predicate: r => r.Id == requestId,
                includes: [r => r.ApplicationUser, r => r.AIAnalysis, r => r.Assignments, r => r.AuditLogs]
            );
            var cardDto = MapToRequestCardDto(updatedRequest!);
            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(requestId, "RequestAssigned", cardDto);
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetDriverRequestsAsync(string driverId)
        {
            var assignments = await unitOfWork.GetRepository<Assignment, int>()
                .GetAllAsync(
                    predicate: a => a.Ambulance.DriverId == driverId,
                    includes: [a => a.Request, a => a.Ambulance, a => a.Request.ApplicationUser]
                );

            return assignments.Select(a => new Shared.DTOs.Request.RequestLightweightDto
            {
                Id = a.Request.Id,
                Description = a.Request.Description,
                Address = a.Request.Address,
                RequestStatus = a.Request.RequestStatus,
                CreatedAt = a.Request.CreatedAt,
                PatientName = a.Request.ApplicationUser?.Name ?? "Unknown",
                AssignedAmbulancePlate = a.Ambulance?.AmbulanceNumber
            });
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetHistoryAsync(RequestFilterDto filter)
        {
            var requests = await unitOfWork.GetRepository<Request, int>()
                .GetAllAsync(predicate: r =>
                    r.UserId == filter.UserId &&
                    (!filter.IsSelfCase.HasValue || r.IsSelfCase == filter.IsSelfCase) &&
                    (!filter.StartDate.HasValue || r.CreatedAt >= filter.StartDate) &&
                    (!filter.EndDate.HasValue || r.CreatedAt <= filter.EndDate),
                    includes: [r => r.ApplicationUser, r => r.Assignments]
                );

            var lightweightRequests = new List<Shared.DTOs.Request.RequestLightweightDto>();

            foreach (var r in requests)
            {
                var latestAssignment = r.Assignments.OrderByDescending(a => a.AssignedAt).FirstOrDefault();
                Ambulance? ambulance = null;
                if (latestAssignment != null)
                {
                    ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(latestAssignment.AmbulanceId);
                }

                lightweightRequests.Add(new Shared.DTOs.Request.RequestLightweightDto
                {
                    Id = r.Id,
                    Description = r.Description,
                    Address = r.Address,
                    RequestStatus = r.RequestStatus,
                    CreatedAt = r.CreatedAt,
                    PatientName = r.ApplicationUser?.Name ?? "Unknown",
                    AssignedAmbulancePlate = ambulance?.AmbulanceNumber
                });
            }

            return lightweightRequests;
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetHospitalRequestsAsync(string hospitalAdminId, RequestFilterDto filter)
        {
            var admin = await userManager.FindByIdAsync(hospitalAdminId);
            if (admin == null || admin.HospitalId == null)
                throw new Exception("Hospital Admin not found or not linked to any hospital.");

            filter ??= new RequestFilterDto();
            filter.HospitalId = admin.HospitalId;

            return await GetRequestsAsync(filter);
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetRequestsAsync(RequestFilterDto filter)
        {
            var requests = await unitOfWork.GetRepository<Request, int>()
                .GetAllAsync(predicate: r =>
                    (string.IsNullOrEmpty(filter.UserId) || r.UserId == filter.UserId) &&
                    (!filter.RequestStatus.HasValue || r.RequestStatus == filter.RequestStatus) &&
                    (!filter.IsSelfCase.HasValue || r.IsSelfCase == filter.IsSelfCase) &&
                    (!filter.StartDate.HasValue || r.CreatedAt >= filter.StartDate) &&
                    (!filter.EndDate.HasValue || r.CreatedAt <= filter.EndDate) &&
                    (!filter.HospitalId.HasValue || r.Assignments.Any(a => a.HospitalId == filter.HospitalId)),
                    includes: [r => r.ApplicationUser, r => r.Assignments]
                );

            var lightweightRequests = new List<Shared.DTOs.Request.RequestLightweightDto>();

            foreach (var r in requests)
            {
                var latestAssignment = r.Assignments.OrderByDescending(a => a.AssignedAt).FirstOrDefault();
                Ambulance? ambulance = null;
                if (latestAssignment != null)
                {
                    ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(latestAssignment.AmbulanceId);
                }

                lightweightRequests.Add(new Shared.DTOs.Request.RequestLightweightDto
                {
                    Id = r.Id,
                    Description = r.Description,
                    Address = r.Address,
                    RequestStatus = r.RequestStatus,
                    CreatedAt = r.CreatedAt,
                    PatientName = r.ApplicationUser?.Name ?? "Unknown",
                    AssignedAmbulancePlate = ambulance?.AmbulanceNumber
                });
            }

            return lightweightRequests;
        }

        public async Task<Shared.DTOs.Request.RequestDetailsDto> GetRequestByIdAsync(int id)
        {
            var requests = await unitOfWork.GetRepository<Request, int>().GetAllAdvanced(
                predicate: r => r.Id == id,
                includes: [
                    q => q.Include(r => r.ApplicationUser)
                          .ThenInclude(u => u!.UserProfile)
                          .ThenInclude(p => p!.ChronicDiseases),
                    q => q.Include(r => r.ApplicationUser)
                          .ThenInclude(u => u!.UserProfile)
                          .ThenInclude(p => p!.Allergies),
                    q => q.Include(r => r.ApplicationUser)
                          .ThenInclude(u => u!.UserProfile)
                          .ThenInclude(p => p!.Medications),
                    q => q.Include(r => r.ApplicationUser)
                          .ThenInclude(u => u!.UserProfile)
                          .ThenInclude(p => p!.PastSurgeries),
                    q => q.Include(r => r.AIAnalysis),
                    q => q.Include(r => r.Assignments),
                    q => q.Include(r => r.TripReport)
                ]
            ).ToListAsync();

            var r = requests.FirstOrDefault();
            if (r == null) throw new Exception("Request not found");

            var patient = r.ApplicationUser;
            var profile = patient?.UserProfile;

            var dto = new Shared.DTOs.Request.RequestDetailsDto
            {
                Id = r.Id,
                UserId = r.UserId,
                PatientName = patient?.Name ?? "Unknown",
                PatientPhone = patient?.PhoneNumber ?? "",
                IsSelfCase = r.IsSelfCase,
                Description = r.Description,
                Latitude = r.Latitude,
                Longitude = r.Longitude,
                Address = r.Address,
                NumberOfPeopleAffected = r.NumberOfPeopleAffected,
                RequestStatus = r.RequestStatus,
                CreatedAt = r.CreatedAt,
                UpdatedAt = r.UpdatedAt,
                Comment = r.Comment,
                Patient = new Shared.DTOs.Request.PatientDto
                {
                    Id = r.UserId,
                    Name = patient?.Name ?? "Unknown",
                    PhoneNumber = patient?.PhoneNumber ?? "",
                    Email = patient?.Email ?? "",
                    Profile = profile != null ? new Shared.DTOs.Request.UserProfileDto
                    {
                        BloodType = profile.BloodType,
                        WeightKg = profile.WeightKg,
                        HeightCm = profile.HeightCm,
                        PregnancyStatus = profile.PregnancyStatus,
                        MedicalNotes = profile.MedicalNotes,
                        ChronicDiseases = profile.ChronicDiseases.Select(cd => new Shared.DTOs.Request.ChronicDiseaseDto { Id = cd.Id, Name = cd.Name }).ToList(),
                        Allergies = profile.Allergies.Select(a => new Shared.DTOs.Request.AllergyDto { Id = a.Id, Name = a.Name }).ToList(),
                        Medications = profile.Medications.Select(m => new Shared.DTOs.Request.MedicationDto { Id = m.Id, Name = m.Name }).ToList(),
                        PastSurgeries = profile.PastSurgeries.Select(ps => new Shared.DTOs.Request.PastSurgeryDto { Id = ps.Id, Name = ps.Name }).ToList()
                    } : null
                },
                AIAnalysis = r.AIAnalysis != null ? new Shared.DTOs.Request.AIAnalysisDto
                {
                    Summary = r.AIAnalysis.Summary,
                    Urgency = r.AIAnalysis.Urgency,
                    Condition = r.AIAnalysis.Condition,
                    Severity = r.AIAnalysis.Severity,
                    Confidence = r.AIAnalysis.Confidence
                } : null,
                TripReport = r.TripReport != null ? new Shared.DTOs.Request.TripReportDetailsDto
                {
                    Id = r.TripReport.Id,
                    MedicalProcedures = r.TripReport.MedicalProcedures,
                    AdmissionTime = r.TripReport.AdmissionTime,
                    DischargeTime = r.TripReport.DischargeTime
                } : null
            };

            foreach (var a in r.Assignments)
            {
                var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetFirstOrDefaultAsync(
                    predicate: amb => amb.Id == a.AmbulanceId,
                    includes: amb => amb.Driver
                );
                var hospital = a.HospitalId.HasValue ? await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(a.HospitalId.Value) : null;
                var driver = ambulance?.Driver;

                dto.Assignments.Add(new Shared.DTOs.Request.AssignmentDto
                {
                    Id = a.Id,
                    AmbulancePlate = ambulance?.AmbulanceNumber ?? "",
                    DriverName = driver?.Name ?? "Unknown",
                    HospitalId = a.HospitalId,
                    HospitalName = hospital?.Name,
                    AssignedAt = a.AssignedAt,
                    CompletedAt = a.CompletedAt,
                    DistanceKm = a.DistanceKm,
                    Status = a.Status
                });
            }

            return dto;
        }

        public async Task<Request> UpdateStatusAsync(int requestId, string driverId, RequestStatus newStatus, string? comment = null)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(requestId);
            if (request == null) throw new Exception("Request not found");

            if (newStatus == RequestStatus.NotDelivered && string.IsNullOrWhiteSpace(comment))
            {
                throw new Exception("Comment is required when status is NotDelivered");
            }

            request.RequestStatus = newStatus;
            request.UpdatedAt = DateTime.UtcNow;
            
            if (!string.IsNullOrWhiteSpace(comment))
            {
                request.Comment = comment;
            }

            unitOfWork.GetRepository<Request, int>().Update(request);

            if (newStatus == RequestStatus.Accepted)
            {
                var assignment = (await unitOfWork.GetRepository<Assignment, int>()
                    .GetAllAsync(a => a.RequestId == requestId && a.Ambulance.DriverId == driverId))
                    .FirstOrDefault();

                if (assignment != null)
                {
                    assignment.Status = AssignmentStatus.Accepted;
                    unitOfWork.GetRepository<Assignment, int>().Update(assignment);
                }
            }

            await unitOfWork.SaveChangesAsync();

            // Broadcast to the Patient that the status has changed
            await ambulanceRealTimeSender.SendToGroupAsync($"Request_{requestId}", "ReceiveStatusUpdate", new RequestStatusUpdateDto { RequestId = requestId, Status = newStatus.ToString() });
            
            // Broadcast to Admins and others
            await notificationRealTimeSender.BroadcastStatusChangedAsync(requestId, newStatus.ToString());
            
            var updatedRequest = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                predicate: r => r.Id == requestId,
                includes: [r => r.ApplicationUser, r => r.AIAnalysis, r => r.Assignments, r => r.AuditLogs]
            );
            var cardDto = MapToRequestCardDto(updatedRequest!);
            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(requestId, "StatusChanged", cardDto);

            return request;
        }

        public async Task ReassignAmbulanceAsync(int requestId, int newAmbulanceId, string adminId)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(requestId);
            if (request == null) throw new Exception("Request not found");

            if (request.RequestStatus == RequestStatus.Finished || request.RequestStatus == RequestStatus.Canceled)
                throw new Exception("Cannot reassign ambulance to a completed or canceled request");

            var newAmbulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(newAmbulanceId);
            if (newAmbulance == null) throw new Exception("New ambulance not found");
            if (newAmbulance.AmbulanceStatus != AmbulanceStatus.Available) throw new Exception("New ambulance is not available");

            // Find current active assignment
            var assignments = await unitOfWork.GetRepository<Assignment, int>().GetAllAsync(a => a.RequestId == requestId && a.Status == AssignmentStatus.Pending);
            var currentAssignment = assignments.FirstOrDefault();

            if (currentAssignment != null)
            {
                // Free old ambulance
                var oldAmbulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(currentAssignment.AmbulanceId);
                if (oldAmbulance != null)
                {
                    oldAmbulance.AmbulanceStatus = AmbulanceStatus.Available;
                    unitOfWork.GetRepository<Ambulance, int>().Update(oldAmbulance);
                }

                currentAssignment.Status = AssignmentStatus.Failed; // Or Reassigned if we had that enum
                currentAssignment.Notes += $" Reassigned by Admin {adminId} to Ambulance {newAmbulanceId}";
                unitOfWork.GetRepository<Assignment, int>().Update(currentAssignment);
            }

            // Create new assignment
            var newAssignment = new Assignment
            {
                RequestId = requestId,
                AmbulanceId = newAmbulanceId,
                HospitalId = currentAssignment?.HospitalId,
                AssignedAt = DateTime.UtcNow,
                AssignedBy = adminId,
                AutoAssigned = false,
                Status = AssignmentStatus.Pending,
                Notes = "Manually reassigned by Admin"
            };

            await unitOfWork.GetRepository<Assignment, int>().AddAsync(newAssignment);
            
            newAmbulance.AmbulanceStatus = AmbulanceStatus.Busy;
            unitOfWork.GetRepository<Ambulance, int>().Update(newAmbulance);

            await unitOfWork.SaveChangesAsync();

            // Notify drivers and patient
            await notificationRealTimeSender.BroadcastAmbulanceReassignedAsync(requestId, newAmbulanceId);
            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(requestId, "AmbulanceReassigned", new { NewAmbulanceId = newAmbulanceId });
        }

        public async Task CancelRequestAsync(int requestId, string adminId)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(requestId);
            if (request == null) throw new Exception("Request not found");

            if (request.RequestStatus == RequestStatus.Finished)
                throw new Exception("Cannot cancel a finished request");

            request.RequestStatus = RequestStatus.Canceled;
            request.UpdatedAt = DateTime.UtcNow;
            request.Comment = $"Cancelled by Admin {adminId}";

            unitOfWork.GetRepository<Request, int>().Update(request);

            // Free assigned ambulance if any
            var assignments = await unitOfWork.GetRepository<Assignment, int>().GetAllAsync(a => a.RequestId == requestId && a.Status == AssignmentStatus.Pending);
            var currentAssignment = assignments.FirstOrDefault();
            if (currentAssignment != null)
            {
                var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(currentAssignment.AmbulanceId);
                if (ambulance != null)
                {
                    ambulance.AmbulanceStatus = AmbulanceStatus.Available;
                    unitOfWork.GetRepository<Ambulance, int>().Update(ambulance);
                }
                currentAssignment.Status = AssignmentStatus.Failed;
                unitOfWork.GetRepository<Assignment, int>().Update(currentAssignment);
            }

            await unitOfWork.SaveChangesAsync();

            // Broadcast cancellation
            await notificationRealTimeSender.BroadcastRequestCancelledAsync(requestId);
            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(requestId, "RequestCancelled");
        }

        public async Task<IEnumerable<int>> GetActiveRequestIdsAsync(string userId)
        {
            var activeStatuses = new[] { 
                RequestStatus.Pending, 
                RequestStatus.Assigned, 
                RequestStatus.Accepted, 
                RequestStatus.OnTheWay, 
                RequestStatus.Arrived, 
                RequestStatus.PickedUp, 
                RequestStatus.UnderExecuting 
            };

            // Requests where user is the patient
            var patientRequests = await unitOfWork.GetRepository<Request, int>()
                .GetAllAsync(r => r.UserId == userId && activeStatuses.Contains(r.RequestStatus));

            // Requests where user is the driver
            var driverAssignments = await unitOfWork.GetRepository<Assignment, int>()
                .GetAllAsync(
                    predicate: a => a.Ambulance.DriverId == userId && activeStatuses.Contains(a.Request.RequestStatus),
                    includes: [a => a.Request]
                );

            var requestIds = patientRequests.Select(r => r.Id)
                .Union(driverAssignments.Select(a => a.RequestId))
                .Distinct();

            return requestIds;
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestCardDto>> GetAdminRequestStreamAsync()
        {
            var requests = await unitOfWork.GetRepository<Request, int>()
                .GetAllAsync(
                    predicate: r => r.RequestStatus != RequestStatus.Finished && r.RequestStatus != RequestStatus.Closed && r.RequestStatus != RequestStatus.Canceled,
                    includes: [r => r.ApplicationUser, r => r.AIAnalysis, r => r.Assignments, r => r.AuditLogs]
                );

            return requests.Select(MapToRequestCardDto).OrderByDescending(r => r.CreatedAt);
        }

        private Shared.DTOs.Request.RequestCardDto MapToRequestCardDto(Request r)
        {
            var latestAssignment = r.Assignments.OrderByDescending(a => a.AssignedAt).FirstOrDefault();
            
            var statusStr = r.RequestStatus switch
            {
                RequestStatus.Pending => "Searching",
                RequestStatus.Assigned or RequestStatus.Accepted or RequestStatus.OnTheWay => "Assigned",
                RequestStatus.Arrived => "Arrived",
                RequestStatus.Canceled => "Canceled",
                RequestStatus.Finished or RequestStatus.Closed => "Completed",
                _ => r.RequestStatus.ToString()
            };

            var arrivedLog = r.AuditLogs
                .OrderBy(l => l.Timestamp)
                .FirstOrDefault(l => l.Details.Contains("Arrived") || l.Action.Contains("Arrived"));

            return new Shared.DTOs.Request.RequestCardDto
            {
                Id = r.Id,
                PatientName = r.ApplicationUser?.Name ?? "Unknown",
                Description = r.Description,
                Priority = r.AIAnalysis?.Urgency ?? "Unknown",
                Condition = r.AIAnalysis?.Condition ?? "Unknown",
                Location = r.Address,
                CreatedAt = r.CreatedAt,
                Status = statusStr,
                AmbulanceId = latestAssignment?.AmbulanceId,
                Eta = latestAssignment?.EtaMinutes,
                Timeline = new Shared.DTOs.Request.TimelineDto
                {
                    RequestedAt = r.CreatedAt,
                    SearchingAt = r.CreatedAt,
                    AssignedAt = latestAssignment?.AssignedAt,
                    ArrivedAt = arrivedLog?.Timestamp
                }
            };
        }
        public async Task<Shared.DTOs.Request.AIAnalysisDto?> GetAIAnalysisAsync(int requestId)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetFirstOrDefaultAsync(
                predicate: r => r.Id == requestId,
                includes: r => r.AIAnalysis
            );

            if (request?.AIAnalysis == null) return null;

            return new Shared.DTOs.Request.AIAnalysisDto
            {
                Summary = request.AIAnalysis.Summary,
                Urgency = request.AIAnalysis.Urgency,
                Condition = request.AIAnalysis.Condition,
                Severity = request.AIAnalysis.Severity,
                Confidence = request.AIAnalysis.Confidence
            };
        }
    }
}
