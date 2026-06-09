namespace Shared.DTOs.Auth
{
    public class ChangePassRequest
    {
        public string Email { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }
}
