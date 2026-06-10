using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.Hospital;
using Shared.Enums;
using System.Globalization;

using Microsoft.AspNetCore.Identity;

namespace Service
{
    public class HospitalService(IUnitOfWork unitOfWork, INotificationRealTimeSender notificationRealTimeSender, UserManager<ApplicationUser> userManager) : IHospitalService
    {
        public async Task<HospitalDto?> GetByAdminIdAsync(string adminId)
        {
            var user = await userManager.FindByIdAsync(adminId);
            if (user == null || user.HospitalId == null) return null;

            return await GetByIdAsync(user.HospitalId.Value);
        }
        public async Task<HospitalDto> CreateAsync(CreateHospitalDto dto)
        {
            var hospital = new Hospital
            {
                Name = dto.Name,
                Address = dto.Address,
                ContactPhone = dto.ContactPhone,
                Latitude = dto.Latitude,
                Longitude = dto.Longitude,
                BedCapacity = dto.BedCapacity,
                AvailableBeds = dto.BedCapacity,
                ICUCapacity = dto.ICUCapacity,
                AvailableICU = dto.ICUCapacity,
                Status = HospitalStatus.Available,
                StartingPrice = dto.StartingPrice,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<Hospital, int>().AddAsync(hospital);
            await unitOfWork.SaveChangesAsync();

            return MapToDto(hospital);
        }

        public async Task<HospitalDto> GetByIdAsync(int id)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null || hospital.IsDeleted) throw new Exception("Hospital not found");
            return MapToDto(hospital);
        }

        public async Task<IEnumerable<HospitalDto>> GetAllAsync()
        {
            var hospitals = await unitOfWork.GetRepository<Hospital, int>().GetAllAsync(h => !h.IsDeleted);
            return hospitals.Select(MapToDto);
        }

