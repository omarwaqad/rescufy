global using Microsoft.AspNetCore.Mvc;
global using System.Security.Claims;
global using Microsoft.AspNetCore.Authorization;

namespace Presentation.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public abstract class ApiController : ControllerBase
    {
        [Authorize]
        protected string GetIdFromToken() => User.FindFirst(ClaimTypes.NameIdentifier)?.Value!;
    }
}