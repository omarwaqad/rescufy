namespace Shared.DTOs.AmbulancePoint
{
    public class AmbulancePointCapacityDto
    {
        public int AmbulancePointId { get; set; }
        public string Name { get; set; } = default!;
        public int NumberOfAvailableAmbulances { get; set; }
        public int TotalAmbulances { get; set; }
    }
}
