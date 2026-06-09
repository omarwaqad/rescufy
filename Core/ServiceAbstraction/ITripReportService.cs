using Shared.DTOs.TripReport;
using System.Threading.Tasks;

namespace ServiceAbstraction
{
    public interface ITripReportService
    {
        Task<TripReportDto> CreateTripReportAsync(CreateTripReportDto dto);
        Task<TripReportDto> UpdateTripReportAsync(int id, UpdateTripReportDto dto);
        Task<TripReportDto> GetTripReportByRequestIdAsync(int requestId);
    }
}
