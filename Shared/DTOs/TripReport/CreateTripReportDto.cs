using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.TripReport
{
    public class CreateTripReportDto
    {
        [Required]
        public int RequestId { get; set; }
        
        [Required]
        public int HospitalId { get; set; }
        
        [Required]
        public string MedicalProcedures { get; set; } = default!;
        
        [Required]
        public DateTime AdmissionTime { get; set; }
        
        public DateTime? DischargeTime { get; set; }
    }
}
