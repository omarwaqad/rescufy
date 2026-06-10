using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceAbstraction;
using Shared.Enums;
using System.Threading.Tasks;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AlertController(IAlertService alertService) : ControllerBase
    {
        [HttpGet]
        [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
        [ProducesResponseType(typeof(Shared.DTOs.PagedResponse<Shared.DTOs.Dispatch.AlertDto>), Microsoft.AspNetCore.Http.StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAlerts([FromQuery] int page = 1, [FromQuery] int limit = 50)
        {
            var pagedAlerts = await alertService.GetAlertsPagedAsync(page, limit);
            return Ok(pagedAlerts);
        }
    }
}
