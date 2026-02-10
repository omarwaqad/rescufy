using Shared.Enums;

namespace Domain.Models
{
    public class AIAnalysis : BaseEntity<int>
    {
        public int RequestId { get; set; }
        public string Summary { get; set; } = default!;

        public EmergencyType EmergencyType { get; set; } = default!;
        public string Urgency { get; set; } = default!;
        public float Confidence { get; set; }
        public DateTime CreatedAt { get; set; }

        // Navigation Properties
        public Request Request { get; set; } = default!;
    }

}