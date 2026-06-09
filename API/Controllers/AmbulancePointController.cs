using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.Enums;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AmbulancePointController(IAmbulancePointService ambulancePointService) : ControllerBase
    {
        /// <summary>
        /// Retrieves the current capacity and vehicle count for a specific ambulance point (Admin only).
        /// </summary>
        /// <param name="id">The ambulance point unique identifier</param>
        /// <response code="200">Returns the capacity details</response>
        /// <response code="404">If the ambulance point is not found</response>
        [HttpGet("{id}/capacity")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(Shared.DTOs.AmbulancePoint.AmbulancePointCapacityDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetCapacity([FromRoute] int id)
        {
            try
            {
                var capacity = await ambulancePointService.GetCapacityAsync(id);
                return Ok(capacity);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
