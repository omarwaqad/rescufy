using Domain.Contracts;
using Domain.Models;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.UserProfile;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;
using Shared.Enums;

namespace Service
{
    public class ProfileService(IUnitOfWork unitOfWork, IFileStorageService fileStorageService, UserManager<ApplicationUser> userManager) : IProfileService
    {
        public async Task<UserProfileDto> GetProfileAsync(string userId)
        {
            var profile = await unitOfWork.GetRepository<UserProfile, int>().GetFirstOrDefaultAsync(
                predicate: p => p.UserId == userId);

            if (profile == null) throw new Exception("Profile not found");

            var user = await userManager.FindByIdAsync(userId);

            return new UserProfileDto
            {
                Id = profile.Id,
                BloodType = profile.BloodType,
                WeightKg = profile.WeightKg,
                HeightCm = profile.HeightCm,
                PregnancyStatus = profile.PregnancyStatus,
                MedicalNotes = profile.MedicalNotes,
                ProfileImageUrl = user?.ProfileImageUrl
            };
        }

        public async Task<UserProfileDto> UpdateProfileAsync(string userId, UpdateUserProfileDto dto)
        {
            var user = await userManager.FindByIdAsync(userId);
            if (user == null) throw new Exception("User not found");

            var profile = await unitOfWork.GetRepository<UserProfile, int>().GetFirstOrDefaultAsync(
                predicate: p => p.UserId == userId);

            if (profile == null) throw new Exception("Profile not found");

            if (dto.BloodType != null) profile.BloodType = dto.BloodType;
            if (dto.WeightKg.HasValue) profile.WeightKg = dto.WeightKg.Value;
            if (dto.HeightCm.HasValue) profile.HeightCm = dto.HeightCm.Value;
            
            if (dto.PregnancyStatus.HasValue)
            {
                if (dto.PregnancyStatus.Value && user.Gender?.ToString() != "Female")
                {
                    throw new Exception("Pregnancy status is only applicable for female users.");
                }
                profile.PregnancyStatus = dto.PregnancyStatus.Value;
            }

            if (dto.MedicalNotes != null) profile.MedicalNotes = dto.MedicalNotes;
            
            if (dto.ProfileImageUrl != null)
            {
                user.ProfileImageUrl = dto.ProfileImageUrl;
                await userManager.UpdateAsync(user);
            }

            profile.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<UserProfile, int>().Update(profile);
            await unitOfWork.SaveChangesAsync();

            return new UserProfileDto
            {
                Id = profile.Id,
                BloodType = profile.BloodType,
                WeightKg = profile.WeightKg,
                HeightCm = profile.HeightCm,
                PregnancyStatus = profile.PregnancyStatus,
                MedicalNotes = profile.MedicalNotes,
                ProfileImageUrl = user.ProfileImageUrl
            };
        }

        public async Task<string> UploadProfileImageAsync(string userId, IFormFile file)
        {
            var user = await userManager.FindByIdAsync(userId);
            if (user == null) throw new Exception("User not found");

            // Delete old image if exists
            if (!string.IsNullOrEmpty(user.ProfileImageUrl))
            {
                await fileStorageService.DeleteFileAsync(user.ProfileImageUrl);
            }

            var imageUrl = await fileStorageService.SaveFileAsync(file, "profiles", 5 * 1024 * 1024); // 5MB limit
            user.ProfileImageUrl = imageUrl;
            
            var result = await userManager.UpdateAsync(user);
            if (!result.Succeeded) throw new Exception("Failed to update user profile image");

            return imageUrl;
        }

        public async Task DeleteProfileImageAsync(string userId)
        {
            var user = await userManager.FindByIdAsync(userId);
            if (user == null) throw new Exception("User not found");

            if (!string.IsNullOrEmpty(user.ProfileImageUrl))
            {
                await fileStorageService.DeleteFileAsync(user.ProfileImageUrl);
                user.ProfileImageUrl = null;
                var result = await userManager.UpdateAsync(user);
                if (!result.Succeeded) throw new Exception("Failed to delete user profile image");
            }
        }

