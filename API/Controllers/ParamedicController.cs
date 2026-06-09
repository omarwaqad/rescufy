using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.Enums;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = nameof(Roles.AmbulanceDriver) + "," + nameof(Roles.Paramedic))]
    public class ParamedicController(IAmbulanceService ambulanceService, IRequestService requestService) : ControllerBase
    {
        private string? CurrentUserId => User.FindFirstValue(ClaimTypes.NameIdentifier);

        /// <summary>
        /// Retrieves the paramedic's assigned ambulance profile.
        /// </summary>
        /// <response code="200">Returns the ambulance profile</response>
        /// <response code="404">If no ambulance is assigned to this paramedic</response>
        [HttpGet("profile")]
        [ProducesResponseType(typeof(Shared.DTOs.Ambulance.AmbulanceDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetProfile()
        {
            if (CurrentUserId == null) return Unauthorized();
            try
            {
                var profile = await ambulanceService.GetByDriverIdAsync(CurrentUserId);
                return Ok(profile);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Updates the paramedic's active/inactive status.
        /// </summary>
        /// <param name="isActive">True if active and ready for requests, False otherwise</param>
        /// <response code="200">Status updated successfully</response>
        [HttpPut("status")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateStatus([FromBody] bool isActive)
        {
            if (CurrentUserId == null) return Unauthorized();
            try
            {
                await ambulanceService.SetActiveStatusAsync(CurrentUserId, isActive);
                return Ok(new { Message = $"Status updated to {(isActive ? "Active" : "Inactive")}" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Retrieves the history of emergency requests handled by this paramedic.
        /// </summary>
        /// <response code="200">Returns a list of requests</response>
        [HttpGet("requests")]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetRequestHistory()
        {
            if (CurrentUserId == null) return Unauthorized();
            var requests = await requestService.GetDriverRequestsAsync(CurrentUserId);
            return Ok(requests);
        }
    }
}
