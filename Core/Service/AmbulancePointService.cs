using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.AmbulancePoint;
using Shared.Enums;

namespace Service
{
    public class AmbulancePointService(IUnitOfWork unitOfWork) : IAmbulancePointService
    {
        public async Task<AmbulancePointCapacityDto> GetCapacityAsync(int pointId)
        {
            var ambulancePoint = (await unitOfWork.GetRepository<AmbulancePoint, int>()
                .GetAllAsync(predicate: p => p.Id == pointId, includes: [p => p.Ambulances]))
                .FirstOrDefault();

            if (ambulancePoint == null)
                throw new Exception("Ambulance point not found");

            var availableCount = ambulancePoint.Ambulances
                .Count(a => a.AmbulanceStatus == AmbulanceStatus.Available);

            return new AmbulancePointCapacityDto
            {
                AmbulancePointId = pointId,
                Name = ambulancePoint.Name,
                NumberOfAvailableAmbulances = availableCount,
                TotalAmbulances = ambulancePoint.Ambulances.Count
            };
        }
    }
}
