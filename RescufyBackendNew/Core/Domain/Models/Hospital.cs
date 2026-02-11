namespace Domain.Models
{
    public class Hospital : BaseEntity<int>
    {
        public string Name { get; set; } = default!;
        public string Address { get; set; } = default!;
        public string ContactPhone { get; set; } = default!;
        public string CapacityNotes { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Navigation Properties
        public ICollection<Assignment> Assignments { get; set; } = [];
    }
}
