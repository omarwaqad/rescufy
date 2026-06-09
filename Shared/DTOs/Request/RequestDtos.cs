using Shared.Enums;

namespace Shared.DTOs.Request
{
    public class RequestLightweightDto
    {
        public int Id { get; set; }
        public string Description { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public RequestStatus RequestStatus { get; set; }
        public DateTime CreatedAt { get; set; }
        public string PatientName { get; set; } = string.Empty;
        public string? AssignedAmbulancePlate { get; set; }
    }

    public class RequestDetailsDto
    {
        public int Id { get; set; }
        public string UserId { get; set; } = default!;
        public string PatientName { get; set; } = default!;
        public string PatientPhone { get; set; } = default!;
        public bool IsSelfCase { get; set; }
        public string Description { get; set; } = default!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Address { get; set; } = default!;
        public int NumberOfPeopleAffected { get; set; }
        public RequestStatus RequestStatus { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string? Comment { get; set; }

        public PatientDto Patient { get; set; } = new();
        public AIAnalysisDto? AIAnalysis { get; set; }
        public List<AssignmentDto> Assignments { get; set; } = [];
        public TripReportDetailsDto? TripReport { get; set; }
    }

    public class PatientDto
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public UserProfileDto? Profile { get; set; }
    }

    public class UserProfileDto
    {
        public string BloodType { get; set; } = string.Empty;
        public float WeightKg { get; set; }
        public float HeightCm { get; set; }
        public bool PregnancyStatus { get; set; }
        public string MedicalNotes { get; set; } = string.Empty;
        public List<ChronicDiseaseDto> ChronicDiseases { get; set; } = [];
        public List<AllergyDto> Allergies { get; set; } = [];
        public List<MedicationDto> Medications { get; set; } = [];
        public List<PastSurgeryDto> PastSurgeries { get; set; } = [];
    }

    public class ChronicDiseaseDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    public class AllergyDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    public class MedicationDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    public class PastSurgeryDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; } = string.Empty;
    }

    public class AIAnalysisDto
    {
        public string Summary { get; set; } = string.Empty;
        public string Urgency { get; set; } = string.Empty;
        public string Condition { get; set; } = string.Empty;
        public string Severity { get; set; } = string.Empty;
        public float Confidence { get; set; }
    }

    public class AssignmentDto
    {
        public int Id { get; set; }
        public string AmbulancePlate { get; set; } = string.Empty;
        public string DriverName { get; set; } = string.Empty;
        public int? HospitalId { get; set; }
        public string? HospitalName { get; set; }
        public DateTime AssignedAt { get; set; }
        public DateTime? CompletedAt { get; set; }
        public float DistanceKm { get; set; }
        public AssignmentStatus Status { get; set; }
    }

    public class TripReportDetailsDto
    {
        public int Id { get; set; }
        public string MedicalProcedures { get; set; } = string.Empty;
        public DateTime AdmissionTime { get; set; }
        public DateTime? DischargeTime { get; set; }
    }

    public class TimelineDto
    {
        public DateTime RequestedAt { get; set; }
        public DateTime SearchingAt { get; set; }
        public DateTime? AssignedAt { get; set; }
        public DateTime? ArrivedAt { get; set; }
    }

    public class RequestCardDto
    {
        public int Id { get; set; }
        public string PatientName { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string Condition { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public string Status { get; set; } = string.Empty;
        public int? AmbulanceId { get; set; }
        public int? Eta { get; set; }
        public TimelineDto Timeline { get; set; } = new();

        // Computed Fields
        public bool IsSearching => Status == "Searching";
        public bool IsAssigned => Status == "Assigned";
        public string? Intervention
        {
            get
            {
                if (Priority == "Critical" && Status == "Searching" && (DateTime.UtcNow - CreatedAt).TotalSeconds > 60)
                {
                    return "No ambulance assigned after 60 sec";
                }
                return null;
            }
        }
    }

    public class CreateRequestDto
    {
        public string Description { get; set; } = string.Empty;
        public bool IsSelfCase { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public string Address { get; set; } = string.Empty;
        public int NumberOfPeopleAffected { get; set; }
    }

    public class UpdateRequestStatusDto
    {
        [System.ComponentModel.DataAnnotations.Required]
        public RequestStatus? Status { get; set; }
        public string? Comment { get; set; }
    }

    public class ReassignAmbulanceDto
    {
        public int NewAmbulanceId { get; set; }
    }

    public class HospitalReportRequestDto
    {
        public DateTime ArrivedAt { get; set; }
        public DateTime? DischargedAt { get; set; }
        public string Treatment { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }
}
