using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Enums;

namespace Persistence.Seeding
{
    public class SuperAdminSeeder(
        UserManager<ApplicationUser> userManager
        )
    {
        public async Task SeedAsync()
        {
            var superAdminUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "superadmin@test.com");
            if (superAdminUser == null)
            {
                superAdminUser = new ApplicationUser
                {
                    UserName = "superadmin@test.com",
                    Email = "superadmin@test.com",
                    Name = "System SuperAdmin",
                    FullName = "System SuperAdmin",
                    NationalId = "0000000000",
                    Gender = "Male",
                    EmailConfirmed = true
                };

                var result = await userManager.CreateAsync(superAdminUser, "P@ssword12");
                if (!result.Succeeded)
                {
                    var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                    throw new Exception($"Failed to create SuperAdmin user: {errors}");
                }
            }

            if (!await userManager.IsInRoleAsync(superAdminUser, Roles.SuperAdmin.ToString()))
            {
                await userManager.AddToRoleAsync(superAdminUser, Roles.SuperAdmin.ToString());
            }
            if (!await userManager.IsInRoleAsync(superAdminUser, Roles.Admin.ToString()))
            {
                await userManager.AddToRoleAsync(superAdminUser, Roles.Admin.ToString());
            }
        }
    }
}
