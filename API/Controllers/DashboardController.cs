using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.Dashboard;
using Shared.DTOs.Request;
using Shared.Enums;
using System.Security.Claims;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
    public class DashboardController(IDashboardService dashboardService) : ControllerBase
    {
        /// <summary>
        /// Retrieves global system statistics for the dashboard (Admin only).
        /// </summary>
        /// <response code="200">Returns the system statistics (Total users, active requests, etc.)</response>
        /// <response code="403">If the user is not an Admin</response>
        [HttpGet("stats")]
        [ProducesResponseType(typeof(DashboardStatsDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetStats()
        {
            var stats = await dashboardService.GetStatsAsync();
            return Ok(stats);
        }

        /// <summary>
        /// Retrieves a list of critical emergency requests requiring immediate attention (Admin only).
        /// </summary>
        /// <response code="200">Returns a list of critical requests</response>
        /// <response code="403">If the user is not an Admin</response>
        [HttpGet("critical")]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetCritical()
        {
            var requests = await dashboardService.GetCriticalRequestsAsync();
            return Ok(requests);
        }
    }
}
