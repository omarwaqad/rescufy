using Microsoft.AspNetCore.SignalR;
using ServiceAbstraction;

namespace API.Hubs.Ambulance
{
    public class AmbulanceRealTimeSender : IAmbulanceRealTimeSender
    {
        private readonly IHubContext<AmbulanceHub> _hub;

        public AmbulanceRealTimeSender(IHubContext<AmbulanceHub> hub)
        {
            _hub = hub;
        }

        public async Task SendToUserAsync(string userId, string method, object payload)
        {
            await _hub.Clients.User(userId).SendAsync(method, payload);
        }

        public async Task SendToGroupAsync(string groupName, string method, object payload)
        {
            await _hub.Clients.Group(groupName).SendAsync(method, payload);
        }

        public async Task SendLocationUpdateAsync(string groupName, Shared.DTOs.RealTime.LocationUpdateDto location)
        {
            await _hub.Clients.Group(groupName).SendAsync("ReceiveLocationUpdate", location);
        }
    }
}
