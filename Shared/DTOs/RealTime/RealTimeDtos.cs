namespace Shared.DTOs.RealTime
{
    public class LocationUpdateDto
    {
        public int RequestId { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public DateTime Timestamp { get; set; }
    }

    public class HubResponseDto
    {
        public bool Success { get; set; }
        public string? Message { get; set; }
        public object? Data { get; set; }

        public static HubResponseDto Ok(object? data = null) => new() { Success = true, Data = data };
        public static HubResponseDto Error(string message) => new() { Success = false, Message = message };
    }

    public class RequestStatusUpdateDto
    {
        public int RequestId { get; set; }
        public string Status { get; set; } = string.Empty;
    }

    public class RequestCreatedEventDto
    {
        public int Id { get; set; }
        public string Description { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string RequestStatus { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }

    public class RealTimeEventDto<T>
    {
        public string EventType { get; set; } = string.Empty;
        public T Payload { get; set; } = default!;
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
