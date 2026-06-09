using API.AuthFilters;
using Microsoft.AspNetCore.HttpOverrides;

using API.Hubs.Notification;
using API.Middlewares.Extensions;
using Domain.Contracts;
using Domain.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Any;
using Microsoft.OpenApi.Models;
using Persistence;
using Persistence.Data;
using Serilog;
using Serilog.Ui.Core.Extensions;
using Serilog.Ui.MsSqlServerProvider.Extensions;
using Serilog.Ui.Web.Extensions;
using Service;
using ServiceAbstraction;
using Shared.Settings;
using System.Globalization;
using System.Text;
using System.Threading.RateLimiting;

namespace API
{
	public class Program
	{
		public static void Main(string[] args)
		{
			var builder = WebApplication.CreateBuilder(args);

			#region Add services to the container 

			#region Serilog Configuration
			Log.Logger = new LoggerConfiguration()
				.ReadFrom.Configuration(builder.Configuration)
				.CreateLogger();
			builder.Host.UseSerilog();

			builder.Services.AddSerilogUi(options =>
				options.UseSqlServer(opts => opts
					.WithConnectionString(builder.Configuration.GetConnectionString("DefaultConnection") ?? String.Empty)
					.WithSchema("Logging")
					.WithTable("Logs")
				)
				.AddScopedAsyncAuthFilter<SerilogUiAuthorizationFilter>()
			);
			#endregion

			builder.Services.AddControllers()
				.AddApplicationPart(typeof(Presentation.Controllers.ApiController).Assembly)
				.AddJsonOptions(options =>
				{
					options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
					options.JsonSerializerOptions.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());
				});
			builder.Services.AddEndpointsApiExplorer();
			builder.Services.AddSwaggerGen(options =>
			{
				options.SwaggerDoc("v1", new OpenApiInfo { Title = "Rescufy", Version = "v1" });

				options.CustomSchemaIds(type => type.FullName);

				options.MapType<DateOnly>(() => new OpenApiSchema
				{
					Type = "string",
					Format = "date",
					Example = new OpenApiString("2024-12-02")
				});

				options.MapType<TimeOnly>(() => new OpenApiSchema
				{
					Type = "string",
					Format = "time",
					Example = new OpenApiString("14:30")
				});

				options.AddSecurityDefinition("Bearer", securityScheme: new OpenApiSecurityScheme
				{
					Name = "Authorization",
					Type = SecuritySchemeType.ApiKey,
					Scheme = "Bearer",
					BearerFormat = "JWT",
					In = ParameterLocation.Header,
					Description = "Enter your JWT key"
				});

				options.AddSecurityRequirement(new OpenApiSecurityRequirement
				{
					{
						new OpenApiSecurityScheme
						{
							Reference = new OpenApiReference
							{
								Type = ReferenceType.SecurityScheme,
								Id = "Bearer"
							},
							Name ="Bearer",
							In = ParameterLocation.Header
						},
						new List<string>()
					}
				});

				var xmlFile = $"{System.Reflection.Assembly.GetExecutingAssembly().GetName().Name}.xml";
				var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
				if (File.Exists(xmlPath)) options.IncludeXmlComments(xmlPath);

				// Also include XML comments from the Presentation project if available
				var presentationXml = "Presentation.xml";
				var presentationPath = Path.Combine(AppContext.BaseDirectory, presentationXml);
				if (File.Exists(presentationPath)) options.IncludeXmlComments(presentationPath);
			});
			
			builder.Services.Configure<ForwardedHeadersOptions>(options =>
			{
				options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
				// Clear known networks and proxies to allow local/proxy headers
				options.KnownNetworks.Clear();
				options.KnownProxies.Clear();
			});

			builder.Services.AddHttpContextAccessor();

			builder.Services.AddInfrastructureServices(builder.Configuration);
			builder.Services.AddApplicationServices(builder.Configuration);
			builder.Services.AddSignalR()
				.AddJsonProtocol(options =>
				{
					options.PayloadSerializerOptions.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());
				});
			builder.Services.AddScoped<INotificationRealTimeSender, NotificationRealTimeSender>();
			builder.Services.AddScoped<IAmbulanceRealTimeSender, API.Hubs.Ambulance.AmbulanceRealTimeSender>();

			#region Hashing Decryption Configuration
			//((IConfigurationBuilder)builder.Configuration).Add(new DecryptedConfigurationSource());
			#endregion

			#region Settings Configuration
			builder.Services.Configure<SmtpSettings>(builder.Configuration.GetSection("SmtpSettings"));
			builder.Services.Configure<AppSettings>(builder.Configuration.GetSection("AppSettings"));
			#endregion

			#region Add Identity
			builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
			.AddEntityFrameworkStores<ApplicationDbContext>()
			.AddDefaultTokenProviders();
			#endregion

			#region Add Authentication

