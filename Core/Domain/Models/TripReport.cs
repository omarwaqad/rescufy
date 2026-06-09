namespace Domain.Models
{
    public class TripReport : BaseEntity<int>
    {
        public int RequestId { get; set; }
        public string PatientId { get; set; } = default!;
        public int HospitalId { get; set; }
        
        public string MedicalProcedures { get; set; } = default!;
        public DateTime AdmissionTime { get; set; }
        public DateTime? DischargeTime { get; set; }
        
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Navigation Properties
        public Request Request { get; set; } = default!;
        public ApplicationUser Patient { get; set; } = default!;
        public Hospital Hospital { get; set; } = default!;
    }
}
