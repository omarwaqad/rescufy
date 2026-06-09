namespace Domain.Models
{
    public class AuditLog : BaseEntity<int>
    {
        public int? RequestId { get; set; }
        public string ActorId { get; set; } = default!;
        public string Action { get; set; } = default!;
        public string Details { get; set; } = default!;
        public DateTime Timestamp { get; set; }

        // Navigation Properties
        public Request Request { get; set; } = default!;
        public ApplicationUser ApplicationUser { get; set; } = default!;
    }
}