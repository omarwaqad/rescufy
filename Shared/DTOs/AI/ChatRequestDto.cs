namespace Shared.DTOs.AI
{
    public class ChatRequestDto
    {
        public string Message { get; set; } = string.Empty;
        public string? Context { get; set; } = "general";
    }
}
