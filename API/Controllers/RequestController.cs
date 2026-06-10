using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.Enums;
using System.Security.Claims;
using Shared.DTOs;
using Shared.DTOs.Request;
using Domain.Models;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RequestController(IRequestService requestService) : ControllerBase
    {
        /// <summary>
        /// Retrieves a stream of active requests for the Admin dashboard.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /api/request/admin-stream
        ///     Authorization: Bearer {token}
        /// </remarks>
        /// <response code="200">Returns a list of active requests for admin stream</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not an Admin or SuperAdmin</response>
        [HttpGet("admin-stream")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(Shared.DTOs.PagedResponse<Shared.DTOs.Request.RequestCardDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetAdminStream([FromQuery] RequestFilterDto filter)
        {
            var pagedStream = await requestService.GetAdminRequestsPagedAsync(filter);
            return Ok(pagedStream);
        }

        [HttpGet("{id}/events")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(Shared.DTOs.PagedResponse<Shared.DTOs.Dispatch.EventDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetEvents([FromRoute] int id, [FromQuery] int page = 1, [FromQuery] int limit = 50)
        {
            var pagedEvents = await requestService.GetRequestEventsAsync(id, page, limit);
            return Ok(pagedEvents);
        }

        /// <summary>
        /// Creates a new emergency request (User only).
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     POST /api/request
        ///     {
        ///       "description": "Shortness of breath and chest pain",
        ///       "latitude": 30.0444,
        ///       "longitude": 31.2357,
        ///       "address": "Tahrir Square, Cairo",
        ///       "isSelfCase": true,
        ///       "numberOfPeopleAffected": 1
        ///     }
        /// </remarks>
        /// <param name="dto">The request details</param>
        /// <response code="200">Returns the created request with initial AI analysis</response>
        /// <response code="401">If the user is not authenticated</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.User))]
        [ProducesResponseType(typeof(Shared.DTOs.Request.RequestDetailsDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> CreateRequest([FromBody] CreateRequestDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            var request = await requestService.CreateRequestAsync(userId, dto.Description, dto.Latitude, dto.Longitude, dto.Address, dto.IsSelfCase, dto.NumberOfPeopleAffected);
            var details = await requestService.GetRequestByIdAsync(request.Id);
            return Ok(details);
        }

        /// <summary>
        /// Retrieves requests assigned to the authenticated ambulance driver.
        /// </summary>
        /// <response code="200">Returns a list of requests for the driver</response>
        /// <response code="401">If the user is not authenticated</response>
        [HttpGet("driver")]
        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> GetDriverRequests()
        {
            var driverId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (driverId == null) return Unauthorized();

            var requests = await requestService.GetDriverRequestsAsync(driverId);
            return Ok(requests);
        }

        /// <summary>
        /// Retrieves the authenticated user's emergency request history.
        /// </summary>
        /// <param name="filter">Filtering options (startDate, endDate, selfCase, etc.)</param>
        /// <response code="200">Returns the user's request history</response>
        /// <response code="401">If the user is not authenticated</response>
        [HttpGet("history")]
        [Authorize(Roles = nameof(Roles.User))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> GetHistory([FromQuery] RequestFilterDto filter)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            filter.UserId = userId; // Force the filter to only return this user's requests

            var requests = await requestService.GetHistoryAsync(filter);
            return Ok(requests);
        }

        /// <summary>
        /// Retrieves a filtered list of emergency requests.
        /// </summary>
        /// <param name="filter">Filtering options (Status, Date range, etc.)</param>
        /// <response code="200">Returns the filtered list of requests</response>
        [HttpGet]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin) + "," + nameof(Roles.HospitalAdmin) + "," + nameof(Roles.AmbulanceDriver))]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetRequests([FromQuery] RequestFilterDto filter)
        {
            if (User.IsInRole(nameof(Roles.HospitalAdmin)))
            {
                var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (adminId == null) return Unauthorized();
                
                try
                {
                    var hospitalRequests = await requestService.GetHospitalRequestsAsync(adminId, filter);
                    return Ok(hospitalRequests);
                }
                catch (Exception ex)
                {
                    return BadRequest(new { Message = ex.Message });
                }
            }

            var requests = await requestService.GetRequestsAsync(filter);
            return Ok(requests);
        }

        /// <summary>
        /// Retrieves detailed information about a specific request by ID.
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <response code="200">Returns the request details</response>
        /// <response code="403">If the user is a HospitalAdmin not assigned to this request</response>
        /// <response code="404">If the request is not found</response>
        [HttpGet("{id}")]
        [Authorize]
        [ProducesResponseType(typeof(Shared.DTOs.Request.RequestDetailsDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetRequestById([FromRoute] int id)
        {
            try
            {
                var request = await requestService.GetRequestByIdAsync(id);
                
                // Security check for HospitalAdmin
                if (User.IsInRole(nameof(Roles.HospitalAdmin)))
                {
                    var hospitalIdStr = User.FindFirstValue("HospitalId");
                    if (int.TryParse(hospitalIdStr, out var hospitalId))
                    {
                        if (request.Assignments.All(a => a.HospitalId != hospitalId))
                        {
                            return Forbid();
                        }
                    }
                }

                return Ok(request);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Reassigns a request to a different ambulance (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <param name="dto">The reassignment data (New Ambulance ID)</param>
        /// <response code="200">Ambulance reassigned successfully</response>
        /// <response code="400">If the reassignment is invalid (e.g., ambulance busy)</response>
        [HttpPost("{id}/reassign")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ReassignAmbulance([FromRoute] int id, [FromBody] ReassignAmbulanceDto dto)
        {
            var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (adminId == null) return Unauthorized();

            try
            {
                await requestService.ReassignAmbulanceAsync(id, dto.NewAmbulanceId, adminId);
                return Ok(new { Message = "Ambulance reassigned successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Cancels an active emergency request (Admin/SuperAdmin only).
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <response code="200">Request cancelled successfully</response>
        /// <response code="400">If the request cannot be cancelled</response>
        [HttpPost("{id}/cancel")]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CancelRequest([FromRoute] int id)
        {
            var adminId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (adminId == null) return Unauthorized();

            try
            {
                await requestService.CancelRequestAsync(id, adminId);
                return Ok(new { Message = "Request cancelled successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Updates the status of an emergency request (Ambulance Driver only).
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <param name="dto">The status update data (Status, optional Comment)</param>
        /// <response code="200">Returns the updated request</response>
        /// <response code="400">If the status transition is invalid</response>
        [HttpPut("{id}/status")]
        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        [ProducesResponseType(typeof(Request), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UpdateStatus([FromRoute] int id, [FromBody] UpdateRequestStatusDto dto)
        {
            var driverId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (driverId == null) return Unauthorized();

            if (!dto.Status.HasValue) return BadRequest("Status is required.");

            try
            {
                var request = await requestService.UpdateStatusAsync(id, driverId, dto.Status.Value, dto.Comment);
                return Ok(request);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Accepts a pending emergency request (Ambulance Driver only).
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <response code="200">Request accepted successfully</response>
        /// <response code="400">If the request is no longer available</response>
        [HttpPost("{id}/accept")]
        [Authorize(Roles = nameof(Roles.AmbulanceDriver))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> AcceptRequest([FromRoute] int id)
        {
            var driverId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (driverId == null) return Unauthorized();

            try
            {
                await requestService.AcceptRequestAsync(id, driverId);
                return Ok(new { Message = "Request accepted successfully" });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Adds a medical report for a completed request (Hospital Admin only).
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <param name="dto">The report data (Treatment, Times)</param>
        /// <param name="tripReportService">Injected TripReport service</param>
        /// <response code="200">Report added successfully</response>
        /// <response code="403">If the hospital is not assigned to this request</response>
        [HttpPost("{id}/report")]
        [Authorize(Roles = nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> AddReport([FromRoute] int id, [FromBody] HospitalReportRequestDto dto, [FromServices] ITripReportService tripReportService)
        {
            var hospitalIdStr = User.FindFirstValue("HospitalId");
            if (!int.TryParse(hospitalIdStr, out var hospitalId)) return Forbid();

            // Additional verification that this request was actually assigned to this hospital
            var request = await requestService.GetRequestByIdAsync(id);
            if (request.Assignments.All(a => a.HospitalId != hospitalId)) return Forbid();

            try
            {
                var reportDto = new Shared.DTOs.TripReport.CreateTripReportDto
                {
                    RequestId = id,
                    HospitalId = hospitalId,
                    AdmissionTime = dto.ArrivedAt,
                    DischargeTime = dto.DischargedAt,
                    MedicalProcedures = dto.Treatment
                };

                var result = await tripReportService.CreateTripReportAsync(reportDto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Retrieves the AI-generated analysis for a specific request.
        /// </summary>
        /// <param name="id">The request unique identifier</param>
        /// <response code="200">Returns the AI analysis (Summary, Urgency, Condition)</response>
        /// <response code="404">If analysis is not available</response>
        [HttpGet("{id}/analysis")]
        [Authorize]
        [ProducesResponseType(typeof(Shared.DTOs.Request.AIAnalysisDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetAIAnalysis([FromRoute] int id)
        {
            var analysis = await requestService.GetAIAnalysisAsync(id);
            if (analysis == null) return NotFound("AI Analysis not found for this request.");
            return Ok(analysis);
        }
    }
}
