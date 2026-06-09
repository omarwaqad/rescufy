using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.TripReport
{
    public class UpdateTripReportDto
    {
        [Required]
        public string MedicalProcedures { get; set; } = default!;
        
        [Required]
        public DateTime AdmissionTime { get; set; }
        
        public DateTime? DischargeTime { get; set; }
    }
}
