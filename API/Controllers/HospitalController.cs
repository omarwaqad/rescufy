using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.Hospital;
using Shared.Enums;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HospitalController(IHospitalService hospitalService) : ControllerBase
    {
        /// <summary>
        /// Retrieves the hospital associated with the authenticated admin.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /api/hospital/my
        ///     Authorization: Bearer {token}
        /// 
        /// Sample response:
        /// 
        ///     {
        ///       "id": 1,
        ///       "name": "General Hospital",
        ///       "address": "123 Main St",
        ///       "latitude": 40.7128,
        ///       "longitude": -74.0060,
        ///       "phoneNumber": "+1234567890",
        ///       "status": "Available",
        ///       "isAvailable": true
        ///     }
        /// </remarks>
        /// <returns>Hospital details</returns>
        /// <response code="200">Returns the linked hospital</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If no hospital is linked to the account</response>
        [HttpGet("my")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(HospitalDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetMyHospital()
        {
            var hospitalIdClaim = User.FindFirstValue("HospitalId");
            if (!string.IsNullOrEmpty(hospitalIdClaim) && int.TryParse(hospitalIdClaim, out int hospitalId))
            {
                var hospital = await hospitalService.GetByIdAsync(hospitalId);
                return Ok(hospital);
            }

            var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(adminId)) return Unauthorized();

            var result = await hospitalService.GetByAdminIdAsync(adminId);
            if (result == null) return NotFound(new { Message = "No hospital linked to this account." });

            return Ok(result);
        }

        /// <summary>
        /// Retrieves all requests (past and present) for the hospital linked to the authenticated user.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /api/hospital/my-requests
        ///     Authorization: Bearer {token}
        /// </remarks>
        /// <response code="200">Returns a list of requests</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not linked to any hospital</response>
        [HttpGet("my-requests")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetMyRequests()
        {
            var hospitalIdClaim = User.FindFirstValue("HospitalId");
            int? hospitalId = null;

            if (!string.IsNullOrEmpty(hospitalIdClaim) && int.TryParse(hospitalIdClaim, out int id))
            {
                hospitalId = id;
            }
            else
            {
                var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (string.IsNullOrEmpty(adminId)) return Unauthorized();

                var hospital = await hospitalService.GetByAdminIdAsync(adminId);
                hospitalId = hospital?.Id;
            }

            if (hospitalId == null) return StatusCode(StatusCodes.Status403Forbidden, new { Message = "User is not linked to any hospital." });

            var result = await hospitalService.GetRequestsByHospitalIdAsync(hospitalId.Value);
            return Ok(result);
        }

        /// <summary>
        /// Creates a new hospital (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="dto">The hospital data</param>
        /// <response code="200">Returns the created hospital</response>
        /// <response code="400">If the input data is invalid</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not an Admin or SuperAdmin</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(HospitalDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> Create([FromBody] CreateHospitalDto dto)
        {
            var result = await hospitalService.CreateAsync(dto);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves hospital details by ID.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="200">Returns the hospital details</response>
        /// <response code="404">If the hospital is not found</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(HospitalDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetById([FromRoute] int id)
        {
            var result = await hospitalService.GetByIdAsync(id);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves all hospitals in the system.
        /// </summary>
        /// <response code="200">Returns a list of all hospitals</response>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<HospitalDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAll()
        {
            var result = await hospitalService.GetAllAsync();
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing hospital (Admin/SuperAdmin/HospitalAdmin).
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <param name="dto">The updated hospital data</param>
        /// <response code="200">Returns the updated hospital</response>
        /// <response code="400">If the input data is invalid</response>
        /// <response code="403">If the user is not authorized</response>
        /// <response code="404">If the hospital is not found</response>
        [HttpPut("{id}")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(HospitalDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateHospitalDto dto)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            var result = await hospitalService.UpdateAsync(id, dto);
            return Ok(result);
        }

        /// <summary>
        /// Deletes a hospital (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="204">Hospital deleted successfully</response>
        /// <response code="403">If the user is not authorized</response>
        /// <response code="404">If the hospital is not found</response>
        [HttpDelete("{id}")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            await hospitalService.DeleteAsync(id);
            return NoContent();
        }

        /// <summary>
        /// Updates the status of a hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <param name="dto">The status update data</param>
        /// <response code="200">Status updated successfully</response>
        /// <response code="403">If the user is not authorized for this hospital</response>
        [HttpPut("{id}/status")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> UpdateStatus([FromRoute] int id, [FromBody] UpdateHospitalStatusDto dto)
        {
            if (!await CanAccessHospital(id)) return Forbid();
            if (!dto.Status.HasValue) return BadRequest("Status is required.");

            await hospitalService.UpdateStatusAsync(id, dto.Status.Value);
            return Ok(new { Message = "Status updated successfully" });
        }

        /// <summary>
        /// Toggles the general availability of the hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="200">Availability toggled successfully</response>
        /// <response code="403">If the user is not authorized for this hospital</response>
        [HttpPost("{id}/toggle-availability")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> ToggleAvailability([FromRoute] int id)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            await hospitalService.ToggleAvailabilityAsync(id);
            return Ok(new { Message = "Availability toggled successfully" });
        }

        /// <summary>
        /// Updates the patient capacity of a hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <param name="dto">The capacity update data</param>
        /// <response code="200">Capacity updated successfully</response>
        /// <response code="403">If the user is not authorized for this hospital</response>
        [HttpPut("{id}/capacity")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> UpdateCapacity([FromRoute] int id, [FromBody] UpdateHospitalCapacityDto dto)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            await hospitalService.UpdateCapacityAsync(id, dto);
            return Ok(new { Message = "Capacity updated successfully" });
        }

        /// <summary>
        /// Responds to an emergency request assignment (Accept/Reject).
        /// </summary>
        /// <param name="assignmentId">The unique identifier of the assignment</param>
        /// <param name="status">The response status (Accepted or Rejected)</param>
        /// <response code="200">Response processed successfully</response>
        /// <response code="403">If the user is not authorized</response>
        [HttpPost("assignments/{assignmentId}/respond")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> RespondToAssignment([FromRoute] int assignmentId, [FromQuery] AssignmentStatus status)
        {
            await hospitalService.AcceptRejectAssignmentAsync(assignmentId, status);
            return Ok(new { Message = $"Assignment {status} successfully" });
        }

        /// <summary>
        /// Retrieves active requests for a specific hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="200">Returns a list of active requests</response>
        /// <response code="403">If the user is not authorized</response>
        [HttpGet("{id}/active-requests")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetActiveRequests([FromRoute] int id)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            var result = await hospitalService.GetActiveRequestsAsync(id);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves all requests (past and present) for a specific hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="200">Returns a list of all requests</response>
        /// <response code="403">If the user is not authorized</response>
        [HttpGet("{id}/requests")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetAllRequests([FromRoute] int id)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            var result = await hospitalService.GetRequestsByHospitalIdAsync(id);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves weekly statistics for a specific hospital.
        /// </summary>
        /// <param name="id">The hospital unique identifier</param>
        /// <response code="200">Returns the weekly statistics</response>
        /// <response code="403">If the user is not authorized</response>
        [HttpGet("{id}/weekly-stats")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(HospitalWeeklyStatsDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetWeeklyStatistics([FromRoute] int id)
        {
            if (!await CanAccessHospital(id)) return Forbid();

            var stats = await hospitalService.GetWeeklyStatisticsAsync(id);
            return Ok(stats);
        }

        /// <summary>
        /// Retrieves nearby hospitals based on coordinates.
        /// </summary>
        /// <param name="latitude">Current latitude</param>
        /// <param name="longitude">Current longitude</param>
        /// <param name="radiusKm">Search radius in kilometers (default: 10km)</param>
        /// <response code="200">Returns a list of nearby hospitals</response>
        [HttpGet("nearby")]
        [ProducesResponseType(typeof(IEnumerable<HospitalDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetNearby([FromQuery] decimal latitude, [FromQuery] decimal longitude, [FromQuery] double radiusKm = 10.0)
        {
            var result = await hospitalService.GetNearbyHospitalsAsync(latitude, longitude, radiusKm);
            return Ok(result);
        }

        private async Task<bool> CanAccessHospital(int hospitalId)
        {
            if (User.IsInRole(nameof(Roles.SuperAdmin)) || User.IsInRole(nameof(Roles.Admin)))
                return true;

            var hospitalIdClaim = User.FindFirstValue("HospitalId");
            if (!string.IsNullOrEmpty(hospitalIdClaim) && int.TryParse(hospitalIdClaim, out int claimId))
            {
                return claimId == hospitalId;
            }

            var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(adminId)) return false;

            var hospital = await hospitalService.GetByAdminIdAsync(adminId);
            return hospital?.Id == hospitalId;
        }
    }
}
