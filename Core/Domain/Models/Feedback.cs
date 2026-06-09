namespace Domain.Models
{
    public class Feedback : BaseEntity<int>
    {
        public string UserId { get; set; } = default!;
        public string Comment { get; set; } = default!;
        public int? HospitalId { get; set; }
        public int? AmbulanceId { get; set; }
        public Shared.Enums.FeedbackTargetType TargetType { get; set; }
        public string TargetId { get; set; } = default!;
        public int Rating { get; set; } // 1 to 5
        public int Rate { get => Rating; set => Rating = value; }
        public DateTime CreatedAt { get; set; }

        // Navigation Properties
        public ApplicationUser User { get; set; } = default!;
        public Hospital? Hospital { get; set; }
        public Ambulance? Ambulance { get; set; }
    }
}
