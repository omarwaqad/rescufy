using ServiceAbstraction;
using Shared.DTOs.Auth;

namespace Presentation.Controllers
{
    public class AuthController(IAuthService authService) : ApiController
    {

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest request)
        {
            var result = await authService.LoginAsync(request);
            if (!result.Succeeded)
                return Unauthorized();

            return Ok(new { result.Token });
        }
        [HttpPost("register")]
        public async Task<IActionResult> RegisterAsync([FromForm] RegisterRequest dto)
        {
            var message = await authService.RegisterAsync(dto);
            return Ok(new { Message = message });
        }
        [HttpPost("verify-registration-otp")]
        public async Task<IActionResult> VerifyRegistrationOtpAsync([FromBody] VerifyOtpRequest dto)
        {
            var result = await authService.VerifyRegistrationOtpAsync(dto);
            return Ok(new { Message = result });
        }
        [HttpPost("change-password")]
        public async Task<IActionResult> ChangePasswordAsync(ChangePassRequest request)
        {
            var result = await authService.ChangePasswordAsync(request);
            if (!result.Succeeded)
                return BadRequest(result.Message);
            return Ok(new { result.Token });
        }
        [HttpPost("forget-password")]
        public async Task<IActionResult> ForgetPasswordAsync([FromBody] ForgetPasswordRequest dto)
        {
            var result = await authService.ForgetPasswordAsync(dto.Email);
            return Ok(new {Message=result});
        }
        [HttpPost("verify-reset-password-otp")]
        public async Task<IActionResult> VerifyResetPasswordOtpAsync([FromBody] VerifyOtpRequest dto)
        {
            var result= await authService.VerifyResetPasswordOtpAsync(dto);
            return Ok(new {Message=result});
        }
        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPasswordAsync([FromBody] ResetPasswordRequest dto)
        {
            var result = await authService.ResetPasswordAsync(dto);
            if (!result.Succeeded)
                return BadRequest(result.Message);
            return Ok(new { result.Token });
        }
    }
}
