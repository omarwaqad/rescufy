using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.TripReport;
using Shared.Enums;
using System.Threading.Tasks;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TripReportController(ITripReportService tripReportService) : ControllerBase
    {
        /// <summary>
        /// Creates a new medical trip report (Hospital Admin only).
        /// </summary>
        /// <param name="dto">The report creation data</param>
        /// <response code="200">Returns the created report</response>
        /// <response code="403">If the user is not a Hospital Admin</response>
        [HttpPost]
        [Authorize(Roles = nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(TripReportDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> Create([FromBody] CreateTripReportDto dto)
        {
            var result = await tripReportService.CreateTripReportAsync(dto);
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing medical trip report (Hospital Admin only).
        /// </summary>
        /// <param name="id">The report unique identifier</param>
        /// <param name="dto">The updated report data</param>
        /// <response code="200">Returns the updated report</response>
        /// <response code="403">If the user is not a Hospital Admin</response>
        [HttpPut("{id}")]
        [Authorize(Roles = nameof(Roles.HospitalAdmin))]
        [ProducesResponseType(typeof(TripReportDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> Update([FromRoute] int id, [FromBody] UpdateTripReportDto dto)
        {
            var result = await tripReportService.UpdateTripReportAsync(id, dto);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves the trip report associated with a specific emergency request.
        /// </summary>
        /// <param name="requestId">The request unique identifier</param>
        /// <response code="200">Returns the trip report details</response>
        /// <response code="404">If no report exists for this request</response>
        [HttpGet("request/{requestId}")]
        [Authorize]
        [ProducesResponseType(typeof(TripReportDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetByRequestId([FromRoute] int requestId)
        {
            var result = await tripReportService.GetTripReportByRequestIdAsync(requestId);
            return Ok(result);
        }
    }
}
