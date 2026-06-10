using Shared.DTOs.Ambulance;

namespace ServiceAbstraction
{
    public interface IAmbulanceService
    {
        Task<AmbulanceDto> CreateAsync(CreateAmbulanceDto dto);
        Task<AmbulanceDto> GetByIdAsync(int id);
        Task<IEnumerable<AmbulanceDto>> GetAllAsync();
        Task<Shared.DTOs.PagedResponse<AmbulanceDto>> GetAllPagedAsync(Shared.DTOs.Ambulance.AmbulanceFilterDto filter);
        Task<AmbulanceDto> UpdateAsync(int id, UpdateAmbulanceDto dto);
        Task DeleteAsync(int id);

        // Paramedic features
        Task<AmbulanceDto> GetByDriverIdAsync(string driverId);
        Task SetActiveStatusAsync(string driverId, bool isActive);
        Task AssignStaffAsync(int ambulanceId, string? driverId, string? paramedicId);
    }
}
