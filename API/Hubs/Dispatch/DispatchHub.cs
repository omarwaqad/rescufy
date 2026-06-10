using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace API.Hubs.Dispatch
{
    [Authorize(Roles = "SuperAdmin,Admin")]
    public class DispatchHub : Hub
    {
        public override async Task OnConnectedAsync()
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, "request-events");
            await Groups.AddToGroupAsync(Context.ConnectionId, "alert-events");
            await base.OnConnectedAsync();
        }

        public override async Task OnDisconnectedAsync(System.Exception? exception)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, "request-events");
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, "alert-events");
            await base.OnDisconnectedAsync(exception);
        }
    }
}
