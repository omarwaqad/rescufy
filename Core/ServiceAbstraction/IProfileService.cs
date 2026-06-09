using Shared.DTOs.UserProfile;
using Microsoft.AspNetCore.Http;

namespace ServiceAbstraction
{
    public interface IProfileService
    {
        Task<UserProfileDto> GetProfileAsync(string userId);
        Task<UserProfileDto> UpdateProfileAsync(string userId, UpdateUserProfileDto dto);
        Task<UserFullProfileDto> GetFullProfileAsync(string userId);
        Task<List<UserRequestHistoryDto>> GetUserRequestHistoryAsync(string userId);
        Task<UserFullProfileDto> UpdateMedicalDataAsync(string userId, UpdateMedicalDataDto dto);
        Task<string> UploadProfileImageAsync(string userId, IFormFile file);
        Task DeleteProfileImageAsync(string userId);

        // Medical Data Management
        Task<IEnumerable<MedicationDto>> GetMedicationsAsync(string userId);
        Task<MedicationDto> AddMedicationAsync(string userId, CreateMedicationDto dto);
        Task<MedicationDto?> UpdateMedicationAsync(string userId, Guid medicationId, CreateMedicationDto dto);
        Task DeleteMedicationAsync(string userId, Guid medicationId);

        Task<IEnumerable<AllergyDto>> GetAllergiesAsync(string userId);
        Task<AllergyDto> AddAllergyAsync(string userId, CreateAllergyDto dto);
        Task<AllergyDto?> UpdateAllergyAsync(string userId, Guid allergyId, CreateAllergyDto dto);
        Task DeleteAllergyAsync(string userId, Guid allergyId);

        Task<IEnumerable<ChronicDiseaseDto>> GetChronicDiseasesAsync(string userId);
        Task<ChronicDiseaseDto> AddChronicDiseaseAsync(string userId, CreateChronicDiseaseDto dto);
        Task<ChronicDiseaseDto?> UpdateChronicDiseaseAsync(string userId, Guid diseaseId, CreateChronicDiseaseDto dto);
        Task DeleteChronicDiseaseAsync(string userId, Guid diseaseId);

        Task<IEnumerable<EmergencyContactDto>> GetEmergencyContactsAsync(string userId);
        Task<EmergencyContactDto> AddEmergencyContactAsync(string userId, CreateEmergencyContactDto dto);
        Task<EmergencyContactDto?> UpdateEmergencyContactAsync(string userId, Guid contactId, CreateEmergencyContactDto dto);
        Task DeleteEmergencyContactAsync(string userId, Guid contactId);

        Task<IEnumerable<PastSurgeryDto>> GetPastSurgeriesAsync(string userId);
        Task<PastSurgeryDto> AddPastSurgeryAsync(string userId, CreatePastSurgeryDto dto);
        Task DeletePastSurgeryAsync(string userId, Guid surgeryId);
    }
}
