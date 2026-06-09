namespace ServiceAbstraction
{
    public interface IAmbulanceRealTimeSender
    {
        Task SendToUserAsync(string userId, string method, object payload);
        Task SendToGroupAsync(string groupName, string method, object payload);
        Task SendLocationUpdateAsync(string groupName, Shared.DTOs.RealTime.LocationUpdateDto location);
    }
}
