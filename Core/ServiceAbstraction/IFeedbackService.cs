using Shared.DTOs.Feedback;

namespace ServiceAbstraction
{
    public interface IFeedbackService
    {
        Task<FeedbackDto> CreateFeedbackAsync(string userId, CreateFeedbackDto dto);
        Task<IEnumerable<FeedbackDto>> GetHospitalFeedbacksAsync(int hospitalId);
        Task<IEnumerable<FeedbackDto>> GetAmbulanceFeedbacksAsync(int ambulanceId);
    }
}
