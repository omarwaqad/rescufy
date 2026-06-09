using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.Feedback;

namespace Service
{
    public class FeedbackService(IUnitOfWork unitOfWork) : IFeedbackService
    {
        public async Task<FeedbackDto> CreateFeedbackAsync(string userId, CreateFeedbackDto dto)
        {
            var feedback = new Feedback
            {
                UserId = userId,
                Comment = dto.Comment,
                HospitalId = dto.HospitalId,
                AmbulanceId = dto.AmbulanceId,
                Rating = dto.Rating,
                CreatedAt = DateTime.UtcNow,
                TargetType = dto.HospitalId.HasValue ? Shared.Enums.FeedbackTargetType.Hospital : Shared.Enums.FeedbackTargetType.Ambulance,
                TargetId = dto.HospitalId?.ToString() ?? dto.AmbulanceId?.ToString() ?? string.Empty
            };

            await unitOfWork.GetRepository<Feedback, int>().AddAsync(feedback);
            await unitOfWork.SaveChangesAsync();

            // Refetch to include user details
            var savedFeedback = (await unitOfWork.GetRepository<Feedback, int>()
                .GetAllAsync(predicate: f => f.Id == feedback.Id, includes: [f => f.User]))
                .FirstOrDefault();

            return MapToDto(savedFeedback!);
        }

        public async Task<IEnumerable<FeedbackDto>> GetAmbulanceFeedbacksAsync(int ambulanceId)
        {
            var feedbacks = await unitOfWork.GetRepository<Feedback, int>()
                .GetAllAsync(predicate: f => f.AmbulanceId == ambulanceId, includes: [f => f.User]);

            return feedbacks.Select(MapToDto);
        }

        public async Task<IEnumerable<FeedbackDto>> GetHospitalFeedbacksAsync(int hospitalId)
        {
            var feedbacks = await unitOfWork.GetRepository<Feedback, int>()
                .GetAllAsync(predicate: f => f.HospitalId == hospitalId, includes: [f => f.User]);

            return feedbacks.Select(MapToDto);
        }

        private static FeedbackDto MapToDto(Feedback feedback)
        {
            return new FeedbackDto
            {
                Id = feedback.Id,
                UserId = feedback.UserId,
                UserName = feedback.User?.Name ?? "Unknown User",
                Comment = feedback.Comment,
                HospitalId = feedback.HospitalId,
                AmbulanceId = feedback.AmbulanceId,
                Rating = feedback.Rating,
                CreatedAt = feedback.CreatedAt
            };
        }
    }
}
