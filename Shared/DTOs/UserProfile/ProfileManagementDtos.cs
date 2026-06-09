using System.Collections.Generic;

namespace Shared.DTOs.UserProfile
{
    public class UserFullProfileDto
    {
        // Basic Info
        public string Id { get; set; } = default!;
        public string Name { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string PhoneNumber { get; set; } = default!;
        public string Gender { get; set; } = default!;
        public int Age { get; set; }
        public string NationalId { get; set; } = default!;
        public string? ProfileImageUrl { get; set; }

        // Medical Info
        public string BloodType { get; set; } = default!;
        public float WeightKg { get; set; }
        public float HeightCm { get; set; }
        public bool PregnancyStatus { get; set; }
        public string MedicalNotes { get; set; } = default!;
        public List<MedicationDto> Medications { get; set; } = [];
        public List<AllergyDto> Allergies { get; set; } = [];

        // Role-Specific Info
        public object? RoleSpecificData { get; set; }
    }

    public class UserRequestHistoryDto
    {
        public int RequestId { get; set; }
        public string Status { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
        public string? HospitalName { get; set; }
        public string? AmbulanceNumber { get; set; }
    }

    public class UpdateMedicalDataDto
    {
        public string? BloodType { get; set; }
        public float? WeightKg { get; set; }
        public bool? PregnancyStatus { get; set; }
        public string? MedicalNotes { get; set; }
        public List<string>? Medications { get; set; } // Names of medications
        public List<string>? Allergies { get; set; } // Names of allergies
    }
}
