using ServiceAbstraction;
using Shared.DTOs.Auth;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace Presentation.Controllers
{
    [AllowAnonymous]
    public class AuthController(IAuthService authService) : ApiController
    {
        /// <summary>
        /// Authenticates a user and returns a JWT token.
        /// </summary>
        /// <remarks>
        /// Sample request:
        /// 
        ///     POST /api/auth/login
        ///     {
        ///       "email": "user@example.com",
        ///       "password": "Password123!"
        ///     }
        /// </remarks>
        /// <param name="request">The login credentials</param>
        /// <response code="200">Returns the JWT token</response>
        /// <response code="401">If the credentials are invalid</response>
        [HttpPost("login")]
        [ProducesResponseType(typeof(AuthResult), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var result = await authService.LoginAsync(request);
            if (!result.Succeeded)
                return Unauthorized();

            return Ok(new { result.Token });
        }

        /// <summary>
        /// Registers a new user account.
        /// </summary>
        /// <remarks>
        /// This endpoint uses multipart/form-data to support profile image upload.
        /// </remarks>
        /// <param name="dto">The registration data (including optional profile image)</param>
        /// <response code="200">Registration successful, returns success message</response>
        /// <response code="400">If the data is invalid</response>
        [HttpPost("register")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> RegisterAsync([FromForm] RegisterRequest dto)
        {
            var message = await authService.RegisterAsync(dto);
            return Ok(new { Message = message });
        }

        /// <summary>
        /// Verifies the OTP sent during registration.
        /// </summary>
        /// <param name="dto">The verification details (Email and OTP)</param>
        /// <response code="200">Verification successful</response>
        [HttpPost("verify-registration-otp")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> VerifyRegistrationOtpAsync([FromBody] VerifyOtpRequest dto)
        {
            var result = await authService.VerifyRegistrationOtpAsync(dto);
            return Ok(new { Message = result });
        }

        /// <summary>
        /// Changes the password for the authenticated user.
        /// </summary>
        /// <param name="request">The old and new passwords</param>
        /// <response code="200">Password changed successfully, returns a new token</response>
        /// <response code="400">If the old password is incorrect or data is invalid</response>
        [HttpPost("change-password")]
        [ProducesResponseType(typeof(AuthResult), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ChangePasswordAsync([FromBody] ChangePassRequest request)
        {
            var result = await authService.ChangePasswordAsync(request);
            if (!result.Succeeded)
                return BadRequest(result.Message);
            return Ok(new { result.Token });
        }

        /// <summary>
        /// Initiates the forget password flow by sending an OTP.
        /// </summary>
        /// <param name="dto">The user's email</param>
        /// <response code="200">OTP sent successfully</response>
        [HttpPost("forget-password")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> ForgetPasswordAsync([FromBody] ForgetPasswordRequest dto)
        {
            var result = await authService.ForgetPasswordAsync(dto.Email);
            return Ok(new {Message=result});
        }

        /// <summary>
        /// Verifies the OTP sent for password reset.
        /// </summary>
        /// <param name="dto">The verification details (Email and OTP)</param>
        /// <response code="200">OTP verified successfully</response>
        [HttpPost("verify-reset-password-otp")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> VerifyResetPasswordOtpAsync([FromBody] VerifyOtpRequest dto)
        {
            var result= await authService.VerifyResetPasswordOtpAsync(dto);
            return Ok(new {Message=result});
        }

        /// <summary>
        /// Resets the password using the token received after OTP verification.
        /// </summary>
        /// <param name="dto">The new password and reset token</param>
        /// <response code="200">Password reset successfully, returns a new token</response>
        /// <response code="400">If the token is invalid or expired</response>
        [HttpPost("reset-password")]
        [ProducesResponseType(typeof(AuthResult), StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> ResetPasswordAsync([FromBody] ResetPasswordRequest dto)
        {
            var result = await authService.ResetPasswordAsync(dto);
            if (!result.Succeeded)
                return BadRequest(result.Message);
            return Ok(new { result.Token });
        }
    }
}
