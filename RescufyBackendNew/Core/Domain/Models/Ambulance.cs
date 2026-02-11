using Shared.Enums;

namespace Domain.Models
{
    public class Ambulance
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public string VehicleInfo { get; set; } = default!;
        public AmbulanceStatus AmbulanceStatus { get; set; } = default!;
        public decimal SimLatitude { get; set; }
        public decimal SimLongitude { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        // Navigation Properties
        public ICollection<Assignment> Assignments { get; set; } = [];
    }
}
