using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.Ambulance;
using Shared.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Service
{
    public class AmbulanceService(IUnitOfWork unitOfWork, Microsoft.AspNetCore.Identity.UserManager<ApplicationUser> userManager) : IAmbulanceService
    {
        public async Task<AmbulanceDto> CreateAsync(CreateAmbulanceDto dto)
        {
            var ambulance = new Ambulance
            {
                Name = dto.Name,
                VehicleInfo = dto.VehicleInfo,
                DriverPhone = dto.DriverPhone,
                AmbulanceStatus = AmbulanceStatus.Available,
                DriverId = dto.DriverId,
                ParamedicId = dto.ParamedicId,
                StartingPrice = dto.StartingPrice,
                AmbulanceNumber = dto.AmbulanceNumber,
                AmbulancePointId = dto.AmbulancePointId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            await unitOfWork.GetRepository<Ambulance, int>().AddAsync(ambulance);
            await unitOfWork.SaveChangesAsync();

            // Update staff profiles
            if (!string.IsNullOrEmpty(dto.DriverId))
            {
                var user = await userManager.FindByIdAsync(dto.DriverId);
                if (user != null)
                {
                    user.AssignedAmbulanceId = ambulance.Id;
                    await userManager.UpdateAsync(user);
                }
            }
            if (!string.IsNullOrEmpty(dto.ParamedicId))
            {
                var user = await userManager.FindByIdAsync(dto.ParamedicId);
                if (user != null)
                {
                    user.AssignedAmbulanceId = ambulance.Id;
                    await userManager.UpdateAsync(user);
                }
            }

            return MapToDto(ambulance);
        }

        public async Task<AmbulanceDto> GetByIdAsync(int id)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetFirstOrDefaultAsync(
                predicate: a => a.Id == id && !a.IsDeleted,
                includes: [a => a.Driver, a => a.Paramedic]
            );
            
            if (ambulance == null) throw new Exception("Ambulance not found");
            
            return MapToDto(ambulance);
        }

        public async Task<IEnumerable<AmbulanceDto>> GetAllAsync()
        {
            var ambulances = await unitOfWork.GetRepository<Ambulance, int>().GetAllAsync(
                predicate: a => !a.IsDeleted,
                includes: [a => a.Driver, a => a.Paramedic]
            );
            
            return ambulances.Select(MapToDto);
        }

        public async Task<AmbulanceDto> UpdateAsync(int id, UpdateAmbulanceDto dto)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(id);
            if (ambulance == null || ambulance.IsDeleted) throw new Exception("Ambulance not found");

            // Handle staff changes
            await AssignStaffAsync(id, dto.DriverId, dto.ParamedicId);

            ambulance.Name = dto.Name;
            ambulance.VehicleInfo = dto.VehicleInfo;
            ambulance.DriverPhone = dto.DriverPhone;
            ambulance.StartingPrice = dto.StartingPrice;
            ambulance.AmbulanceNumber = dto.AmbulanceNumber;
            ambulance.AmbulancePointId = dto.AmbulancePointId;
            ambulance.AmbulanceStatus = dto.AmbulanceStatus;
            ambulance.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Ambulance, int>().Update(ambulance);
            await unitOfWork.SaveChangesAsync();

            return MapToDto(ambulance);
        }

        public async Task DeleteAsync(int id)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(id);
            if (ambulance == null) return;

            ambulance.IsDeleted = true;
            unitOfWork.GetRepository<Ambulance, int>().Update(ambulance);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task<AmbulanceDto> GetByDriverIdAsync(string driverId)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetFirstOrDefaultAsync(
                predicate: a => (a.DriverId == driverId || a.ParamedicId == driverId) && !a.IsDeleted,
                includes: a => a.Driver
            );

            if (ambulance == null) throw new Exception("Ambulance not assigned to this staff member.");

            return MapToDto(ambulance);
        }

        public async Task SetActiveStatusAsync(string driverId, bool isActive)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetFirstOrDefaultAsync(
                predicate: a => (a.DriverId == driverId || a.ParamedicId == driverId) && !a.IsDeleted
            );

            if (ambulance == null) throw new Exception("Ambulance not assigned to this staff member.");

            ambulance.IsActive = isActive;
            ambulance.UpdatedAt = DateTime.UtcNow;

            unitOfWork.GetRepository<Ambulance, int>().Update(ambulance);
            await unitOfWork.SaveChangesAsync();
        }

        public async Task AssignStaffAsync(int ambulanceId, string? driverId, string? paramedicId)
        {
            var ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(ambulanceId);
            if (ambulance == null || ambulance.IsDeleted) throw new Exception("Ambulance not found");

            // Handle Driver Assignment
            if (ambulance.DriverId != driverId)
            {
                if (!string.IsNullOrEmpty(ambulance.DriverId))
                {
                    var oldDriver = await userManager.FindByIdAsync(ambulance.DriverId);
                    if (oldDriver != null)
                    {
                        oldDriver.AssignedAmbulanceId = null;
                        await userManager.UpdateAsync(oldDriver);
                    }
                }

                if (!string.IsNullOrEmpty(driverId))
                {
                    var newDriver = await userManager.FindByIdAsync(driverId);
                    if (newDriver != null)
                    {
                        newDriver.AssignedAmbulanceId = ambulanceId;
                        await userManager.UpdateAsync(newDriver);
                    }
                }
                ambulance.DriverId = driverId;
            }

            // Handle Paramedic Assignment
            if (ambulance.ParamedicId != paramedicId)
            {
                if (!string.IsNullOrEmpty(ambulance.ParamedicId))
                {
                    var oldParamedic = await userManager.FindByIdAsync(ambulance.ParamedicId);
                    if (oldParamedic != null)
                    {
                        oldParamedic.AssignedAmbulanceId = null;
                        await userManager.UpdateAsync(oldParamedic);
                    }
                }

                if (!string.IsNullOrEmpty(paramedicId))
                {
                    var newParamedic = await userManager.FindByIdAsync(paramedicId);
                    if (newParamedic != null)
                    {
                        newParamedic.AssignedAmbulanceId = ambulanceId;
                        await userManager.UpdateAsync(newParamedic);
                    }
                }
                ambulance.ParamedicId = paramedicId;
            }

            ambulance.UpdatedAt = DateTime.UtcNow;
            await unitOfWork.SaveChangesAsync();
        }

        private AmbulanceDto MapToDto(Ambulance a)
        {
            return new AmbulanceDto
            {
                Id = a.Id,
                Name = a.Name,
                VehicleInfo = a.VehicleInfo,
                DriverPhone = a.DriverPhone,
                AmbulanceStatus = a.AmbulanceStatus,
                SimLatitude = a.SimLatitude,
                SimLongitude = a.SimLongitude,
                DriverId = a.DriverId,
                DriverName = a.Driver?.Name,
                ParamedicId = a.ParamedicId,
                ParamedicName = a.Paramedic?.Name,
                StartingPrice = a.StartingPrice,
                AmbulanceNumber = a.AmbulanceNumber,
                AmbulancePointId = a.AmbulancePointId,
                IsActive = a.IsActive
            };
        }
    }
}
