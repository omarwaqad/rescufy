using System;

namespace Domain.Models
{
    public class RequestEvent : BaseEntity<int>
    {
        public int Id { get; set; }
        public int RequestId { get; set; }
        public Request Request { get; set; }
        public string EventType { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public DateTime Timestamp { get; set; }
        public int? AmbulanceId { get; set; }
        public Ambulance Ambulance { get; set; }
    }
}
