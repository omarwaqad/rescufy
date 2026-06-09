using System;
using System.Text.Json;
using System.Text.Json.Serialization;

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
}

public class Program
{
    public static void Main()
    {
        string json = "{\"model\":\"rescufy_model\",\"created_at\":\"2026-04-30T09:05:15.388826918Z\",\"response\":{\"condition\":\"نزي بارم (Angina)\",\"severity\":\"حرجة\"},\"done\":true}";
        
        var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
        var aiResponse = JsonSerializer.Deserialize<AIResponse>(json, options);
        
        if (aiResponse?.Response != null)
        {
            Console.WriteLine($"Condition: {aiResponse.Response.Condition}");
            Console.WriteLine($"Severity: {aiResponse.Response.Severity}");
            Console.WriteLine("Parse Success!");
        }
        else
        {
            Console.WriteLine("Parse Failed!");
        }
    }
}
