namespace ServiceAbstraction
{
    public interface INotificationRealTimeSender
    {
        Task SendToUserAsync(string userId, object payload);
        Task BroadcastRequestCreatedAsync(object payload);
        Task BroadcastStatusChangedAsync(int requestId, string status);
        Task BroadcastAmbulanceReassignedAsync(int requestId, int ambulanceId);
        Task BroadcastRequestCancelledAsync(int requestId);
        Task BroadcastReportAddedAsync(int requestId, int reportId);
        Task BroadcastNewRequestAsync(object payload);
        Task BroadcastRequestUpdatedAsync(int requestId, string updateType, object? additionalData = null);
        Task SendEmergencyRequestToHospitalAsync(int hospitalId, Shared.DTOs.RealTime.HospitalEmergencyRequestDto payload);
    }
}
