using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Persistence.Data;
using Shared.Enums;

namespace Persistence.Seeding
{
    public class UsersSeeder(UserManager<ApplicationUser> userManager, ApplicationDbContext context)
    {
        public async Task SeedAsync()
        {
            // Ambulance Driver
            var ambulanceDriverUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "driver@rescufy.com");
            if (ambulanceDriverUser == null)
            {
                var firstAmbulance = await context.Ambulances.FirstOrDefaultAsync();
                int? assignedAmbulanceId = firstAmbulance?.Id;

                ambulanceDriverUser = new ApplicationUser
                {
                    UserName = "driver@rescufy.com", // Match email for consistency
                    Email = "driver@rescufy.com",
                    Name = "Ambulance Driver",
                    FullName = "Ambulance Driver",
                    NationalId = "1111111111",
                    Gender = "Male",
                    EmailConfirmed = true,
                    AssignedAmbulanceId = assignedAmbulanceId
                };
                var result = await userManager.CreateAsync(ambulanceDriverUser, "P@ssword12");
                if (!result.Succeeded) throw new Exception("Failed to create Ambulance Driver user");
            }
            else if (!ambulanceDriverUser.AssignedAmbulanceId.HasValue)
            {
                var firstAmbulance = await context.Ambulances.FirstOrDefaultAsync();
                if (firstAmbulance != null)
                {
                    ambulanceDriverUser.AssignedAmbulanceId = firstAmbulance.Id;
                    await userManager.UpdateAsync(ambulanceDriverUser);
                }
            }

            if (!await userManager.IsInRoleAsync(ambulanceDriverUser, Roles.AmbulanceDriver.ToString()))
            {
                await userManager.AddToRoleAsync(ambulanceDriverUser, Roles.AmbulanceDriver.ToString());
            }

            // Hospital Admin
            var hospitalAdminUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "admin@hospital.com");
            if (hospitalAdminUser == null)
            {
                var firstHospital = await context.Hospitals.FirstOrDefaultAsync();
                int? assignedHospitalId = firstHospital?.Id;

                hospitalAdminUser = new ApplicationUser
                {
                    UserName = "admin@hospital.com", // Changed to email to match login flow
                    Email = "admin@hospital.com",
                    Name = "Hospital Admin",
                    FullName = "Hospital Admin",
                    NationalId = "2222222222",
                    Gender = "Male",
                    EmailConfirmed = true,
                    HospitalId = assignedHospitalId
                };
                var result = await userManager.CreateAsync(hospitalAdminUser, "P@ssword12");
                if (!result.Succeeded) throw new Exception("Failed to create Hospital Admin user");
            }
            else if (!hospitalAdminUser.HospitalId.HasValue)
            {
                var firstHospital = await context.Hospitals.FirstOrDefaultAsync();
                if (firstHospital != null)
                {
                    hospitalAdminUser.HospitalId = firstHospital.Id;
                    await userManager.UpdateAsync(hospitalAdminUser);
                }
            }

            if (!await userManager.IsInRoleAsync(hospitalAdminUser, Roles.HospitalAdmin.ToString()))
            {
                await userManager.AddToRoleAsync(hospitalAdminUser, Roles.HospitalAdmin.ToString());
            }

            // Standard User
            var standardUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "user@rescufy.com");
            if (standardUser == null)
            {
                standardUser = new ApplicationUser
                {
                    UserName = "user",
                    Email = "user@rescufy.com",
                    Name = "Standard User",
                    FullName = "Standard User",
                    NationalId = "3333333333",
                    Gender = "Male",
                    EmailConfirmed = true,
                    // Seed Emergency Contact
                    // EmergencyContacts = // Collection is initialized in constructor, but can add here if navig prop set. 
                    // Better to add separately via context to ensure IDs are set if needed, or saving changes.
                };
                var result = await userManager.CreateAsync(standardUser, "P@ssword12");
                if (!result.Succeeded) throw new Exception("Failed to create Standard User");
            }

            if (!await userManager.IsInRoleAsync(standardUser, Roles.User.ToString()))
            {
                await userManager.AddToRoleAsync(standardUser, Roles.User.ToString());
            }

            // Seed User Profile and Medical History for Standard User
            if (!context.UserProfiles.Any(p => p.UserId == standardUser.Id))
            {
                var profile = new UserProfile
                {
                    UserId = standardUser.Id,
                    BloodType = "O+",
                    WeightKg = 75.5f,
                    HeightCm = 180f,
                    PregnancyStatus = false,
                    MedicalNotes = "No major issues, allergic to Penicillin.",
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };

                await context.UserProfiles.AddAsync(profile);
                await context.SaveChangesAsync(); // Save to get Profile Id

                // Seed Medical History
                var allergies = new List<Allergy>
                {
                    new() { ProfileId = profile.Id, Name = "Penicillin", Severity = "Severe", Notes = "Causes anaphylaxis" },
                    new() { ProfileId = profile.Id, Name = "Dust Mites", Severity = "Mild", Notes = "Sneezing and runny nose" }
                };
                await context.Allergies.AddRangeAsync(allergies);

                var conditions = new List<ChronicDisease>
                {
                    new() { ProfileId = profile.Id, Name = "Hypertension", Severity = "Moderate", DiagnosedDate = DateTime.Parse("2020-01-01"), IsActive = true },
                    new() { ProfileId = profile.Id, Name = "Asthma", Severity = "Mild", DiagnosedDate = DateTime.Parse("2015-06-01"), IsActive = true }
                };
                await context.ChronicDiseases.AddRangeAsync(conditions);

                var medications = new List<Medication>
                {
                    new() { ProfileId = profile.Id, Name = "Lisinopril", Dosage = "10mg", Frequency = "Once daily" },
                    new() { ProfileId = profile.Id, Name = "Albuterol Inhaler", Dosage = "2 puffs", Frequency = "As needed" }
                };
                await context.Medications.AddRangeAsync(medications);

                var surgeries = new List<PastSurgery>
                {
                    new() { ProfileId = profile.Id, Name = "Appendectomy", Year = 2010, Notes = "No complications" }
                };
                await context.PastSurgeries.AddRangeAsync(surgeries);
                
                // Seed Emergency Contact
                if (!context.EmergencyContacts.Any(c => c.ProfileId == standardUser.Id))
                {
                     // Note: EmergencyContact.ProfileId maps to ApplicationUser.Id (string), based on the model definition viewed earlier.
                     // The model had: public string ProfileId { get; set; } and [ForeignKey(nameof(ProfileId))] public ApplicationUser User { get; set; }
                     var emergencyContacts = new List<EmergencyContact>
                     {
                         new() { ProfileId = standardUser.Id, FullName = "Jane Doe", PhoneNumber = "010-99887766", Relation = "Spouse", IsActive = true, CreatedAt = DateTime.UtcNow },
                         new() { ProfileId = standardUser.Id, FullName = "John Smith", PhoneNumber = "011-22334455", Relation = "Father", IsActive = true, CreatedAt = DateTime.UtcNow }
                     };
                     await context.EmergencyContacts.AddRangeAsync(emergencyContacts);
                }

                await context.SaveChangesAsync();
            }
        }
    }
}
