using System;

namespace Shared.DTOs.Dispatch
{
    public class EventDto
    {
        public string RequestId { get; set; }
        public string EventType { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public DateTime Timestamp { get; set; }
        public int? AmbulanceId { get; set; }
    }

    public class AlertDto
    {
        public string AlertId { get; set; }
        public string Level { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public string Zone { get; set; }
        public string Recommendation { get; set; }
        public DateTime Timestamp { get; set; }
    }
}
