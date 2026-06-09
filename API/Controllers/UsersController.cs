using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.UserManagement;
using Shared.Enums;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = nameof(Roles.Admin) + "," + nameof(Roles.SuperAdmin))]
    public class UsersController(IUserService userService) : ControllerBase
    {
        /// <summary>
        /// Retrieves a list of all users, optionally filtered by role (SuperAdmin only).
        /// </summary>
        /// <param name="role">Optional role name to filter by</param>
        /// <response code="200">Returns the list of users</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="403">If the user is not a SuperAdmin</response>
        [HttpGet]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.UserManagement.UserDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetAllUsers([FromQuery] string? role)
        {
            var users = await userService.GetAllUsersAsync(role);
            return Ok(users);
        }

        /// <summary>
        /// Retrieves a specific user by their unique ID (SuperAdmin only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <response code="200">Returns the user details</response>
        /// <response code="404">If the user is not found</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(Shared.DTOs.UserManagement.UserDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetUserById([FromRoute] string id)
        {
            try
            {
                var user = await userService.GetUserByIdAsync(id);
                return Ok(user);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Creates a new user with a specified role (SuperAdmin only).
        /// </summary>
        /// <param name="dto">The user creation data</param>
        /// <response code="201">User created successfully</response>
        /// <response code="400">If the input data or role is invalid</response>
        [HttpPost]
        [ProducesResponseType(typeof(Shared.DTOs.UserManagement.UserDto), StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> CreateUser([FromBody] CreateUserDto dto)
        {
            try
            {
                var user = await userService.CreateUserAsync(dto);
                return CreatedAtAction(nameof(GetUserById), new { id = user.Id }, user);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Updates an existing user's information (SuperAdmin only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <param name="dto">The updated user data</param>
        /// <response code="200">User updated successfully</response>
        /// <response code="404">If the user is not found</response>
        [HttpPut("{id}")]
        [ProducesResponseType(typeof(Shared.DTOs.UserManagement.UserDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> UpdateUser([FromRoute] string id, [FromBody] UpdateUserDto dto)
        {
             try
            {
                var user = await userService.UpdateUserAsync(id, dto);
                return Ok(user);
            }
            catch (Exception ex)
            {
                // Determine if not found or other error. For simplicity, generic bad request or not found based on message
                if (ex.Message == "User not found") return NotFound(ex.Message);
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Deletes a user from the system (SuperAdmin only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <response code="204">User deleted successfully</response>
        /// <response code="404">If the user is not found</response>
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> DeleteUser([FromRoute] string id)
        {
            try
            {
                await userService.DeleteUserAsync(id);
                return NoContent();
            }
            catch (Exception ex)
            {
                if (ex.Message == "User not found") return NotFound(ex.Message);
                return BadRequest(ex.Message);
            }
        }
    }
}
