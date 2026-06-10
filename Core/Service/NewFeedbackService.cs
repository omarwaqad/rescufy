using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.Feedback;
using Shared.Enums;

namespace Service
{
    public class NewFeedbackService(IUnitOfWork unitOfWork, Microsoft.AspNetCore.Identity.UserManager<ApplicationUser> userManager) : INewFeedbackService
    {
        public async Task<FeedbackResult<HospitalFeedbackDto>> CreateHospitalFeedbackAsync(string userId, CreateHospitalFeedbackDto dto)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(dto.RequestId);
            if (request == null) return new FeedbackResult<HospitalFeedbackDto> { Succeeded = false, Message = "Request not found." };

            // Authorization: User must be the one who made the request
            if (request.UserId != userId)
                return new FeedbackResult<HospitalFeedbackDto> { Succeeded = false, IsForbidden = true, Message = "You are not authorized to provide feedback for this request." };

            // Status Validation: Must be Finished or Closed
            if (request.RequestStatus != Shared.Enums.RequestStatus.Finished && request.RequestStatus != Shared.Enums.RequestStatus.Closed)
                return new FeedbackResult<HospitalFeedbackDto> { Succeeded = false, Message = "Feedback can only be submitted for finished or closed requests." };

            var exists = await unitOfWork.GetRepository<HospitalFeedback, int>().GetFirstOrDefaultAsync(
                f => f.RequestId == dto.RequestId && f.UserId == userId && f.HospitalId == dto.HospitalId);
            if (exists != null) return new FeedbackResult<HospitalFeedbackDto> { Succeeded = false, Message = "Feedback already submitted for this hospital in this request." };

            var feedback = new HospitalFeedback
            {
                HospitalId = dto.HospitalId,
                RequestId = dto.RequestId,
                Rate = dto.Rate,
                Comment = dto.Comment,
                UserId = userId,
                CreatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<HospitalFeedback, int>().AddAsync(feedback);
            await unitOfWork.SaveChangesAsync();

            return new FeedbackResult<HospitalFeedbackDto>
            {
                Succeeded = true,
                Data = new HospitalFeedbackDto
                {
                    Id = feedback.Id,
                    HospitalId = feedback.HospitalId,
                    RequestId = feedback.RequestId,
                    Rate = feedback.Rate,
                    Comment = feedback.Comment,
                    CreatedAt = feedback.CreatedAt
                }
            };
        }

        public async Task<FeedbackResult<ParamedicFeedbackDto>> CreateParamedicFeedbackAsync(string userId, CreateParamedicFeedbackDto dto)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(dto.RequestId);
            if (request == null) return new FeedbackResult<ParamedicFeedbackDto> { Succeeded = false, Message = "Request not found." };

            // Authorization: User must be the one who made the request
            if (request.UserId != userId)
                return new FeedbackResult<ParamedicFeedbackDto> { Succeeded = false, IsForbidden = true, Message = "You are not authorized to provide feedback for this request." };

            // Status Validation: Must be Finished or Closed
            if (request.RequestStatus != Shared.Enums.RequestStatus.Finished && request.RequestStatus != Shared.Enums.RequestStatus.Closed)
                return new FeedbackResult<ParamedicFeedbackDto> { Succeeded = false, Message = "Feedback can only be submitted for finished or closed requests." };

            // Role Validation: Target must be a Paramedic
            var paramedic = await userManager.FindByIdAsync(dto.ParamedicId);
            if (paramedic == null || !await userManager.IsInRoleAsync(paramedic, nameof(Roles.Paramedic)))
                return new FeedbackResult<ParamedicFeedbackDto> { Succeeded = false, Message = "Target user is not a valid Paramedic." };

            var exists = await unitOfWork.GetRepository<ParamedicFeedback, int>().GetFirstOrDefaultAsync(
                f => f.RequestId == dto.RequestId && f.UserId == userId && f.ParamedicId == dto.ParamedicId);
            if (exists != null) return new FeedbackResult<ParamedicFeedbackDto> { Succeeded = false, Message = "Feedback already submitted for this paramedic in this request." };

