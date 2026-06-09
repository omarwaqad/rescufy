using Shared.DTOs.AmbulancePoint;

namespace ServiceAbstraction
{
    public interface IAmbulancePointService
    {
        Task<AmbulancePointCapacityDto> GetCapacityAsync(int pointId);
    }
}
