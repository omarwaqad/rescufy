using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServiceAbstraction;
using Shared.DTOs.AI;
using System;
using System.Threading.Tasks;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AIController : ControllerBase
    {
        private readonly IAIService _aiService;

        public AIController(IAIService aiService)
        {
            _aiService = aiService;
        }

        /// <summary>
        /// Unified chatbot endpoint for AI interactions.
        /// </summary>
        /// <param name="request">Chat message and optional context (request, feedback, general)</param>
        /// <returns>Unified AI response</returns>
        [HttpPost("chat")]
        [ProducesResponseType(typeof(ChatResponseDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Chat([FromBody] ChatRequestDto request)
        {
            if (string.IsNullOrWhiteSpace(request.Message))
            {
                return BadRequest("Message cannot be empty.");
            }

            var context = request.Context?.ToLower() ?? "general";
            var responseDto = new ChatResponseDto { Type = context };

            try
            {
                if (context == "request")
                {
                    var result = await _aiService.AnalyzeRequestAsync(request.Message);
                    responseDto.Response = result.Summary;
                    responseDto.RawData = new
                    {
                        result.Urgency,
                        result.Severity,
                        result.Condition,
                        EmergencyType = result.EmergencyType.ToString(),
                        result.Confidence
                    };
                }
                else if (context == "feedback")
                {
                    var feedbackDto = new FeedbackRatingRequestDto
                    {
                        HospitalFeedback = request.Message,
                        AmbulanceFeedback = request.Message
                    };
                    var result = await _aiService.InferRatingsAsync(feedbackDto);
                    responseDto.Response = "Feedback analyzed successfully.";
                    responseDto.RawData = result;
                }
                else // general
                {
                    responseDto.Type = "general";
                    var result = await _aiService.AskGeneralAsync(request.Message);
                    responseDto.Response = result;
                }

                return Ok(responseDto);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "An error occurred while communicating with the AI service.", Details = ex.Message });
            }
        }
    }
}
