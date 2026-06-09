namespace Domain.Models
{
    public class ParamedicFeedback : BaseEntity<int>
    {
        public string ParamedicId { get; set; } = default!;
        public ApplicationUser Paramedic { get; set; } = default!;
        public int RequestId { get; set; }
        public Request Request { get; set; } = default!;
        public int Rate { get; set; }
        public string Comment { get; set; } = default!;
        public string UserId { get; set; } = default!;
        public ApplicationUser User { get; set; } = default!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
