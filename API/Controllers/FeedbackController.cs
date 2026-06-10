using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.AI;
using Shared.DTOs.Feedback;
using Shared.Enums;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiExplorerSettings(IgnoreApi = true)]
    public class FeedbackController(IFeedbackService feedbackService, IAIService aiService) : ControllerBase
    {
        /// <summary>
        /// Analyzes patient feedback ratings using AI (Admin only).
        /// </summary>
        /// <param name="dto">The feedback ratings to analyze</param>
        /// <response code="200">Returns the AI analysis report</response>
        [HttpPost("analyze-ratings")]
        [ProducesResponseType(typeof(FeedbackRatingResponseDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AnalyzeRatings([FromBody] FeedbackRatingRequestDto dto)
        {
            var result = await aiService.InferRatingsAsync(dto);
            return Ok(result);
        }

        /// <summary>
        /// Submits new feedback for a hospital or ambulance (User only).
        /// </summary>
        /// <param name="dto">The feedback data (Rating, Comment, Target ID)</param>
        /// <response code="200">Returns the created feedback record</response>
        /// <response code="400">If the data is invalid (e.g., rating out of range)</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.User))]
        [ProducesResponseType(typeof(FeedbackDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CreateFeedback([FromBody] CreateFeedbackDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            if (dto.HospitalId == null && dto.AmbulanceId == null)
                return BadRequest("Feedback must be attached to either a Hospital or an Ambulance.");

            if (dto.Rating < 1 || dto.Rating > 5)
                return BadRequest("Rating must be between 1 and 5.");

            var feedback = await feedbackService.CreateFeedbackAsync(userId, dto);
            return Ok(feedback);
        }

        /// <summary>
        /// Retrieves all feedbacks submitted for a specific hospital.
        /// </summary>
        /// <param name="hospitalId">The hospital unique identifier</param>
        /// <response code="200">Returns a list of feedbacks</response>
        [HttpGet("hospital/{hospitalId}")]
        [ProducesResponseType(typeof(IEnumerable<FeedbackDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetHospitalFeedbacks([FromRoute] int hospitalId)
        {
            var feedbacks = await feedbackService.GetHospitalFeedbacksAsync(hospitalId);
            return Ok(feedbacks);
        }

        /// <summary>
        /// Retrieves all feedbacks submitted for a specific ambulance.
        /// </summary>
        /// <param name="ambulanceId">The ambulance unique identifier</param>
        /// <response code="200">Returns a list of feedbacks</response>
        [HttpGet("ambulance/{ambulanceId}")]
        [ProducesResponseType(typeof(IEnumerable<FeedbackDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAmbulanceFeedbacks([FromRoute] int ambulanceId)
        {
            var feedbacks = await feedbackService.GetAmbulanceFeedbacksAsync(ambulanceId);
            return Ok(feedbacks);
        }
    }
}
