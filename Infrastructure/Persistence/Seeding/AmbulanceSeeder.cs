using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Persistence.Data;
using Shared.Enums;

namespace Persistence.Seeding
{
    public class AmbulanceSeeder(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
    {
        public async Task SeedAsync()
        {
            if (context.Ambulances.Count() < 5) // Add more if we have very few
            {
                var driver = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "driver@rescufy.com");
                var ambulances = new List<Ambulance>();

                var existingPlates = await context.Ambulances.Select(a => a.AmbulanceNumber).ToListAsync();

                var newAmbulances = new List<Ambulance>
                {
                    new()
                    {
                        Name = "Ambulance Delta",
                        VehicleInfo = "Volkswagen Crafter 2024",
                        DriverPhone = "010-99887766",
                        AmbulanceNumber = "AMB-DELTA",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.0626m, // Zamalek
                        SimLongitude = 31.2223m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow,
                        DriverId = driver?.Id
                    },
                    new()
                    {
                        Name = "Ambulance Echo",
                        VehicleInfo = "Ford Transit 2023",
                        DriverPhone = "011-55443322",
                        AmbulanceNumber = "AMB-ECHO",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.0131m, // Maadi
                        SimLongitude = 31.2367m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    },
                    new()
                    {
                        Name = "Ambulance Foxtrot",
                        VehicleInfo = "Mercedes-Benz Sprinter 2024",
                        DriverPhone = "012-66778899",
                        AmbulanceNumber = "AMB-FOXTROT",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.1211m, // Nasr City
                        SimLongitude = 31.3289m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    },
                    new()
                    {
                        Name = "Ambulance Golf",
                        VehicleInfo = "Toyota HiAce 2022",
                        DriverPhone = "015-12344321",
                        AmbulanceNumber = "AMB-GOLF",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 29.9542m, // Helwan
                        SimLongitude = 31.3011m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    },
                    new()
                    {
                        Name = "Ambulance Hotel",
                        VehicleInfo = "Ford Transit 2024",
                        DriverPhone = "010-00001111",
                        AmbulanceNumber = "AMB-HOTEL",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.0511m, // Dokki
                        SimLongitude = 31.2133m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    },
                    new()
                    {
                        Name = "Ambulance India",
                        VehicleInfo = "Volkswagen Crafter 2023",
                        DriverPhone = "011-22223333",
                        AmbulanceNumber = "AMB-INDIA",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.0722m, // Mohandessin
                        SimLongitude = 31.2055m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    },
                    new()
                    {
                        Name = "Ambulance Juliet",
                        VehicleInfo = "Mercedes-Benz Sprinter 2022",
                        DriverPhone = "012-44445555",
                        AmbulanceNumber = "AMB-JULIET",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        SimLatitude = 30.1000m, // New Cairo
                        SimLongitude = 31.4000m,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    }
                };

                foreach (var amb in newAmbulances)
                {
                    if (!existingPlates.Contains(amb.AmbulanceNumber))
                    {
                        ambulances.Add(amb);
                    }
                }

                if (ambulances.Count > 0)
                {
                    await context.Ambulances.AddRangeAsync(ambulances);
                    await context.SaveChangesAsync();
                }
            }
        }
    }
}
