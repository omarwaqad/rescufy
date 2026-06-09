namespace Domain.Models
{
    public class Hospital : BaseEntity<int>
    {
        public string Name { get; set; } = default!;
        public string Address { get; set; } = default!;
        public string ContactPhone { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int AvailableBeds { get; set; }
        public int BedCapacity { get; set; }
        public int AvailableICU { get; set; }
        public int ICUCapacity { get; set; }
        public Shared.Enums.HospitalStatus Status { get; set; }
        public bool IsDeleted { get; set; }
        public decimal StartingPrice { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public bool IsAvailable { get; set; } = true;
        public decimal BasePrice { get; set; }
        public int TotalRequests { get; set; }
        public int AcceptedRequests { get; set; }

        // Navigation Properties
        public ICollection<Assignment> Assignments { get; set; } = [];
        public ICollection<TripReport> TripReports { get; set; } = [];
        public ICollection<Feedback> Feedbacks { get; set; } = [];
        public ICollection<Request> Requests { get; set; } = [];
        public ICollection<ApplicationUser> Staff { get; set; } = [];
    }
}
