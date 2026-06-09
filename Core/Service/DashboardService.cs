using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs.Dashboard;
using Shared.DTOs.Request;
using Shared.Enums;
using System.Linq;

namespace Service
{
    public class DashboardService(IUnitOfWork unitOfWork) : IDashboardService
    {
        public async Task<DashboardStatsDto> GetStatsAsync()
        {
            var totalRequests = await unitOfWork.GetRepository<Request, int>().CountAsync();

            var completedRequests = await unitOfWork.GetRepository<Request, int>().CountAsync(r =>
                r.RequestStatus == RequestStatus.Delivered ||
                r.RequestStatus == RequestStatus.Finished ||
                r.RequestStatus == RequestStatus.Closed);

            var failedCancelledRequests = await unitOfWork.GetRepository<Request, int>().CountAsync(r => 
                r.RequestStatus == RequestStatus.NotDelivered || 
                r.RequestStatus == RequestStatus.Canceled);

            var totalReports = await unitOfWork.GetRepository<TripReport, int>().CountAsync();

            return new DashboardStatsDto
            {
                TotalRequests = totalRequests,
                CompletedRequests = completedRequests,
                FailedCancelledRequests = failedCancelledRequests,
                TotalReports = totalReports
            };
        }

        public async Task<IEnumerable<RequestLightweightDto>> GetCriticalRequestsAsync()
        {
            var requests = await unitOfWork.GetRepository<Request, int>().GetAllAsync(
                predicate: r => r.AIAnalysis != null && r.AIAnalysis.EmergencyType == EmergencyType.Critical,
                includes: [r => r.ApplicationUser, r => r.Assignments, r => r.AIAnalysis]
            );

            var lightweightRequests = new List<RequestLightweightDto>();

            foreach (var r in requests)
            {
                var latestAssignment = r.Assignments.OrderByDescending(a => a.AssignedAt).FirstOrDefault();
                Ambulance? ambulance = null;
                if (latestAssignment != null)
                {
                    ambulance = await unitOfWork.GetRepository<Ambulance, int>().GetByIdAsync(latestAssignment.AmbulanceId);
                }

                lightweightRequests.Add(new RequestLightweightDto
                {
                    Id = r.Id,
                    Description = r.Description,
                    Address = r.Address,
                    RequestStatus = r.RequestStatus,
                    CreatedAt = r.CreatedAt,
                    PatientName = r.ApplicationUser?.Name ?? "Unknown",
                    AssignedAmbulancePlate = ambulance?.AmbulanceNumber
                });
            }

            return lightweightRequests;
        }
    }
}
