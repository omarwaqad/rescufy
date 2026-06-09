using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.UserManagement
{
    public class UpdateUserDto
    {
        [Required]
        public string Name { get; set; } = default!;

        public string? PhoneNumber { get; set; }

        public bool IsBanned { get; set; }
        
        public int? HospitalId { get; set; }
        
        public int? AssignedAmbulanceId { get; set; }
    }
}
