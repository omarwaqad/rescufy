namespace Shared.DTOs.Feedback
{
    public class CreateFeedbackDto
    {
        public string Comment { get; set; } = default!;
        public int? HospitalId { get; set; }
        public int? AmbulanceId { get; set; }
        public int Rating { get; set; }
    }
}
