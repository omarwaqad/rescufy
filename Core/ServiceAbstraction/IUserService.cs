using Shared.DTOs.UserManagement;
using Shared.DTOs.Admin;

namespace ServiceAbstraction
{
    public interface IUserService
    {
        Task<UserDto> CreateUserAsync(CreateUserDto dto);
        Task<UserDto> CreateHospitalAdminAsync(CreateHospitalAdminDto dto);
        Task<UserDto> CreateAmbulanceDriverAsync(CreateAmbulanceDriverDto dto);
        Task<IEnumerable<UserDto>> GetAllUsersAsync(string? role = null);
        Task<UserDto> GetUserByIdAsync(string id);
        Task<UserDto> UpdateUserAsync(string id, UpdateUserDto dto);
        Task DeleteUserAsync(string id);
    }
}