            var feedback = new ParamedicFeedback
            {
                ParamedicId = dto.ParamedicId,
                RequestId = dto.RequestId,
                Rate = dto.Rate,
                Comment = dto.Comment,
                UserId = userId,
                CreatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<ParamedicFeedback, int>().AddAsync(feedback);
            await unitOfWork.SaveChangesAsync();

            return new FeedbackResult<ParamedicFeedbackDto>
            {
                Succeeded = true,
                Data = new ParamedicFeedbackDto
                {
                    Id = feedback.Id,
                    ParamedicId = feedback.ParamedicId,
                    RequestId = feedback.RequestId,
                    Rate = feedback.Rate,
                    Comment = feedback.Comment,
                    CreatedAt = feedback.CreatedAt
                }
            };
        }

        public async Task<IEnumerable<HospitalFeedbackDto>> GetAllHospitalFeedbacksAsync()
        {
            var feedbacks = await unitOfWork.GetRepository<HospitalFeedback, int>().GetAllAsync();
            return feedbacks.Select(f => new HospitalFeedbackDto
            {
                Id = f.Id,
                HospitalId = f.HospitalId,
                RequestId = f.RequestId,
                Rate = f.Rate,
                Comment = f.Comment,
                CreatedAt = f.CreatedAt
            });
        }

        public async Task<IEnumerable<ParamedicFeedbackDto>> GetAllParamedicFeedbacksAsync()
        {
            var feedbacks = await unitOfWork.GetRepository<ParamedicFeedback, int>().GetAllAsync();
            return feedbacks.Select(f => new ParamedicFeedbackDto
            {
                Id = f.Id,
                ParamedicId = f.ParamedicId,
                RequestId = f.RequestId,
                Rate = f.Rate,
                Comment = f.Comment,
                CreatedAt = f.CreatedAt
            });
        }

        public async Task<IEnumerable<DriverFeedbackDto>> GetAllDriverFeedbacksAsync()
        {
            var feedbacks = await unitOfWork.GetRepository<DriverFeedback, int>().GetAllAsync();
            return feedbacks.Select(f => new DriverFeedbackDto
            {
                Id = f.Id,
                DriverId = f.DriverId,
                RequestId = f.RequestId,
                Rate = f.Rate,
                Comment = f.Comment,
                CreatedAt = f.CreatedAt
            });
        }

        public async Task<FeedbackResult<DriverFeedbackDto>> CreateDriverFeedbackAsync(string userId, CreateDriverFeedbackDto dto)
        {
            var request = await unitOfWork.GetRepository<Request, int>().GetByIdAsync(dto.RequestId);
            if (request == null) return new FeedbackResult<DriverFeedbackDto> { Succeeded = false, Message = "Request not found." };

            // Authorization: User must be the one who made the request
            if (request.UserId != userId)
                return new FeedbackResult<DriverFeedbackDto> { Succeeded = false, IsForbidden = true, Message = "You are not authorized to provide feedback for this request." };

            // Status Validation: Must be Finished or Closed
            if (request.RequestStatus != Shared.Enums.RequestStatus.Finished && request.RequestStatus != Shared.Enums.RequestStatus.Closed)
                return new FeedbackResult<DriverFeedbackDto> { Succeeded = false, Message = "Feedback can only be submitted for finished or closed requests." };

            // Role Validation: Target must be an Ambulance Driver
            var driver = await userManager.FindByIdAsync(dto.DriverId);
            if (driver == null || !await userManager.IsInRoleAsync(driver, nameof(Roles.AmbulanceDriver)))
                return new FeedbackResult<DriverFeedbackDto> { Succeeded = false, Message = "Target user is not a valid Ambulance Driver." };

            var exists = await unitOfWork.GetRepository<DriverFeedback, int>().GetFirstOrDefaultAsync(
                f => f.RequestId == dto.RequestId && f.UserId == userId && f.DriverId == dto.DriverId);
            if (exists != null) return new FeedbackResult<DriverFeedbackDto> { Succeeded = false, Message = "Feedback already submitted for this driver in this request." };

            var feedback = new DriverFeedback
            {
                DriverId = dto.DriverId,
                RequestId = dto.RequestId,
                Rate = dto.Rate,
                Comment = dto.Comment,
                UserId = userId,
                CreatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<DriverFeedback, int>().AddAsync(feedback);
            await unitOfWork.SaveChangesAsync();

            return new FeedbackResult<DriverFeedbackDto>
            {
                Succeeded = true,
                Data = new DriverFeedbackDto
                {
                    Id = feedback.Id,
                    DriverId = feedback.DriverId,
                    RequestId = feedback.RequestId,
                    Rate = feedback.Rate,
                    Comment = feedback.Comment,
                    CreatedAt = feedback.CreatedAt
                }
            };
        }
    }
}
