using Shared.DTOs.Dispatch;
using System.Threading.Tasks;

namespace ServiceAbstraction
{
    public interface IDispatchRealTimeSender
    {
        Task BroadcastRequestEventAsync(EventDto eventDto);
        Task BroadcastAlertAsync(AlertDto alertDto);
    }
}
