using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.Ambulance;
using Shared.Enums;
using System.Threading.Tasks;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AmbulanceController(IAmbulanceService ambulanceService) : ControllerBase
    {
        /// <summary>
        /// Retrieves the ambulance assigned to the authenticated driver.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /api/ambulance/my
        ///     Authorization: Bearer {token}
        /// </remarks>
        /// <response code="200">Returns the assigned ambulance details</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If no ambulance is assigned to the driver</response>
        [HttpGet("my")]
        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        [ProducesResponseType(typeof(AmbulanceDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetMyAmbulance()
        {
            var driverId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(driverId)) return Unauthorized();

            try
            {
                var result = await ambulanceService.GetByDriverIdAsync(driverId);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Creates a new ambulance (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="dto">The ambulance creation data</param>
        /// <response code="200">Returns the created ambulance</response>
        /// <response code="400">If the data is invalid</response>
        /// <response code="403">If the user is not authorized</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(AmbulanceDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> Create([FromBody] CreateAmbulanceDto dto)
        {
            var result = await ambulanceService.CreateAsync(dto);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves ambulance details by ID.
        /// </summary>
        /// <param name="id">The ambulance unique identifier</param>
        /// <response code="200">Returns the ambulance details</response>
        /// <response code="404">If the ambulance is not found</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(AmbulanceDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var result = await ambulanceService.GetByIdAsync(id);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves all ambulances in the system.
        /// </summary>
        /// <response code="200">Returns a list of all ambulances</response>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<AmbulanceDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAll()
        {
            var result = await ambulanceService.GetAllAsync();
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing ambulance (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="id">The ambulance unique identifier</param>
        /// <param name="dto">The updated ambulance data</param>
        /// <response code="200">Returns the updated ambulance</response>
        /// <response code="404">If the ambulance is not found</response>
        [HttpPut("{id}")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(AmbulanceDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateAmbulanceDto dto)
        {
            var result = await ambulanceService.UpdateAsync(id, dto);
            return Ok(result);
        }

        /// <summary>
        /// Deletes an ambulance (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="id">The ambulance unique identifier</param>
        /// <response code="204">Ambulance deleted successfully</response>
        /// <response code="404">If the ambulance is not found</response>
        [HttpDelete("{id}")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            await ambulanceService.DeleteAsync(id);
            return NoContent();
        }

        /// <summary>
        /// Assigns staff members (Driver and Paramedic) to an ambulance.
        /// </summary>
        /// <param name="id">The ambulance unique identifier</param>
        /// <param name="driverId">The ID of the User to be assigned as Driver</param>
        /// <param name="paramedicId">The ID of the User to be assigned as Paramedic</param>
        /// <response code="200">Staff assigned successfully</response>
        /// <response code="400">If staff IDs are invalid or users are already assigned elsewhere</response>
        [HttpPost("{id}/assign-staff")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> AssignStaff([FromRoute] int id, [FromQuery] string? driverId, [FromQuery] string? paramedicId)
        {
            await ambulanceService.AssignStaffAsync(id, driverId, paramedicId);
            return Ok(new { Message = "Staff assigned successfully" });
        }
    }
}
