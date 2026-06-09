using Shared.Enums;

namespace Shared.DTOs.Hospital
{
    public class HospitalDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public string Address { get; set; } = default!;
        public string ContactPhone { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int AvailableBeds { get; set; }
        public int BedCapacity { get; set; }
        public int AvailableICU { get; set; }
        public int ICUCapacity { get; set; }
        public HospitalStatus Status { get; set; }
        public bool IsAvailable { get; set; }
        public decimal StartingPrice { get; set; }
    }

    public class CreateHospitalDto
    {
        public string Name { get; set; } = default!;
        public string Address { get; set; } = default!;
        public string ContactPhone { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int BedCapacity { get; set; }
        public int ICUCapacity { get; set; }
        public decimal StartingPrice { get; set; }
    }

    public class UpdateHospitalDto
    {
        public string Name { get; set; } = default!;
        public string Address { get; set; } = default!;
        public string ContactPhone { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public decimal StartingPrice { get; set; }
    }

    public class UpdateHospitalCapacityDto
    {
        public int AvailableBeds { get; set; }
        public int BedCapacity { get; set; }
        public int AvailableICU { get; set; }
        public int ICUCapacity { get; set; }
    }

    public class UpdateHospitalStatusDto
    {
        [System.ComponentModel.DataAnnotations.Required]
        public HospitalStatus? Status { get; set; }
    }
}
