using Shared.DTOs.Feedback;

namespace ServiceAbstraction
{
    public interface INewFeedbackService
    {
        Task<FeedbackResult<HospitalFeedbackDto>> CreateHospitalFeedbackAsync(string userId, CreateHospitalFeedbackDto dto);
        Task<FeedbackResult<ParamedicFeedbackDto>> CreateParamedicFeedbackAsync(string userId, CreateParamedicFeedbackDto dto);
        Task<FeedbackResult<DriverFeedbackDto>> CreateDriverFeedbackAsync(string userId, CreateDriverFeedbackDto dto);
        Task<IEnumerable<HospitalFeedbackDto>> GetAllHospitalFeedbacksAsync();
        Task<IEnumerable<ParamedicFeedbackDto>> GetAllParamedicFeedbacksAsync();
        Task<IEnumerable<DriverFeedbackDto>> GetAllDriverFeedbacksAsync();
    }
}
