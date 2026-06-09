using Domain.Contracts;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Persistence.Data;
using Persistence.Repositories;
using Persistence.Seeding;
using ServiceAbstraction;
using Persistence.Services;

namespace Persistence
{
	public static class InfrastructureServicesRegistration
	{
		public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
		{
			services.AddDbContext<ApplicationDbContext>(options =>
			{
				var connectionString = configuration.GetConnectionString("DefaultConnection");
				options.UseSqlServer(connectionString, sqlOptions =>
					sqlOptions.EnableRetryOnFailure(
						maxRetryCount: 5,
						maxRetryDelay: TimeSpan.FromSeconds(30),
						errorNumbersToAdd: null
					)
				);
			});

			services.AddScoped<IDataSeeding, DataSeeding>();
			services.AddScoped<IUnitOfWork, UnitOfWork>();
			services.AddScoped<SuperAdminSeeder>();
			services.AddScoped<RolesSeeder>();
			services.AddScoped<UsersSeeder>();
			services.AddScoped<AmbulanceSeeder>();
			services.AddScoped<HospitalSeeder>();
			services.AddScoped<AnalyticsSeeder>();

            services.AddHttpClient<IAIService, AIService>();

			return services;
		}
	}
}