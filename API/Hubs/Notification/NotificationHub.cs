using Microsoft.AspNetCore.SignalR;
using Microsoft.AspNetCore.Identity;
using Domain.Models;

namespace API.Hubs.Notification
{
    public class NotificationHub(UserManager<ApplicationUser> userManager) : Hub
    {
        public override async Task OnConnectedAsync()
        {
            var userId = Context.UserIdentifier;
            if (!string.IsNullOrEmpty(userId))
            {
                var user = await userManager.FindByIdAsync(userId);
                if (user?.HospitalId != null)
                {
                    await Groups.AddToGroupAsync(Context.ConnectionId, $"Hospital_{user.HospitalId}");
                }
            }
            await base.OnConnectedAsync();
        }
    }
}
