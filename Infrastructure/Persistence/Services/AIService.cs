using Domain.Models;
using Microsoft.Extensions.Logging;
using ServiceAbstraction;
using Shared.DTOs.AI;
using System.Text;
using System.Text.Json;
using System.Net.Http.Headers;

namespace Persistence.Services
{
    public class AIService : IAIService
    {
        private readonly HttpClient _httpClient;
        private readonly ILogger<AIService> _logger;
        private const string ApiUrl = "https://romisaahassan--medical-model-api-ask-model.modal.run";

        public AIService(HttpClient httpClient, ILogger<AIService> logger)
        {
            _httpClient = httpClient;
            // Production-ready timeout for AI models (cold starts on Modal can be slow)
             _httpClient.Timeout = TimeSpan.FromSeconds(500);
            _logger = logger;
        }

        public async Task<(string Summary, string Urgency, string Severity, Shared.Enums.EmergencyType EmergencyType, string Condition, float Confidence)> AnalyzeRequestAsync(string description)
        {
            _logger.LogInformation("Starting AI analysis for description: {Description}", description);

            var systemPrompt = @"You are a Medical Emergency Analysis Engine.
Analyze the patient's description and return ONLY a JSON object.
JSON Format:
{
  ""summary"": ""brief summary"",
  ""urgency"": ""Low|Medium|High|Critical"",
  ""severity"": ""Mild|Moderate|Severe|LifeThreatening"",
  ""condition"": ""inferred medical condition"",
  ""confidence"": 0.95
}
Patient Description: ";

            var requestBody = new AIRequest
            {
                Model = "medical_permanent",
                Prompt = systemPrompt + description
            };

            try
            {
                var jsonPayload = JsonSerializer.Serialize(requestBody);
                var content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(500));
                var response = await _httpClient.PostAsync(ApiUrl, content, cts.Token);
                
                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("AI API returned error: {StatusCode} - {Reason}", response.StatusCode, response.ReasonPhrase);
                    return GetFallbackResult(description);
                }

                var responseString = await response.Content.ReadAsStringAsync();
                _logger.LogInformation("Raw AI Response Received.");

                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var aiResponse = JsonSerializer.Deserialize<AIResponse>(responseString, options);

                if (aiResponse?.Response != null)
                {
                    var result = aiResponse.Response;
                    
                    // Map severity/urgency to our enums if needed, but here we return strings as per interface
                    var severity = result.Severity ?? "Moderate";
                    var urgency = result.Urgency ?? "Medium";
                    var condition = result.Condition ?? "Awaiting medical evaluation";
                    var summary = result.Summary ?? description;
                    var confidence = result.Confidence ?? 0.0f;

                    // Parse EmergencyType enum
                    Shared.Enums.EmergencyType emergencyType = Shared.Enums.EmergencyType.Medium;
                    if (Enum.TryParse<Shared.Enums.EmergencyType>(urgency, true, out var parsedType))
                    {
                        emergencyType = parsedType;
                    }

                    return (summary, urgency, severity, emergencyType, condition, confidence);
                }

                _logger.LogWarning("AI Response was empty or invalid structure.");
                return GetFallbackResult(description);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred during AI service call.");
                return GetFallbackResult(description);
            }
        }

        private (string Summary, string Urgency, string Severity, Shared.Enums.EmergencyType EmergencyType, string Condition, float Confidence) GetFallbackResult(string description)
        {
            return (description, "Medium", "Moderate", Shared.Enums.EmergencyType.Medium, "Awaiting medical evaluation", 0.0f);
        }

        public async Task<FeedbackRatingResponseDto> InferRatingsAsync(FeedbackRatingRequestDto request)
        {
            var prompt = $"Analyze hospital and ambulance feedback. Return JSON: {{ \"hospitalRating\": 1-5, \"ambulanceRating\": 1-5 }}. Hospital: {request.HospitalFeedback}, Ambulance: {request.AmbulanceFeedback}";

            var requestBody = new AIRequest { Prompt = prompt };

            try
            {
                var content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");
                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(25));
                var response = await _httpClient.PostAsync(ApiUrl, content, cts.Token);
                response.EnsureSuccessStatusCode();

                var responseString = await response.Content.ReadAsStringAsync();
                var aiResponse = JsonSerializer.Deserialize<AIResponse>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

                if (aiResponse?.Response != null)
                {
                    return new FeedbackRatingResponseDto
                    {
                        HospitalRating = (int?)aiResponse.Response.HospitalRating, // Assuming we add this to AIResponseContent or handle dynamically
                        AmbulanceRating = (int?)aiResponse.Response.AmbulanceRating
                    };
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in InferRatingsAsync");
            }

            return new FeedbackRatingResponseDto();
        }

        public async Task<string> AskGeneralAsync(string prompt)
        {
            var requestBody = new AIRequest { Prompt = prompt };

            try
            {
                var content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");
                using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(25));
                var response = await _httpClient.PostAsync(ApiUrl, content, cts.Token);
                response.EnsureSuccessStatusCode();

                var responseString = await response.Content.ReadAsStringAsync();
                var aiResponse = JsonSerializer.Deserialize<AIResponse>(responseString, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

                return aiResponse?.Response?.Condition ?? "No response from AI.";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in AskGeneralAsync");
                return "Error connecting to AI service.";
            }
        }
    }
}
