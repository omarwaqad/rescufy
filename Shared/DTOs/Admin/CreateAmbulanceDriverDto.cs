using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.Admin
{
    public class CreateAmbulanceDriverDto : CreateAdminBaseDto
    {
        [Required(ErrorMessage = "AssignedAmbulanceId is required")]
        public int AssignedAmbulanceId { get; set; }
    }
}
