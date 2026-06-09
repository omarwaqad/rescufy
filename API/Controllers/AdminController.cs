using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceAbstraction;
using Shared.DTOs.Admin;
using Shared.Enums;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = nameof(Roles.SuperAdmin))] // Securing the endpoint to SuperAdmin only, based on typical system structure
    public class AdminController(IUserService userService) : ControllerBase
    {
        /// <summary>
        /// Creates a new Hospital Admin user and assigns them to a hospital.
        /// </summary>
        [HttpPost("create-hospital-admin")]

        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CreateHospitalAdmin([FromBody] CreateHospitalAdminDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                var user = await userService.CreateHospitalAdminAsync(dto);
                return CreatedAtAction(nameof(UsersController.GetUserById), "Users", new { id = user.Id }, user);
            }
            catch (ArgumentException ex)
            {
                if (ex.Message.Contains("not found", StringComparison.OrdinalIgnoreCase))
                    return NotFound(new { Message = ex.Message });
                
                if (ex.Message.Contains("already registered", StringComparison.OrdinalIgnoreCase))
                    return Conflict(new { Message = ex.Message });

                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "An error occurred while creating the Hospital Admin.", Details = ex.Message });
            }
        }

        /// <summary>
        /// Creates a new Ambulance Driver user and assigns them to an ambulance.
        /// </summary>
        [HttpPost("create-ambulance-driver")]

        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CreateAmbulanceDriver([FromBody] CreateAmbulanceDriverDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                var user = await userService.CreateAmbulanceDriverAsync(dto);
                return CreatedAtAction(nameof(UsersController.GetUserById), "Users", new { id = user.Id }, user);
            }
            catch (ArgumentException ex)
            {
                if (ex.Message.Contains("not found", StringComparison.OrdinalIgnoreCase))
                    return NotFound(new { Message = ex.Message });
                
                if (ex.Message.Contains("already registered", StringComparison.OrdinalIgnoreCase))
                    return Conflict(new { Message = ex.Message });

                return BadRequest(new { Message = ex.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Message = "An error occurred while creating the Ambulance Driver.", Details = ex.Message });
            }
        }
    }
}