			builder.Services.AddAuthentication(options =>
			{
				options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
				options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
			})
			.AddJwtBearer(options =>
			{
				options.TokenValidationParameters = new TokenValidationParameters
				{
					ValidateIssuer = true,
					ValidateAudience = true,
					ValidateLifetime = true,
					ValidateIssuerSigningKey = true,
					ValidIssuer = builder.Configuration["JWT:ValidIssuer"],
					ValidAudience = builder.Configuration["JWT:ValidAudience"],
					IssuerSigningKey = new SymmetricSecurityKey(
						Encoding.UTF8.GetBytes(builder.Configuration["JWT:SecretKey"] ?? String.Empty))
				};
				options.Events = new JwtBearerEvents
				{
					OnMessageReceived = context =>
					{
						var accessToken = context.Request.Query["access_token"];

						var path = context.HttpContext.Request.Path;
						if (!string.IsNullOrEmpty(accessToken) &&
							(path.StartsWithSegments("/hubs/notifications") || path.StartsWithSegments("/hubs/ambulance")))
						{
							context.Token = accessToken;
						}

						return Task.CompletedTask;
					}
				};
			});

			#endregion

			#region Localization
			builder.Services.AddLocalization();
			builder.Services.Configure<RequestLocalizationOptions>(options =>
			{
				var supportedCultures = new List<CultureInfo>
				{
					new CultureInfo("en"),
					new CultureInfo("ar")
				};

				options.DefaultRequestCulture = new RequestCulture("ar");
				options.SupportedCultures = supportedCultures;
				options.SupportedUICultures = supportedCultures;

				// Override default provider
				options.RequestCultureProviders.Insert(0, new CustomRequestCultureProvider(async context =>
				{
					var acceptLang = context.Request.Headers["Accept-Language"].ToString();

					if (string.IsNullOrWhiteSpace(acceptLang))
						return await Task.FromResult(new ProviderCultureResult("ar"));

					var lang = acceptLang.Split(',').FirstOrDefault()?.Trim().ToLower();

					if (lang != "ar" && lang != "en")
						lang = "ar";

					return await Task.FromResult(new ProviderCultureResult(lang));
				}));
			});

			#endregion

			#region CORS
			builder.Services.AddCors(options =>
			{
				options.AddPolicy("UnifiedPolicy", policy =>
				{
					var frontEndUrl = builder.Configuration["AppSettings:FrontEndUrl"]?.TrimEnd('/');
					var baseUrl = builder.Configuration["AppSettings:BaseUrl"]?.TrimEnd('/');

					var allowedOrigins = new List<string> 
					{ 
						"http://localhost:3000", "https://localhost:3000", 
						"http://localhost:4200", "https://localhost:4200", 
						"http://localhost:5173", "https://localhost:5173",
						"http://127.0.0.1:3000", "http://127.0.0.1:4200", "http://127.0.0.1:5173",
						"https://rescufy.vercel.app"
					};

					if (!string.IsNullOrEmpty(frontEndUrl) && !allowedOrigins.Contains(frontEndUrl))
					{
						allowedOrigins.Add(frontEndUrl);
					}

					if (!string.IsNullOrEmpty(baseUrl) && !allowedOrigins.Contains(baseUrl))
					{
						allowedOrigins.Add(baseUrl);
					}

					policy.WithOrigins(allowedOrigins.ToArray())
						  .AllowAnyHeader()
						  .AllowAnyMethod()
						  .AllowCredentials();
				});
			});
			#endregion

			#region RateLimiter Configuration
			builder.Services.AddMemoryCache();
			builder.Services.AddRateLimiter(options =>
			{
				options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

				options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(httpContext =>
					RateLimitPartition.GetFixedWindowLimiter(
						partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
						factory: _ => new FixedWindowRateLimiterOptions
						{
							PermitLimit = 100,
							Window = TimeSpan.FromSeconds(10),
							//QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
							//QueueLimit = 2 
						}
					)
				);
			});
			#endregion

			#endregion

			builder.Services.AddSingleton<IUserIdProvider, NameIdentifierUserIdProvider>();

			var app = builder.Build();

			#region Data Seeding
			using var scope = app.Services.CreateScope();
			var objectDataSeeding = scope.ServiceProvider.GetRequiredService<IDataSeeding>();
			objectDataSeeding.DataSeed();
			#endregion

			#region Configure the HTTP request pipeline

			app.UseForwardedHeaders();

			app.UseSwagger();
			app.UseSwaggerUI();

			#region Localization Middleware
			var options = app.Services.GetService<IOptions<RequestLocalizationOptions>>();
			app.UseRequestLocalization(options!.Value);
			#endregion

			app.UseErrorHandlingMiddleware();

			#region CORS Middleware
			app.UseCors("UnifiedPolicy");
			#endregion

			app.UseHttpsRedirection();

			app.UseStaticFiles();

			#region IP Security Middleware
			app.UseIpSecurity();
			#endregion

			app.UseAuthentication();
			app.UseAuthorization();

			#region RateLimiter Middleware
			app.UseCustomRateLimiter();
			app.UseRateLimiter();
			#endregion

			#region SerilogUI Middleware
			app.UseSerilogUiAuth();
			app.UseSerilogUi();
			#endregion

			app.MapControllers();
			app.MapHub<API.Hubs.Ambulance.AmbulanceHub>("/hubs/ambulance");
			app.MapHub<NotificationHub>("/hubs/notifications");

			app.Run();

			#endregion
		}
	}
}