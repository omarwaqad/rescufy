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
    public class DriverFeedbackController(INewFeedbackService feedbackService) : ControllerBase
    {
        /// <summary>
        /// Retrieves all driver feedbacks (Admin only).
        /// </summary>
        /// <response code="200">Returns a list of all driver feedbacks</response>
        [HttpGet]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(IEnumerable<DriverFeedbackDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAll()
        {
            var result = await feedbackService.GetAllDriverFeedbacksAsync();
            return Ok(result);
        }

        /// <summary>
        /// Submits new feedback for a driver.
        /// </summary>
        /// <param name="dto">The feedback details</param>
        /// <response code="200">Returns the created feedback</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.User))]
        [ProducesResponseType(typeof(DriverFeedbackDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> Create([FromBody] CreateDriverFeedbackDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var result = await feedbackService.CreateDriverFeedbackAsync(userId, dto);
            if (!result.Succeeded)
            {
                if (result.IsForbidden) return Forbid();
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }
    }
}
