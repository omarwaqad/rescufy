using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.UserManagement
{
    public class CreateUserDto
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = default!;

        [Required]
        public string FullName { get; set; } = default!;

        public string? NationalId { get; set; }

        [Required(ErrorMessage = "Gender is required")]
        [RegularExpression("^(Male|Female)$", ErrorMessage = "Gender must be 'Male' or 'Female'")]
        public string Gender { get; set; } = default!;

        public int? Age { get; set; }

        [Required(ErrorMessage = "Password is required")]
        public string Password { get; set; } = default!;

        [Required(ErrorMessage = "Phone number is required")]
        [Phone(ErrorMessage = "Invalid phone number")]
        public string PhoneNumber { get; set; } = default!;

        public string? Role { get; set; }
    }
}
