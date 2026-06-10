using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceAbstraction;
using Shared.DTOs.Feedback;
using System.Security.Claims;
using Shared.Enums;
using Microsoft.AspNetCore.Http;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ParamedicFeedbackController(INewFeedbackService feedbackService) : ControllerBase
    {
        /// <summary>
        /// Retrieves all paramedic feedbacks (Admin only).
        /// </summary>
        /// <response code="200">Returns a list of all paramedic feedbacks</response>
        [HttpGet]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(IEnumerable<ParamedicFeedbackDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAll()
        {
            var result = await feedbackService.GetAllParamedicFeedbacksAsync();
            return Ok(result);
        }

        /// <summary>
        /// Submits new feedback for a paramedic.
        /// </summary>
        /// <param name="dto">The feedback details</param>
        /// <response code="200">Returns the created feedback</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.User))]
        [ProducesResponseType(typeof(ParamedicFeedbackDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> Create([FromBody] CreateParamedicFeedbackDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var result = await feedbackService.CreateParamedicFeedbackAsync(userId, dto);
            if (!result.Succeeded)
            {
                if (result.IsForbidden) return Forbid();
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }
    }
}
