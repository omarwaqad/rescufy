using Microsoft.AspNetCore.SignalR;
using ServiceAbstraction;
using System.Collections.Concurrent;

namespace API.Hubs.Ambulance
{
    public class AmbulanceRealTimeSender : IAmbulanceRealTimeSender
    {
        private readonly IHubContext<AmbulanceHub> _hub;

        public static readonly ConcurrentDictionary<string, int> ConnectedDrivers = new();

        public AmbulanceRealTimeSender(IHubContext<AmbulanceHub> hub)
        {
            _hub = hub;
        }

        public bool IsDriverConnected(string driverId)
        {
            return ConnectedDrivers.TryGetValue(driverId, out var count) && count > 0;
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
