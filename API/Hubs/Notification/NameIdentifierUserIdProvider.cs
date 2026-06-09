using Microsoft.AspNetCore.SignalR;

namespace API.Hubs.Notification
{
    public class NameIdentifierUserIdProvider : IUserIdProvider
    {
        public string? GetUserId(HubConnectionContext connection)
        {
            return connection.User?.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value
                ?? connection.User?.FindFirst("sub")?.Value
                ?? connection.User?.FindFirst("id")?.Value
                ?? connection.UserIdentifier;
        }
    }
}
