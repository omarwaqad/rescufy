using Shared.DTOs.AI;

namespace ServiceAbstraction
{
    public interface IAIService
    {
        Task<(string Summary, string Urgency, string Severity, Shared.Enums.EmergencyType EmergencyType, string Condition, float Confidence)> AnalyzeRequestAsync(string description);
        Task<FeedbackRatingResponseDto> InferRatingsAsync(FeedbackRatingRequestDto request);
        Task<string> AskGeneralAsync(string prompt);
    }
}