        public async Task<HospitalDto> UpdateAsync(int id, UpdateHospitalDto dto)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null || hospital.IsDeleted) throw new Exception("Hospital not found");

            hospital.Name = dto.Name;
            hospital.Address = dto.Address;
            hospital.ContactPhone = dto.ContactPhone;
            hospital.Latitude = dto.Latitude;
            hospital.Longitude = dto.Longitude;
            hospital.StartingPrice = dto.StartingPrice;
            hospital.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Hospital, int>().Update(hospital);
            await unitOfWork.SaveChangesAsync();

            return MapToDto(hospital);
        }

        public async Task DeleteAsync(int id)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null) return;

            hospital.IsDeleted = true;
            unitOfWork.GetRepository<Hospital, int>().Update(hospital);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task UpdateStatusAsync(int id, HospitalStatus status)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null || hospital.IsDeleted) throw new Exception("Hospital not found");

            hospital.Status = status;
            hospital.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Hospital, int>().Update(hospital);
            await unitOfWork.SaveChangesAsync();

            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(0, "HospitalStatusChanged", new { HospitalId = id, Status = status.ToString() });
        }

        public async Task ToggleAvailabilityAsync(int id)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null || hospital.IsDeleted) throw new Exception("Hospital not found");

            hospital.IsAvailable = !hospital.IsAvailable;
            hospital.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Hospital, int>().Update(hospital);
            await unitOfWork.SaveChangesAsync();

            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(0, "HospitalAvailabilityChanged", new { HospitalId = id, IsAvailable = hospital.IsAvailable });
        }

        public async Task AcceptRejectAssignmentAsync(int assignmentId, AssignmentStatus status)
        {
            var assignment = await unitOfWork.GetRepository<Assignment, int>().GetByIdAsync(assignmentId);
            if (assignment == null) throw new Exception("Assignment not found");

            if (status != AssignmentStatus.Accepted && status != AssignmentStatus.Rejected)
                throw new Exception("Invalid status for this action. Use Accepted or Rejected.");

            assignment.Status = status;
            await unitOfWork.SaveChangesAsync();

            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(assignment.RequestId, "AssignmentStatusChanged", new { AssignmentId = assignmentId, Status = status.ToString() });
        }

        public async Task UpdateCapacityAsync(int id, UpdateHospitalCapacityDto dto)
        {
            var hospital = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(id);
            if (hospital == null || hospital.IsDeleted) throw new Exception("Hospital not found");

            hospital.AvailableBeds = dto.AvailableBeds;
            hospital.BedCapacity = dto.BedCapacity;
            hospital.AvailableICU = dto.AvailableICU;
            hospital.ICUCapacity = dto.ICUCapacity;
            hospital.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Hospital, int>().Update(hospital);
            await unitOfWork.SaveChangesAsync();

            await notificationRealTimeSender.BroadcastRequestUpdatedAsync(0, "HospitalCapacityUpdated", new { HospitalId = id, dto.AvailableBeds, dto.AvailableICU });
        }

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetActiveRequestsAsync(int hospitalId)
        {
            var assignments = await unitOfWork.GetRepository<Assignment, int>()
                .GetAllAsync(
                    predicate: a => a.HospitalId == hospitalId && (a.Status == AssignmentStatus.Pending || a.Status == AssignmentStatus.Accepted),
                    includes: [a => a.Request, a => a.Request.ApplicationUser, a => a.Ambulance]
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

        public async Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetRequestsByHospitalIdAsync(int hospitalId)
        {
            var requests = await unitOfWork.GetRepository<Request, int>()
                .GetAllAsync(
                    predicate: r => r.HospitalId == hospitalId,
                    includes: [r => r.ApplicationUser, r => r.Ambulance]
                );

            return requests.Select(r => new Shared.DTOs.Request.RequestLightweightDto
            {
                Id = r.Id,
                Description = r.Description,
                Address = r.Address,
                RequestStatus = r.RequestStatus,
                CreatedAt = r.CreatedAt,
                PatientName = r.ApplicationUser?.Name ?? "Unknown",
                AssignedAmbulancePlate = r.Ambulance?.AmbulanceNumber
            });
        }

        public async Task<IEnumerable<HospitalWeeklyStatsDto>> GetWeeklyStatisticsAsync(int hospitalId)
        {
            var assignments = await unitOfWork.GetRepository<Assignment, int>()
                .GetAllAsync(predicate: a => a.HospitalId == hospitalId);

            var stats = new List<HospitalWeeklyStatsDto>();
            
            var grouped = assignments
                .Where(a => a.Status != AssignmentStatus.Pending && (a.CompletedAt.HasValue || a.AssignedAt != default))
                .GroupBy(a => 
                {
                    var date = a.CompletedAt ?? a.AssignedAt;
                    var weekInfo = ISOWeek.GetWeekOfYear(date);
                    return new { Year = date.Year, Week = weekInfo };
                });

            foreach (var group in grouped)
            {
                var year = group.Key.Year;
                var week = group.Key.Week;
                var startDate = ISOWeek.ToDateTime(year, week, DayOfWeek.Monday);
                var endDate = startDate.AddDays(6);

                stats.Add(new HospitalWeeklyStatsDto
                {
                    Year = year,
                    WeekNumber = week,
                    TotalCasesAccepted = group.Count(),
                    WeekStartDate = startDate,
                    WeekEndDate = endDate
                });
            }

            return stats.OrderByDescending(s => s.Year).ThenByDescending(s => s.WeekNumber).ToList();
        }

        public async Task<IEnumerable<HospitalDto>> GetNearbyHospitalsAsync(decimal latitude, decimal longitude, double radiusKm = 10.0)
        {
            var hospitals = await unitOfWork.GetRepository<Hospital, int>().GetAllAsync(h => !h.IsDeleted && h.Status == HospitalStatus.Available);
            
            return hospitals
                .Select(h => new { Hospital = h, Distance = Helpers.GeoHelper.CalculateDistance((double)latitude, (double)longitude, (double)h.Latitude, (double)h.Longitude) })
                .Where(x => x.Distance <= radiusKm)
                .OrderBy(x => x.Distance)
                .Select(x => MapToDto(x.Hospital))
                .ToList();
        }

        private HospitalDto MapToDto(Hospital h)
        {
            return new HospitalDto
            {
                Id = h.Id,
                Name = h.Name,
                Address = h.Address,
                ContactPhone = h.ContactPhone,
                Latitude = h.Latitude,
                Longitude = h.Longitude,
                AvailableBeds = h.AvailableBeds,
                BedCapacity = h.BedCapacity,
                AvailableICU = h.AvailableICU,
                ICUCapacity = h.ICUCapacity,
                Status = h.Status,
                IsAvailable = h.IsAvailable,
                StartingPrice = h.StartingPrice
            };
        }
    }
}
