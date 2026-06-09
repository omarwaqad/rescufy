using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.Admin
{
    public class CreateAdminBaseDto
    {
        [Required(ErrorMessage = "Full Name is required")]
        public string FullName { get; set; } = default!;

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress(ErrorMessage = "Invalid email address")]
        public string Email { get; set; } = default!;

        [Required(ErrorMessage = "Password is required")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters")]
        public string Password { get; set; } = default!;

        [Required(ErrorMessage = "Gender is required")]
        public string Gender { get; set; } = default!;
 
        [Required(ErrorMessage = "Phone Number is required")]
        public string PhoneNumber { get; set; } = default!;

        public string? NationalId { get; set; }
 
        public int? Age { get; set; }

        public string? Role { get; set; }
    }
}
