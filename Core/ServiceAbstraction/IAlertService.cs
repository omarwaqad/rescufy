using Shared.DTOs;
using Shared.DTOs.Dispatch;
using System.Threading.Tasks;

namespace ServiceAbstraction
{
    public interface IAlertService
    {
        Task<PagedResponse<AlertDto>> GetAlertsPagedAsync(int page, int limit);
        Task CreateAlertAsync(AlertDto alert);
    }
}
