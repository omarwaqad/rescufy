using System.Text.Json.Serialization;

namespace Shared.DTOs.AI
{
    public class AIRequest
    {
        [JsonPropertyName("model")]
        public string Model { get; set; } = "medical_permanent";

        [JsonPropertyName("prompt")]
        public string Prompt { get; set; } = string.Empty;
    }

    public class AIResponse
    {
        [JsonPropertyName("model")]
        public string? Model { get; set; }

        [JsonPropertyName("response")]
        public AIResponseContent? Response { get; set; }

        [JsonPropertyName("done")]
        public bool Done { get; set; }
    }

    public class AIResponseContent
    {
        [JsonPropertyName("condition")]
        public string? Condition { get; set; }

        [JsonPropertyName("severity")]
        public string? Severity { get; set; }
        
        [JsonPropertyName("urgency")]
        public string? Urgency { get; set; }

        [JsonPropertyName("summary")]
        public string? Summary { get; set; }

        [JsonPropertyName("confidence")]
        public float? Confidence { get; set; }

        [JsonPropertyName("hospitalRating")]
        public float? HospitalRating { get; set; }

        [JsonPropertyName("ambulanceRating")]
        public float? AmbulanceRating { get; set; }
    }
}
