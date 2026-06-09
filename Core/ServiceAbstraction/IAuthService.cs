using Shared.DTOs.Auth;

namespace ServiceAbstraction
{
    public interface IAuthService
    {
        Task<AuthResult> LoginAsync(LoginRequest request);
        Task<AuthResult> ChangePasswordAsync(ChangePassRequest request);
        Task<string> ForgetPasswordAsync(string email);
        Task<string> VerifyResetPasswordOtpAsync(VerifyOtpRequest dto);
        Task<AuthResult> ResetPasswordAsync(ResetPasswordRequest dto);
        Task<string> RegisterAsync(RegisterRequest dto);
        Task<AuthResult> VerifyRegistrationOtpAsync(VerifyOtpRequest dto);
    }
}
