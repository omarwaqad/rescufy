using Microsoft.AspNetCore.Http;

namespace Shared.DTOs.Auth
{
    public class RegisterRequest
    {
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;

        [System.ComponentModel.DataAnnotations.Required]
        [System.ComponentModel.DataAnnotations.StringLength(14, MinimumLength = 14, ErrorMessage = "National ID must be exactly 14 digits")]
        [System.ComponentModel.DataAnnotations.RegularExpression("^[0-9]*$", ErrorMessage = "National ID must be numeric")]
        public string NationalId { get; set; } = default!;

        [System.ComponentModel.DataAnnotations.Required]
        [System.ComponentModel.DataAnnotations.RegularExpression("^(Male|Female)$", ErrorMessage = "Gender must be 'Male' or 'Female'")]
        public string Gender { get; set; } = default!;

        [System.ComponentModel.DataAnnotations.Required]
        [System.ComponentModel.DataAnnotations.Range(1, 120, ErrorMessage = "Age must be between 1 and 120")]
        public int Age { get; set; }
        
        public IFormFile? ProfileImage { get; set; }
    }
}
