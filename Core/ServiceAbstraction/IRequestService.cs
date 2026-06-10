using Domain.Models;
using Shared.DTOs;

namespace ServiceAbstraction
{
    public interface IRequestService
    {
        Task<Request> CreateRequestAsync(string userId, string description, decimal latitude, decimal longitude, string address, bool isSelfCase, int numberOfPeopleAffected);
        Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetDriverRequestsAsync(string driverId);
        Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetRequestsAsync(RequestFilterDto filter);
        Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetHistoryAsync(RequestFilterDto filter);
        Task<IEnumerable<Shared.DTOs.Request.RequestLightweightDto>> GetHospitalRequestsAsync(string hospitalAdminId, RequestFilterDto filter);
        Task<Shared.DTOs.Request.RequestDetailsDto> GetRequestByIdAsync(int id);
        Task<Request> UpdateStatusAsync(int requestId, string driverId, Shared.Enums.RequestStatus newStatus, string? comment = null);
        Task ReassignAmbulanceAsync(int requestId, int newAmbulanceId, string adminId);
        Task CancelRequestAsync(int requestId, string adminId);
        Task<IEnumerable<int>> GetActiveRequestIdsAsync(string userId);
        Task AcceptRequestAsync(int requestId, string driverId);
        Task<PagedResponse<Shared.DTOs.Request.RequestCardDto>> GetAdminRequestsPagedAsync(RequestFilterDto filter);
        Task<PagedResponse<Shared.DTOs.Dispatch.EventDto>> GetRequestEventsAsync(int requestId, int page, int limit);
        Task<Shared.DTOs.Request.AIAnalysisDto?> GetAIAnalysisAsync(int requestId);
    }
}
