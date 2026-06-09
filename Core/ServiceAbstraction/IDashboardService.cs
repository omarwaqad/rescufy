using Shared.DTOs.Dashboard;
using Shared.DTOs.Request;

namespace ServiceAbstraction
{
    public interface IDashboardService
    {
        Task<DashboardStatsDto> GetStatsAsync();
        Task<IEnumerable<RequestLightweightDto>> GetCriticalRequestsAsync();
    }
}
