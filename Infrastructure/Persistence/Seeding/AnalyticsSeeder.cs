using Domain.Models;
using Microsoft.AspNetCore.Identity;
using Persistence.Data;
using Shared.Enums;
using Microsoft.EntityFrameworkCore;

namespace Persistence.Seeding
{
    public class AnalyticsSeeder(
        ApplicationDbContext context, 
        UserManager<ApplicationUser> userManager)
    {
        public async Task SeedAsync()
        {
            // 1. Seed Paramedics (if they don't exist)
            var paramedics = new List<ApplicationUser>();
            for (int i = 1; i <= 5; i++)
            {
                var email = $"paramedic{i}@rescufy.com";
                var user = await userManager.Users.FirstOrDefaultAsync(u => u.Email == email);
                if (user == null)
                {
                    user = new ApplicationUser
                    {
                        UserName = $"paramedic{i}",
                        Email = email,
                        FullName = $"Paramedic {i}",
                        Name = $"Paramedic {i}",
                        NationalId = $"NAT-PARA-00{i}",
                        Gender = "Male",
                        EmailConfirmed = true
                    };
                    await userManager.CreateAsync(user, "P@ssword12");
                    await userManager.AddToRoleAsync(user, Roles.Paramedic.ToString());
                }
                paramedics.Add(user);
            }

            // 2. Seed Drivers (if they don't exist)
            var drivers = new List<ApplicationUser>();
            for (int i = 1; i <= 5; i++)
            {
                var email = $"driver{i}@rescufy.com";
                var user = await userManager.Users.FirstOrDefaultAsync(u => u.Email == email);
                if (user == null)
                {
                    user = new ApplicationUser
                    {
                        UserName = $"driver{i}",
                        Email = email,
                        FullName = $"Driver {i}",
                        Name = $"Driver {i}",
                        NationalId = $"NAT-DRIV-00{i}",
                        Gender = "Male",
                        EmailConfirmed = true
                    };
                    await userManager.CreateAsync(user, "P@ssword12");
                    await userManager.AddToRoleAsync(user, Roles.AmbulanceDriver.ToString());
                }
                drivers.Add(user);
            }

            // 3. Ensure we have 3 Hospitals (HospitalSeeder might have already added some)
            var hospitals = await context.Hospitals.OrderBy(h => h.Id).Take(3).ToListAsync();
            if (hospitals.Count < 3)
            {
                // Add more if needed
                for (int i = hospitals.Count + 1; i <= 3; i++)
                {
                    var hospital = new Hospital
                    {
                        Name = $"Hospital {i}",
                        Address = $"Address {i}",
                        ContactPhone = $"010-000000{i}",
                        Latitude = 30.0m + (i * 0.1m),
                        Longitude = 31.0m + (i * 0.1m),
                        BasePrice = 500 + (i * 50),
                        TotalRequests = 0,
                        AcceptedRequests = 0,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };
                    context.Hospitals.Add(hospital);
                    hospitals.Add(hospital);
                }
                await context.SaveChangesAsync();
            }

            // 4. Seed 5 Ambulances (link to Driver and Paramedic)
            var ambulances = await context.Ambulances.ToListAsync();
            for (int i = 0; i < 5; i++)
            {
                Ambulance ambulance;
                if (i < ambulances.Count)
                {
                    ambulance = ambulances[i];
                }
                else
                {
                    ambulance = new Ambulance
                    {
                        Name = $"Ambulance {i + 1}",
                        VehicleInfo = $"Vehicle Model {i + 1}",
                        DriverPhone = $"011-000000{i + 1}",
                        AmbulanceNumber = $"AMB-00{i + 1}",
                        AmbulanceStatus = AmbulanceStatus.Available,
                        CreatedAt = DateTime.UtcNow,
                        UpdatedAt = DateTime.UtcNow
                    };
                    context.Ambulances.Add(ambulance);
                }

                if (i < drivers.Count)
                    ambulance.DriverId = drivers[i].Id;
                
                if (i < paramedics.Count)
                    ambulance.ParamedicId = paramedics[i].Id;
                
                // Track assignment in user as well
                if (i < drivers.Count)
                    drivers[i].AssignedAmbulance = ambulance;
                
                if (i < paramedics.Count)
                    paramedics[i].AssignedAmbulance = ambulance;
            }
            await context.SaveChangesAsync();
            
            // Re-fetch to get IDs
            ambulances = await context.Ambulances.ToListAsync();

            // 5. Seed 20 Emergency Requests
            if (context.Requests.Count() < 20)
            {
                var random = new Random();
                var standardUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "user@rescufy.com");
                var userId = standardUser?.Id ?? drivers[0].Id;

                for (int i = 1; i <= 20; i++)
                {
                    var status = i switch
                    {
                        <= 10 => RequestStatus.Finished,
                        <= 12 => RequestStatus.NotDelivered,
                        <= 14 => RequestStatus.Canceled,
                        <= 17 => RequestStatus.Accepted,
                        _ => RequestStatus.Pending
                    };

                    var hosp = hospitals[random.Next(hospitals.Count)];
                    var amb = ambulances[random.Next(ambulances.Count)];
                    var driv = drivers[random.Next(drivers.Count)];

                    var createdAt = DateTime.UtcNow.AddDays(-random.Next(30)).AddHours(-random.Next(24));
                    var assignedAt = status != RequestStatus.Pending ? (DateTime?)createdAt.AddMinutes(random.Next(1, 5)) : null;
                    var eta = assignedAt.HasValue ? (DateTime?)assignedAt.Value.AddMinutes(random.Next(10, 25)) : null;
                    var arrivedAt = (status == RequestStatus.Arrived || status == RequestStatus.PickedUp || status == RequestStatus.UnderExecuting || status == RequestStatus.Delivered || status == RequestStatus.Finished) 
                        ? (DateTime?)assignedAt?.AddMinutes(random.Next(8, 20)) : null;
                    var completedAt = status == RequestStatus.Finished ? (DateTime?)arrivedAt?.AddMinutes(random.Next(15, 60)) : null;

                    var request = new Request
                    {
                        UserId = userId,
                        Description = $"Emergency request {i}",
                        Address = $"Location {i} at Latitude {30.0m + (decimal)random.NextDouble()}",
                        Latitude = 30.0m + (decimal)random.NextDouble(),
                        Longitude = 31.0m + (decimal)random.NextDouble(),
                        RequestStatus = status,
                        HospitalId = hosp.Id,
                        AmbulanceId = amb.Id,
                        DriverId = driv.Id,
                        CreatedAt = createdAt,
                        AssignedAt = assignedAt,
                        EstimatedArrivalTime = eta,
                        ArrivedAt = arrivedAt,
                        CompletedAt = completedAt,
                        IsAdminIntervention = i % 7 == 0, // Some interventions
                        UpdatedAt = DateTime.UtcNow
                    };
                    context.Requests.Add(request);

                    // Update hospital counts
                    hosp.TotalRequests++;
                    if (status == RequestStatus.Accepted || status == RequestStatus.Finished || status == RequestStatus.Delivered)
                    {
                        hosp.AcceptedRequests++;
                    }
                }
                await context.SaveChangesAsync();
            }

            // 6. Seed 15 Feedback Records
            if (!context.Feedbacks.Any())
            {
                var random = new Random();
                var standardUser = await userManager.Users.FirstOrDefaultAsync(u => u.Email == "user@rescufy.com");
                var userId = standardUser?.Id ?? drivers[0].Id;

                for (int i = 1; i <= 15; i++)
                {
                    var isDriver = random.Next(2) == 0;
                    var targetId = isDriver ? drivers[random.Next(drivers.Count)].Id : paramedics[random.Next(paramedics.Count)].Id;
                    var targetType = isDriver ? FeedbackTargetType.Driver : FeedbackTargetType.Paramedic;

                    var feedback = new Feedback
                    {
                        UserId = userId,
                        Comment = $"Feedback {i} for {(isDriver ? "Driver" : "Paramedic")}",
                        TargetType = targetType,
                        TargetId = targetId,
                        HospitalId = !isDriver ? (int?)hospitals[random.Next(hospitals.Count)].Id : null,
                        AmbulanceId = isDriver ? (int?)ambulances[random.Next(ambulances.Count)].Id : null,
                        Rate = random.Next(1, 6),
                        CreatedAt = DateTime.UtcNow.AddDays(-random.Next(10))
                    };
                    context.Feedbacks.Add(feedback);
                }
                await context.SaveChangesAsync();
            }
        }
    }
}
