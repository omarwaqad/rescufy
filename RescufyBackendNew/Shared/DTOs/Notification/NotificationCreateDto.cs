using Shared.Enums;

namespace Shared.DTOs.Notification
{
    public class NotificationCreateDto
    {
        public string UserId { get; set; }
        public NotificationType Type { get; set; }
        public string Message { get; set; }
        public object? Data { get; set; }
    }
}