        // Medications
        public async Task<IEnumerable<MedicationDto>> GetMedicationsAsync(string userId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var medications = await unitOfWork.GetRepository<Medication, Guid>().GetAllAsync(m => m.ProfileId == profile.Id);
            return medications.Select(m => new MedicationDto { Id = m.Id, Name = m.Name, Dosage = m.Dosage, Frequency = m.Frequency });
        }

        public async Task<MedicationDto> AddMedicationAsync(string userId, CreateMedicationDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var medication = new Medication { ProfileId = profile.Id, Name = dto.Name, Dosage = dto.Dosage, Frequency = dto.Frequency };
            await unitOfWork.GetRepository<Medication, Guid>().AddAsync(medication);
            await unitOfWork.SaveChangesAsync();
            return new MedicationDto { Id = medication.Id, Name = medication.Name, Dosage = medication.Dosage, Frequency = medication.Frequency };
        }

        public async Task<MedicationDto?> UpdateMedicationAsync(string userId, Guid medicationId, CreateMedicationDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var medication = await unitOfWork.GetRepository<Medication, Guid>().GetByIdAsync(medicationId);
            if (medication == null || medication.ProfileId != profile.Id) return null;

            if (dto.Name != null) medication.Name = dto.Name;
            if (dto.Dosage != null) medication.Dosage = dto.Dosage;
            if (dto.Frequency != null) medication.Frequency = dto.Frequency;

            unitOfWork.GetRepository<Medication, Guid>().Update(medication);
            await unitOfWork.SaveChangesAsync();
            return new MedicationDto { Id = medication.Id, Name = medication.Name, Dosage = medication.Dosage, Frequency = medication.Frequency };
        }

        public async Task DeleteMedicationAsync(string userId, Guid medicationId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var medication = await unitOfWork.GetRepository<Medication, Guid>().GetByIdAsync(medicationId);
            if (medication == null || medication.ProfileId != profile.Id) throw new Exception("Medication not found");
            
            unitOfWork.GetRepository<Medication, Guid>().Remove(medication);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task<UserFullProfileDto> GetFullProfileAsync(string userId)
        {
            var user = await userManager.Users
                .Include(u => u.UserProfile)
                    .ThenInclude(p => p.Medications)
                .Include(u => u.UserProfile)
                    .ThenInclude(p => p.Allergies)
                .Include(u => u.Hospital)
                .Include(u => u.AssignedAmbulance)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null) throw new Exception("User not found");
            var profile = user.UserProfile ?? throw new Exception("Profile not found");

            var dto = new UserFullProfileDto
            {
                Id = user.Id,
                Name = user.Name,
                Email = user.Email!,
                PhoneNumber = user.PhoneNumber!,
                Gender = user.Gender,
                Age = user.Age,
                NationalId = user.NationalId,
                ProfileImageUrl = user.ProfileImageUrl,
                BloodType = profile.BloodType,
                WeightKg = profile.WeightKg,
                HeightCm = profile.HeightCm,
                PregnancyStatus = profile.PregnancyStatus,
                MedicalNotes = profile.MedicalNotes,
                Medications = profile.Medications.Select(m => new MedicationDto
                {
                    Id = m.Id,
                    Name = m.Name,
                    Dosage = m.Dosage,
                    Frequency = m.Frequency
                }).ToList(),
                Allergies = profile.Allergies.Select(a => new AllergyDto
                {
                    Id = a.Id,
                    Name = a.Name,
                    Severity = a.Severity
                }).ToList()
            };

            // Add role-specific data
            var isHospitalAdmin = await userManager.IsInRoleAsync(user, nameof(Roles.HospitalAdmin));
            var isAmbulanceDriver = await userManager.IsInRoleAsync(user, nameof(Roles.AmbulanceDriver)) || await userManager.IsInRoleAsync(user, nameof(Roles.Paramedic));

            if (isHospitalAdmin && user.Hospital != null)
            {
                dto.RoleSpecificData = new { HospitalId = user.HospitalId, HospitalName = user.Hospital.Name, HospitalAddress = user.Hospital.Address };
            }
            else if (isAmbulanceDriver && user.AssignedAmbulance != null)
            {
                dto.RoleSpecificData = new { AmbulanceId = user.AssignedAmbulanceId, AmbulanceNumber = user.AssignedAmbulance.AmbulanceNumber, VehicleInfo = user.AssignedAmbulance.VehicleInfo };
            }

            return dto;
        }

