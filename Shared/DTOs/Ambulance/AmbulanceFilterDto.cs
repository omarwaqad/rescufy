namespace Shared.DTOs.Ambulance
{
    public class AmbulanceFilterDto
    {
        public string? Status { get; set; }
        public int Page { get; set; } = 1;
        public int Limit { get; set; } = 20;
    }
}
