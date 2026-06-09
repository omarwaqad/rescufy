namespace Shared.DTOs.TripReport
{
    public class TripReportDto
    {
        public int Id { get; set; }
        public int RequestId { get; set; }
        public string PatientId { get; set; } = default!;
        public string PatientName { get; set; } = default!;
        public int PatientAge { get; set; }
        public string PatientNationalId { get; set; } = default!;

        public int HospitalId { get; set; }
        public string HospitalName { get; set; } = default!;

        public string MedicalProcedures { get; set; } = default!;
        public DateTime AdmissionTime { get; set; }
        public DateTime? DischargeTime { get; set; }
        
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
