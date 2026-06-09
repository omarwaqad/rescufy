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
        public int? AmbulanceId { get; set; }
        public string? DriverId { get; set; }
        public int? HospitalId { get; set; }
        public DateTime? AssignedAt { get; set; }
        public DateTime? ArrivedAt { get; set; }
        public DateTime? CompletedAt { get; set; }
        public DateTime? EstimatedArrivalTime { get; set; }
        public bool IsAdminIntervention { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string? Comment { get; set; }

        // Navigation Properties
        public ApplicationUser ApplicationUser { get; set; } = default!;
        public AIAnalysis? AIAnalysis { get; set; } = default!;
        public Ambulance? Ambulance { get; set; }
        public ApplicationUser? Driver { get; set; }
        public Hospital? Hospital { get; set; }
        public ICollection<Assignment> Assignments { get; set; } = [];
        public ICollection<AuditLog> AuditLogs { get; set; } = [];
        public TripReport? TripReport { get; set; }
    }

}
