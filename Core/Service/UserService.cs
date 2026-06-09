using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using ServiceAbstraction;
using Shared.DTOs.UserManagement;
using Shared.Enums;
using Shared.DTOs.Admin;
using Domain.Contracts;

namespace Service
{
    public class UserService(UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager, IUnitOfWork unitOfWork) : IUserService
    {
        public async Task<UserDto> CreateUserAsync(CreateUserDto dto)
        {
            if (await userManager.FindByEmailAsync(dto.Email) != null)
                 throw new ArgumentException("Email is already registered.");

            string nationalId = dto.NationalId ?? "";
            if (string.IsNullOrEmpty(nationalId))
            {
                do
                {
                    nationalId = new Random().NextInt64(10000000000000, 99999999999999).ToString();
                } while (await userManager.Users.AnyAsync(u => u.NationalId == nationalId));
            }
            else if (await userManager.Users.AnyAsync(u => u.NationalId == nationalId))
            {
                throw new ArgumentException("National ID is already registered.");
            }

            var user = new ApplicationUser
            {
                UserName = dto.Email,
                Email = dto.Email,
                Name = dto.FullName,
                FullName = dto.FullName,
                PhoneNumber = dto.PhoneNumber,
                EmailConfirmed = true,
                NationalId = nationalId,
                Gender = dto.Gender,
                Age = dto.Age ?? 30,
                HospitalId = null,
                AssignedAmbulanceId = null
            };

            var result = await userManager.CreateAsync(user, dto.Password);
            if (!result.Succeeded)
            {
                throw new Exception($"Failed to create user: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }

            // Enforce internal role authority: Endpoint determines the role, DTO is informational
            string roleToAssign = nameof(Roles.User);
            if (!string.IsNullOrEmpty(dto.Role))
            {
                // Strict mode: Validate if provided role is allowed for this endpoint
                if (dto.Role != nameof(Roles.User) && dto.Role != nameof(Roles.Admin) && dto.Role != nameof(Roles.Paramedic))
                {
                    throw new ArgumentException($"Invalid or unsupported role for this endpoint: {dto.Role}");
                }
                roleToAssign = dto.Role;
            }

            var roleResult = await userManager.AddToRoleAsync(user, roleToAssign);
            if (!roleResult.Succeeded)
            {
                throw new Exception($"Failed to assign role: {string.Join(", ", roleResult.Errors.Select(e => e.Description))}");
            }

            return await MapToDtoAsync(user);
        }

        public async Task<UserDto> CreateHospitalAdminAsync(CreateHospitalAdminDto dto)
        {
            if (!string.IsNullOrEmpty(dto.Role) && dto.Role != nameof(Roles.HospitalAdmin))
                throw new ArgumentException($"Role mismatch. Endpoint enforces '{nameof(Roles.HospitalAdmin)}' but request body specified '{dto.Role}'.");

            var hospitalExists = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(dto.HospitalId);
            if (hospitalExists == null) throw new ArgumentException("Hospital not found.");

            return await CreateAdminInternalAsync(dto, nameof(Roles.HospitalAdmin), u => u.HospitalId = dto.HospitalId);
        }

        public async Task<UserDto> CreateAmbulanceDriverAsync(CreateAmbulanceDriverDto dto)
        {
            if (!string.IsNullOrEmpty(dto.Role) && dto.Role != nameof(Roles.AmbulanceDriver))
                throw new ArgumentException($"Role mismatch. Endpoint enforces '{nameof(Roles.AmbulanceDriver)}' but request body specified '{dto.Role}'.");

            var ambulanceExists = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(dto.AssignedAmbulanceId);
            if (ambulanceExists == null) throw new ArgumentException("Ambulance not found.");

            return await CreateAdminInternalAsync(dto, nameof(Roles.AmbulanceDriver), u => u.AssignedAmbulanceId = dto.AssignedAmbulanceId);
        }

        private async Task<UserDto> CreateAdminInternalAsync(CreateAdminBaseDto dto, string role, Action<ApplicationUser>? extraMapping = null)
        {
            if (await userManager.FindByEmailAsync(dto.Email) != null)
                 throw new ArgumentException("Email is already registered.");

            string nationalId = dto.NationalId ?? "";
            if (string.IsNullOrEmpty(nationalId))
            {
                do
                {
                    nationalId = new Random().NextInt64(10000000000000, 99999999999999).ToString();
                } while (await userManager.Users.AnyAsync(u => u.NationalId == nationalId));
            }
            else if (await userManager.Users.AnyAsync(u => u.NationalId == nationalId))
            {
                throw new ArgumentException("National ID is already registered.");
            }

            var user = new ApplicationUser
            {
                UserName = dto.Email,
                Email = dto.Email,
                Name = dto.FullName,
                FullName = dto.FullName, // Required by DB schema
                PhoneNumber = dto.PhoneNumber,
                Gender = dto.Gender,
                EmailConfirmed = true,
                NationalId = nationalId,
                Age = dto.Age ?? 30 // Default age
            };

            extraMapping?.Invoke(user);

            var result = await userManager.CreateAsync(user, dto.Password);
            if (!result.Succeeded)
            {
                throw new Exception($"Failed to create user: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }

            var roleResult = await userManager.AddToRoleAsync(user, role);
            if (!roleResult.Succeeded)
            {
                throw new Exception($"Failed to assign role: {string.Join(", ", roleResult.Errors.Select(e => e.Description))}");
            }

            return await MapToDtoAsync(user);
        }

        public async Task<IEnumerable<UserDto>> GetAllUsersAsync(string? role = null)
        {
            var users = await userManager.Users.ToListAsync();
            var userDtos = new List<UserDto>();

            foreach (var user in users)
            {
                if (!string.IsNullOrEmpty(role))
                {
                    if (await userManager.IsInRoleAsync(user, role))
                    {
                        userDtos.Add(await MapToDtoAsync(user));
                    }
                }
                else
                {
                    userDtos.Add(await MapToDtoAsync(user));
                }
            }

            return userDtos;
        }

        public async Task<UserDto> GetUserByIdAsync(string id)
        {
            var user = await userManager.FindByIdAsync(id);
            if (user == null) throw new Exception("User not found");

            return await MapToDtoAsync(user);
        }

        public async Task<UserDto> UpdateUserAsync(string id, UpdateUserDto dto)
        {
            var user = await userManager.FindByIdAsync(id);
            if (user == null) throw new Exception("User not found");

            user.Name = dto.Name;
            user.PhoneNumber = dto.PhoneNumber;
            user.IsBanned = dto.IsBanned;
            
            if (dto.HospitalId.HasValue)
            {
                var hospitalExists = await unitOfWork.GetRepository<Hospital, int>().GetByIdAsync(dto.HospitalId.Value);
                if (hospitalExists == null) throw new Exception("Hospital not found.");
                user.HospitalId = dto.HospitalId;
            }
            if (dto.AssignedAmbulanceId.HasValue)
            {
                var ambulanceExists = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(dto.AssignedAmbulanceId.Value);
                if (ambulanceExists == null) throw new Exception("Ambulance not found.");
                user.AssignedAmbulanceId = dto.AssignedAmbulanceId;
            }
            // user.Email? usually requires specific flow for email change. Keeping it simple.

            var result = await userManager.UpdateAsync(user);
            if (!result.Succeeded)
            {
                 throw new Exception($"Failed to update user: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }

            return await MapToDtoAsync(user);
        }

        public async Task DeleteUserAsync(string id)
        {
            var user = await userManager.FindByIdAsync(id);
            if (user == null) throw new Exception("User not found");

            var result = await userManager.DeleteAsync(user);
             if (!result.Succeeded)
            {
                 throw new Exception($"Failed to delete user: {string.Join(", ", result.Errors.Select(e => e.Description))}");
            }
        }

        private async Task<UserDto> MapToDtoAsync(ApplicationUser user)
        {
            var roles = await userManager.GetRolesAsync(user);
            return new UserDto
            {
                Id = user.Id,
                Email = user.Email ?? "",
                Name = user.Name,
                NationalId = user.NationalId,
                Gender = user.Gender,
                Age = user.Age,
                PhoneNumber = user.PhoneNumber,
                Roles = roles,
                IsBanned = user.IsBanned,
                HospitalId = user.HospitalId,
                AssignedAmbulanceId = user.AssignedAmbulanceId
            };
        }
    }
}
