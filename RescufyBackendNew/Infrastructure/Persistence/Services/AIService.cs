using Domain.Models;
using ServiceAbstraction;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Persistence.Services
{
    public class AIService : IAIService
    {
        private readonly HttpClient _httpClient;
        private const string ApiUrl = "http://100.91.115.10:11434/api/generate";

        public AIService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<(string Description, string Status, string Severity)> AnalyzeRequestAsync(string description)
        {
            var requestBody = new
            {
                model = "my-arabic-medical-model",
                prompt = description,
                stream = false,
                format = "json"
            };

            var jsonContent = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");

            try
            {
                var response = await _httpClient.PostAsync(ApiUrl, jsonContent);
                response.EnsureSuccessStatusCode();

                var responseString = await response.Content.ReadAsStringAsync();
                
                // Ollama returns a JSON object where the 'response' field contains the actual generation.
                // Example: { "model": "...", "created_at": "...", "response": "{ \"description\": \"...\", ... }", "done": true }
                
                using var document = JsonDocument.Parse(responseString);
                if (document.RootElement.TryGetProperty("response", out var responseProperty))
                {
                    var innerJson = responseProperty.GetString();
                    if (!string.IsNullOrEmpty(innerJson))
                    {
                        var options = new JsonSerializerOptions
                        {
                            PropertyNameCaseInsensitive = true
                        };
                        var aiResponse = JsonSerializer.Deserialize<AIAnalysisResult>(innerJson, options);

                        if (aiResponse != null)
                        {
                            return (aiResponse.Description ?? description, aiResponse.Status ?? "Unknown", aiResponse.Severity ?? "Unknown");
                        }
                    }
                }
                
                // Fallback if parsing fails
                return (description, "Pending", "Normal");
            }
            catch (Exception ex)
            {
                // Log error potentially, but continue with default values for now to avoid breaking the flow
                Console.WriteLine($"AI Service Error: {ex.Message}");
                return (description, "Pending", "Normal");
            }
        }

        private class AIAnalysisResult
        {
            public string? Description { get; set; }
            public string? Status { get; set; }
            public string? Severity { get; set; }
        }
    }
}
