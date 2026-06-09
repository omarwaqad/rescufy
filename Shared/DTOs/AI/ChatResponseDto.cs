namespace Shared.DTOs.AI
{
    public class ChatResponseDto
    {
        public string Response { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public object? RawData { get; set; }
    }
}
