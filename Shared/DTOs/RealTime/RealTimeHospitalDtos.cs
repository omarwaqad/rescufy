namespace Shared.DTOs.RealTime
{
    public class HospitalEmergencyRequestDto
    {
        public int RequestId { get; set; }
        public string PatientName { get; set; } = default!;
        public string PatientPhone { get; set; } = default!;
        public string ConditionSummary { get; set; } = default!;
        public int EtaMinutes { get; set; }
    }
}
