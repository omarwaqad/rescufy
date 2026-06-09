namespace Shared.DTOs.Feedback
{
    public class FeedbackDto
    {
        public int Id { get; set; }
        public string UserId { get; set; } = default!;
        public string UserName { get; set; } = default!;
        public string Comment { get; set; } = default!;
        public int? HospitalId { get; set; }
        public int? AmbulanceId { get; set; }
        public int Rating { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
