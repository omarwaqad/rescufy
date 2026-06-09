using Microsoft.AspNetCore.SignalR;
using ServiceAbstraction;
using Shared.DTOs.RealTime;

namespace API.Hubs.Notification
{
    public class NotificationRealTimeSender(IHubContext<NotificationHub> hub) : INotificationRealTimeSender
    {
        public async Task SendToUserAsync(string userId, object payload)
        {
            await hub.Clients.User(userId)
                .SendAsync("ReceiveNotification", new RealTimeEventDto<object> 
                { 
                    EventType = "Notification", 
                    Payload = payload 
                });
        }

        public async Task BroadcastRequestCreatedAsync(object payload)
        {
            await hub.Clients.All.SendAsync("RequestCreated", new RealTimeEventDto<object>
            {
                EventType = "RequestCreated",
                Payload = payload
            });
        }

        public async Task BroadcastStatusChangedAsync(int requestId, string status)
        {
            await hub.Clients.All.SendAsync("StatusChanged", new RealTimeEventDto<RequestStatusUpdateDto>
            {
                EventType = "StatusChanged",
                Payload = new RequestStatusUpdateDto { RequestId = requestId, Status = status }
            });
        }

        public async Task BroadcastAmbulanceReassignedAsync(int requestId, int ambulanceId)
        {
            await hub.Clients.All.SendAsync("AmbulanceReassigned", new RealTimeEventDto<object>
            {
                EventType = "AmbulanceReassigned",
                Payload = new { RequestId = requestId, AmbulanceId = ambulanceId }
            });
        }

        public async Task BroadcastRequestCancelledAsync(int requestId)
        {
            await hub.Clients.All.SendAsync("RequestCancelled", new RealTimeEventDto<object>
            {
                EventType = "RequestCancelled",
                Payload = new { RequestId = requestId }
            });
        }

        public async Task BroadcastReportAddedAsync(int requestId, int reportId)
        {
            await hub.Clients.All.SendAsync("ReportAdded", new RealTimeEventDto<object>
            {
                EventType = "ReportAdded",
                Payload = new { RequestId = requestId, ReportId = reportId }
            });
        }

        public async Task BroadcastNewRequestAsync(object payload)
        {
            await hub.Clients.All.SendAsync("NewRequest", new RealTimeEventDto<object>
            {
                EventType = "NewRequest",
                Payload = payload
            });
        }

        public async Task BroadcastRequestUpdatedAsync(int requestId, string updateType, object? additionalData = null)
        {
            await hub.Clients.All.SendAsync("RequestUpdated", new RealTimeEventDto<object>
            {
                EventType = "RequestUpdated",
                Payload = new { RequestId = requestId, UpdateType = updateType, Data = additionalData }
            });
        }

        public async Task SendEmergencyRequestToHospitalAsync(int hospitalId, Shared.DTOs.RealTime.HospitalEmergencyRequestDto payload)
        {
            await hub.Clients.Group($"Hospital_{hospitalId}")
                .SendAsync("ReceiveEmergencyRequest", new RealTimeEventDto<Shared.DTOs.RealTime.HospitalEmergencyRequestDto>
                {
                    EventType = "EmergencyRequest",
                    Payload = payload
                });
        }
    }
}
