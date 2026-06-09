namespace Domain.Models
{
    public class DriverFeedback : BaseEntity<int>
    {
        public string DriverId { get; set; } = default!;
        public ApplicationUser Driver { get; set; } = default!;
        public int RequestId { get; set; }
        public Request Request { get; set; } = default!;
        public int Rate { get; set; }
        public string Comment { get; set; } = default!;
        public string UserId { get; set; } = default!;
        public ApplicationUser User { get; set; } = default!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
