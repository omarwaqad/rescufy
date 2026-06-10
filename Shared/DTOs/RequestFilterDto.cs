using Shared.Enums;

namespace Shared.DTOs
{
    public class RequestFilterDto
    {
        public string? UserId { get; set; }
        public RequestStatus? RequestStatus { get; set; }
        public bool? IsSelfCase { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? HospitalId { get; set; }
        public string? Severity { get; set; }
        public string? Status { get; set; }
        public string? Last { get; set; }
        public DateTime? From { get; set; }
        public DateTime? To { get; set; }
        public int? WaitingMoreThan { get; set; }
        public bool? RequiresHumanReview { get; set; }
        public string? FailureReason { get; set; }
        public string? Sort { get; set; }
        public int Page { get; set; } = 1;
        public int Limit { get; set; } = 20;
    }
}
