using Microsoft.AspNetCore.SignalR;
using ServiceAbstraction;
using Shared.DTOs.Dispatch;
using System.Threading.Tasks;

namespace API.Hubs.Dispatch
{
    public class DispatchRealTimeSender(IHubContext<DispatchHub> hubContext) : IDispatchRealTimeSender
    {
        public async Task BroadcastRequestEventAsync(EventDto eventDto)
        {
            await hubContext.Clients.Group("request-events").SendAsync("ReceiveRequestEvent", eventDto);
        }

        public async Task BroadcastAlertAsync(AlertDto alertDto)
        {
            await hubContext.Clients.Group("alert-events").SendAsync("ReceiveAlert", alertDto);
        }
    }
}
