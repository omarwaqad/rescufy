using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.Admin
{
    public class CreateHospitalAdminDto : CreateAdminBaseDto
    {
        [Required(ErrorMessage = "HospitalId is required")]
        public int HospitalId { get; set; }
    }
}
