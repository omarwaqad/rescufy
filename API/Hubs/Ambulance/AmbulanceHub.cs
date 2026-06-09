using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using ServiceAbstraction;
using Shared.Enums;
using Shared.DTOs.RealTime;

namespace API.Hubs.Ambulance
{
    [Authorize]
    public class AmbulanceHub(IRequestService requestService) : Hub
    {
        public override async Task OnConnectedAsync()
        {
            var userId = Context.UserIdentifier;
            if (!string.IsNullOrEmpty(userId))
            {
                var activeRequestIds = await requestService.GetActiveRequestIdsAsync(userId);
                foreach (var requestId in activeRequestIds)
                {
                    await Groups.AddToGroupAsync(Context.ConnectionId, $"Request_{requestId}");
                }
            }
            await base.OnConnectedAsync();
        }

        // Manual join for new cases
        public async Task<HubResponseDto> JoinRequestGroup(int requestId)
        {
            try
            {
                var groupName = $"Request_{requestId}";
                await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
                return HubResponseDto.Ok();
            }
            catch (Exception ex)
            {
                return HubResponseDto.Error(ex.Message);
            }
        }

        public async Task<HubResponseDto> LeaveRequestGroup(int requestId)
        {
            try
            {
                var groupName = $"Request_{requestId}";
                await Groups.RemoveFromGroupAsync(Context.ConnectionId, groupName);
                return HubResponseDto.Ok();
            }
            catch (Exception ex)
            {
                return HubResponseDto.Error(ex.Message);
            }
        }

        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        public async Task<HubResponseDto> UpdateLocation(LocationUpdateDto dto)
        {
            try
            {
                var driverId = Context.UserIdentifier;
                if (string.IsNullOrEmpty(driverId)) return HubResponseDto.Error("Unauthorized");

                // Security check: Is this driver assigned to this request?
                var activeRequests = await requestService.GetActiveRequestIdsAsync(driverId);
                if (!activeRequests.Contains(dto.RequestId))
                {
                    return HubResponseDto.Error("You are not assigned to this request.");
                }

                dto.Timestamp = DateTime.UtcNow;
                var groupName = $"Request_{dto.RequestId}";
                
                // Broadcast to others in the group (namely the patient)
                await Clients.OthersInGroup(groupName).SendAsync("ReceiveLocationUpdate", dto);
                
                return HubResponseDto.Ok();
            }
            catch (Exception ex)
            {
                return HubResponseDto.Error(ex.Message);
            }
        }

        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        public async Task<HubResponseDto> AcceptRequest(int requestId)
        {
            try
            {
                var driverId = Context.UserIdentifier;
                if (string.IsNullOrEmpty(driverId)) return HubResponseDto.Error("Unauthorized");

                await requestService.AcceptRequestAsync(requestId, driverId);
                
                // Add driver to the request group since they are now assigned
                await Groups.AddToGroupAsync(Context.ConnectionId, $"Request_{requestId}");

                return HubResponseDto.Ok();
            }
            catch (Exception ex)
            {
                return HubResponseDto.Error(ex.Message);
            }
        }
    }
}