        public async Task<List<UserRequestHistoryDto>> GetUserRequestHistoryAsync(string userId)
        {
            var requests = await unitOfWork.GetRepository<Request, int>().GetAllAsync(
                predicate: r => r.UserId == userId,
                includes: [r => r.Hospital, r => r.Ambulance]);

            return requests.Select(r => new UserRequestHistoryDto
            {
                RequestId = r.Id,
                Status = r.RequestStatus.ToString(),
                CreatedAt = r.CreatedAt,
                HospitalName = r.Hospital?.Name,
                AmbulanceNumber = r.Ambulance?.AmbulanceNumber
            }).OrderByDescending(r => r.CreatedAt).ToList();
        }

        public async Task<UserFullProfileDto> UpdateMedicalDataAsync(string userId, UpdateMedicalDataDto dto)
        {
            var user = await userManager.Users
                .Include(u => u.UserProfile)
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null) throw new Exception("User not found");
            var profile = user.UserProfile ?? throw new Exception("Profile not found");

            // Scalar updates
            if (dto.BloodType != null) profile.BloodType = dto.BloodType;
            if (dto.WeightKg.HasValue) profile.WeightKg = dto.WeightKg.Value;
            if (dto.MedicalNotes != null) profile.MedicalNotes = dto.MedicalNotes;

            if (dto.PregnancyStatus.HasValue)
            {
                if (dto.PregnancyStatus.Value && user.Gender != "Female")
                {
                    throw new Exception("Pregnancy status is only applicable for female users.");
                }
                profile.PregnancyStatus = dto.PregnancyStatus.Value;
            }

            // Collection updates (Replace strategy)
            if (dto.Medications != null)
            {
                var currentMedications = await unitOfWork.GetRepository<Medication, Guid>().GetAllAsync(m => m.ProfileId == profile.Id);
                foreach (var m in currentMedications) unitOfWork.GetRepository<Medication, Guid>().Remove(m);

                foreach (var name in dto.Medications)
                {
                    await unitOfWork.GetRepository<Medication, Guid>().AddAsync(new Medication { ProfileId = profile.Id, Name = name, Dosage = "N/A", Frequency = "As needed" });
                }
            }

            if (dto.Allergies != null)
            {
                var currentAllergies = await unitOfWork.GetRepository<Allergy, Guid>().GetAllAsync(a => a.ProfileId == profile.Id);
                foreach (var a in currentAllergies) unitOfWork.GetRepository<Allergy, Guid>().Remove(a);

                foreach (var name in dto.Allergies)
                {
                    await unitOfWork.GetRepository<Allergy, Guid>().AddAsync(new Allergy { ProfileId = profile.Id, Name = name, Severity = "Unknown" });
                }
            }

            profile.UpdatedAt = DateTime.UtcNow;
            unitOfWork.GetRepository<UserProfile, int>().Update(profile);
            await unitOfWork.SaveChangesAsync();

            return await GetFullProfileAsync(userId);
        }

        public async Task<IEnumerable<AllergyDto>> GetAllergiesAsync(string userId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var allergies = await unitOfWork.GetRepository<Allergy, Guid>().GetAllAsync(a => a.ProfileId == profile.Id);
            return allergies.Select(a => new AllergyDto { Id = a.Id, Name = a.Name, Severity = a.Severity });
        }

