using Shared.DTOs.Hospital;
using Shared.DTOs.Request;
using Shared.Enums;

namespace ServiceAbstraction
{
    public interface IHospitalService
    {
        // CRUD
        Task<HospitalDto> CreateAsync(CreateHospitalDto dto);
        Task<HospitalDto> GetByIdAsync(int id);
        Task<IEnumerable<HospitalDto>> GetAllAsync();
        Task<HospitalDto> UpdateAsync(int id, UpdateHospitalDto dto);
        Task DeleteAsync(int id);
        Task<HospitalDto?> GetByAdminIdAsync(string adminId);

        // Actions
        Task UpdateStatusAsync(int id, HospitalStatus status);
        Task ToggleAvailabilityAsync(int id);
        Task AcceptRejectAssignmentAsync(int assignmentId, AssignmentStatus status);
        Task UpdateCapacityAsync(int id, UpdateHospitalCapacityDto dto);
        Task<IEnumerable<RequestLightweightDto>> GetActiveRequestsAsync(int hospitalId);
        Task<IEnumerable<RequestLightweightDto>> GetRequestsByHospitalIdAsync(int hospitalId);
        
        // Lookup
        Task<IEnumerable<HospitalDto>> GetNearbyHospitalsAsync(decimal latitude, decimal longitude, double radiusKm = 10.0);
        
        // Stats
        Task<IEnumerable<HospitalWeeklyStatsDto>> GetWeeklyStatisticsAsync(int hospitalId);
    }
}
