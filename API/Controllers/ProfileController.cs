using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.UserProfile;
using System.Security.Claims;
using Shared.Enums;

namespace API.Controllers
{
    [Route("api/profile")]
    [ApiController]
    [Authorize]
    public class ProfileController(IProfileService profileService) : ControllerBase
    {
        /// <summary>
        /// Retrieves the profile of the authenticated user.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     GET /api/profile
        ///     Authorization: Bearer {token}
        /// </remarks>
        /// <response code="200">Returns the user full profile</response>
        /// <response code="401">If the user is not authenticated</response>
        /// <response code="404">If the profile is not found</response>
        [HttpGet]
        [ProducesResponseType(typeof(UserFullProfileDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<IActionResult> GetProfile()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            try
            {
                var profile = await profileService.GetFullProfileAsync(userId);
                return Ok(profile);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Updates the authenticated user's profile.
        /// </summary>
        /// <param name="dto">The updated profile data</param>
        /// <response code="200">Returns the updated profile</response>
        /// <response code="400">If the data is invalid</response>
        [HttpPut]
        [ProducesResponseType(typeof(UserProfileDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UpdateProfile([FromBody] UpdateUserProfileDto dto)
        {
             var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            try
            {
                var profile = await profileService.UpdateProfileAsync(userId, dto);
                return Ok(profile);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Uploads a profile image for the authenticated user.
        /// </summary>
        /// <param name="file">The image file (max 5MB)</param>
        /// <response code="200">Returns the URL of the uploaded image</response>
        /// <response code="400">If the file is invalid or too large</response>
        [HttpPost("image")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> UploadImage(IFormFile file)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            try
            {
                var imageUrl = await profileService.UploadProfileImageAsync(userId, file);
                return Ok(new { ImageUrl = imageUrl });
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Deletes the authenticated user's profile image.
        /// </summary>
        /// <response code="204">Image deleted successfully</response>
        [HttpDelete("image")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteImage()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null) return Unauthorized();

            try
            {
                await profileService.DeleteProfileImageAsync(userId);
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Retrieves the full profile of a specific user (Admin/Self only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <response code="200">Returns the full profile details</response>
        /// <response code="403">If the requester is not authorized to view this profile</response>
        [HttpGet("{id}")]
        [ProducesResponseType(typeof(UserProfileDto), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetUserProfile([FromRoute] string id)
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isUserAdmin = User.IsInRole(nameof(Roles.SuperAdmin)) || User.IsInRole(nameof(Roles.Admin));

            if (currentUserId != id && !isUserAdmin)
            {
                return Forbid();
            }

            try
            {
                var profile = await profileService.GetFullProfileAsync(id);
                return Ok(profile);
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Retrieves the request history of a specific user (Admin/Self only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <response code="200">Returns a list of requests for the user</response>
        /// <response code="403">If not authorized</response>
        [HttpGet("{id}/requests")]
        [ProducesResponseType(typeof(IEnumerable<Shared.DTOs.Request.RequestLightweightDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> GetUserRequests([FromRoute] string id)
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isUserAdmin = User.IsInRole(nameof(Roles.SuperAdmin)) || User.IsInRole(nameof(Roles.Admin));

            if (currentUserId != id && !isUserAdmin)
            {
                return Forbid();
            }

            try
            {
                var history = await profileService.GetUserRequestHistoryAsync(id);
                return Ok(history);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        /// <summary>
        /// Updates medical data for a specific user (Admin/Self only).
        /// </summary>
        /// <param name="id">The user unique identifier</param>
        /// <param name="dto">The medical data updates</param>
        /// <response code="200">Medical data updated successfully</response>
        /// <response code="403">If not authorized</response>
        [HttpPut("{id}/medical-data")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public async Task<IActionResult> UpdateMedicalData([FromRoute] string id, [FromBody] UpdateMedicalDataDto dto)
        {
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var isUserAdmin = User.IsInRole(nameof(Roles.SuperAdmin)) || User.IsInRole(nameof(Roles.Admin));

            if (currentUserId != id && !isUserAdmin)
            {
                return Forbid();
            }

            try
            {
                var result = await profileService.UpdateMedicalDataAsync(id, dto);
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

    }
}
