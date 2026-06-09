namespace Domain.Models
{
    public class AmbulancePoint : BaseEntity<int>
    {
        public string Name { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Address { get; set; } = default!;

        // Navigation Properties
        public ICollection<Ambulance> Ambulances { get; set; } = [];
    }
}
