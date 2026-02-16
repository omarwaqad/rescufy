using RequestStatus = Shared.Enums.RequestStatus;

namespace Domain.Models
{
    public class Request : BaseEntity<int>
    {
        public string UserId { get; set; } = default!;
        public bool IsSelfCase { get; set; }
        public string Description { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Address { get; set; } = default!;
        public int NumberOfPeopleAffected { get; set; }
        public RequestStatus RequestStatus { get; set; }
        public int? AnalysisId { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Navigation Properties
        public ApplicationUser ApplicationUser { get; set; } = default!;
        public AIAnalysis AIAnalysis { get; set; } = default!;
        public ICollection<Assignment> Assignments { get; set; } = [];
        public ICollection<AuditLog> AuditLogs { get; set; } = [];
    }

}
