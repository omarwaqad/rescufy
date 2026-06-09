namespace Shared.DTOs.Feedback
{
    public class FeedbackResult<T>
    {
        public bool Succeeded { get; set; }
        public T? Data { get; set; }
        public string? Message { get; set; }
        public bool IsForbidden { get; set; }
    }
}
