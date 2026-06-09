namespace Shared.DTOs.AI
{
    public class FeedbackRatingRequestDto
    {
        public string? HospitalFeedback { get; set; }
        public string? AmbulanceFeedback { get; set; }
    }

    public class FeedbackRatingResponseDto
    {
        public int? HospitalRating { get; set; }
        public int? AmbulanceRating { get; set; }
    }
}