        public async Task<AllergyDto> AddAllergyAsync(string userId, CreateAllergyDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var allergy = new Allergy { ProfileId = profile.Id, Name = dto.Name, Severity = dto.Severity };
            await unitOfWork.GetRepository<Allergy, Guid>().AddAsync(allergy);
            await unitOfWork.SaveChangesAsync();
            return new AllergyDto { Id = allergy.Id, Name = allergy.Name, Severity = allergy.Severity };
        }

        public async Task<AllergyDto?> UpdateAllergyAsync(string userId, Guid allergyId, CreateAllergyDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var allergy = await unitOfWork.GetRepository<Allergy, Guid>().GetByIdAsync(allergyId);
            if (allergy == null || allergy.ProfileId != profile.Id) return null;

            if (dto.Name != null) allergy.Name = dto.Name;
            if (dto.Severity != null) allergy.Severity = dto.Severity;

            unitOfWork.GetRepository<Allergy, Guid>().Update(allergy);
            await unitOfWork.SaveChangesAsync();
            return new AllergyDto { Id = allergy.Id, Name = allergy.Name, Severity = allergy.Severity };
        }

        public async Task DeleteAllergyAsync(string userId, Guid allergyId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var allergy = await unitOfWork.GetRepository<Allergy, Guid>().GetByIdAsync(allergyId);
            if (allergy == null || allergy.ProfileId != profile.Id) throw new Exception("Allergy not found");
            unitOfWork.GetRepository<Allergy, Guid>().Remove(allergy);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<ChronicDiseaseDto>> GetChronicDiseasesAsync(string userId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var diseases = await unitOfWork.GetRepository<ChronicDisease, Guid>().GetAllAsync(d => d.ProfileId == profile.Id);
            return diseases.Select(d => new ChronicDiseaseDto { Id = d.Id, Name = d.Name, Severity = d.Severity, DiagnosedDate = d.DiagnosedDate });
        }

        public async Task<ChronicDiseaseDto> AddChronicDiseaseAsync(string userId, CreateChronicDiseaseDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var disease = new ChronicDisease { ProfileId = profile.Id, Name = dto.Name, Severity = dto.Severity, DiagnosedDate = dto.DiagnosedDate };
            await unitOfWork.GetRepository<ChronicDisease, Guid>().AddAsync(disease);
            await unitOfWork.SaveChangesAsync();
            return new ChronicDiseaseDto { Id = disease.Id, Name = disease.Name, Severity = disease.Severity, DiagnosedDate = disease.DiagnosedDate };
        }

        public async Task<ChronicDiseaseDto?> UpdateChronicDiseaseAsync(string userId, Guid diseaseId, CreateChronicDiseaseDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var disease = await unitOfWork.GetRepository<ChronicDisease, Guid>().GetByIdAsync(diseaseId);
            if (disease == null || disease.ProfileId != profile.Id) return null;

            if (dto.Name != null) disease.Name = dto.Name;
            if (dto.Severity != null) disease.Severity = dto.Severity;
            if (dto.DiagnosedDate != default) disease.DiagnosedDate = dto.DiagnosedDate;

            unitOfWork.GetRepository<ChronicDisease, Guid>().Update(disease);
            await unitOfWork.SaveChangesAsync();
            return new ChronicDiseaseDto { Id = disease.Id, Name = disease.Name, Severity = disease.Severity, DiagnosedDate = disease.DiagnosedDate };
        }

        public async Task DeleteChronicDiseaseAsync(string userId, Guid diseaseId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var disease = await unitOfWork.GetRepository<ChronicDisease, Guid>().GetByIdAsync(diseaseId);
            if (disease == null || disease.ProfileId != profile.Id) throw new Exception("Chronic disease not found");
            unitOfWork.GetRepository<ChronicDisease, Guid>().Remove(disease);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<EmergencyContactDto>> GetEmergencyContactsAsync(string userId)
        {
            var contacts = await unitOfWork.GetRepository<EmergencyContact, Guid>().GetAllAsync(c => c.ProfileId == userId);
            return contacts.Select(c => new EmergencyContactDto { Id = c.Id, FullName = c.FullName, PhoneNumber = c.PhoneNumber, Relation = c.Relation, IsActive = c.IsActive });
        }

        public async Task<EmergencyContactDto> AddEmergencyContactAsync(string userId, CreateEmergencyContactDto dto)
        {
            var contact = new EmergencyContact { ProfileId = userId, FullName = dto.FullName, PhoneNumber = dto.PhoneNumber, Relation = dto.Relation, IsActive = true };
            await unitOfWork.GetRepository<EmergencyContact, Guid>().AddAsync(contact);
            await unitOfWork.SaveChangesAsync();
            return new EmergencyContactDto { Id = contact.Id, FullName = contact.FullName, PhoneNumber = contact.PhoneNumber, Relation = contact.Relation, IsActive = contact.IsActive };
        }

        public async Task<EmergencyContactDto?> UpdateEmergencyContactAsync(string userId, Guid contactId, CreateEmergencyContactDto dto)
        {
            var contact = await unitOfWork.GetRepository<EmergencyContact, Guid>().GetByIdAsync(contactId);
            if (contact == null || contact.ProfileId != userId) return null;

            if (dto.FullName != null) contact.FullName = dto.FullName;
            if (dto.PhoneNumber != null) contact.PhoneNumber = dto.PhoneNumber;
            if (dto.Relation != null) contact.Relation = dto.Relation;

            unitOfWork.GetRepository<EmergencyContact, Guid>().Update(contact);
            await unitOfWork.SaveChangesAsync();
            return new EmergencyContactDto { Id = contact.Id, FullName = contact.FullName, PhoneNumber = contact.PhoneNumber, Relation = contact.Relation, IsActive = contact.IsActive };
        }

        public async Task DeleteEmergencyContactAsync(string userId, Guid contactId)
        {
            var contact = await unitOfWork.GetRepository<EmergencyContact, Guid>().GetByIdAsync(contactId);
            if (contact == null || contact.ProfileId != userId) throw new Exception("Emergency contact not found");
            unitOfWork.GetRepository<EmergencyContact, Guid>().Remove(contact);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task<IEnumerable<PastSurgeryDto>> GetPastSurgeriesAsync(string userId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var surgeries = await unitOfWork.GetRepository<PastSurgery, Guid>().GetAllAsync(s => s.ProfileId == profile.Id);
            return surgeries.Select(s => new PastSurgeryDto { Id = s.Id, Name = s.Name, Year = s.Year, Notes = s.Notes });
        }

        public async Task<PastSurgeryDto> AddPastSurgeryAsync(string userId, CreatePastSurgeryDto dto)
        {
            var profile = await GetProfileInternalAsync(userId);
            var surgery = new PastSurgery { ProfileId = profile.Id, Name = dto.Name, Year = dto.Year, Notes = dto.Notes };
            await unitOfWork.GetRepository<PastSurgery, Guid>().AddAsync(surgery);
            await unitOfWork.SaveChangesAsync();
            return new PastSurgeryDto { Id = surgery.Id, Name = surgery.Name, Year = surgery.Year, Notes = surgery.Notes };
        }

        public async Task DeletePastSurgeryAsync(string userId, Guid surgeryId)
        {
            var profile = await GetProfileInternalAsync(userId);
            var surgery = await unitOfWork.GetRepository<PastSurgery, Guid>().GetByIdAsync(surgeryId);
            if (surgery == null || surgery.ProfileId != profile.Id) throw new Exception("Surgery record not found");
            unitOfWork.GetRepository<PastSurgery, Guid>().Remove(surgery);
            await unitOfWork.SaveChangesAsync();
        }

        private async Task<UserProfile> GetProfileInternalAsync(string userId)
        {
            var profile = await unitOfWork.GetRepository<UserProfile, int>().GetFirstOrDefaultAsync(
                predicate: p => p.UserId == userId);

            if (profile == null) throw new Exception("Profile not found");
            return profile;
        }
    }
}
