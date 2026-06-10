using System;

namespace Domain.Models
{
    public class DispatchAlert : BaseEntity<int>
    {
        public int Id { get; set; }
        public string AlertId { get; set; }
        public string Level { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public string Zone { get; set; }
        public string Recommendation { get; set; }
        public DateTime Timestamp { get; set; }
    }
}
