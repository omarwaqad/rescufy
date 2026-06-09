namespace Shared.DTOs.UserProfile
{
    public class MedicationDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = default!;
        public string Dosage { get; set; } = default!;
        public string Frequency { get; set; } = default!;
    }

    public class CreateMedicationDto
    {
        public string Name { get; set; } = default!;
        public string Dosage { get; set; } = default!;
        public string Frequency { get; set; } = default!;
    }

    public class AllergyDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = default!;
        public string Severity { get; set; } = default!;
    }

    public class CreateAllergyDto
    {
        public string Name { get; set; } = default!;
        public string Severity { get; set; } = default!;
    }

    public class ChronicDiseaseDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = default!;
        public string Severity { get; set; } = default!;
        public DateTime DiagnosedDate { get; set; }
    }

    public class CreateChronicDiseaseDto
    {
        public string Name { get; set; } = default!;
        public string Severity { get; set; } = default!;
        public DateTime DiagnosedDate { get; set; }
    }

    public class EmergencyContactDto
    {
        public Guid Id { get; set; }
        public string FullName { get; set; } = default!;
        public string PhoneNumber { get; set; } = default!;
        public string Relation { get; set; } = default!;
        public bool IsActive { get; set; }
    }

    public class CreateEmergencyContactDto
    {
        public string FullName { get; set; } = default!;
        public string PhoneNumber { get; set; } = default!;
        public string Relation { get; set; } = default!;
    }

    public class PastSurgeryDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = default!;
        public int Year { get; set; }
        public string Notes { get; set; } = default!;
    }

    public class CreatePastSurgeryDto
    {
        public string Name { get; set; } = default!;
        public int Year { get; set; }
        public string Notes { get; set; } = default!;
    }
}
