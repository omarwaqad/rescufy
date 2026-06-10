using Domain.Contracts;
using Domain.Models;
using ServiceAbstraction;
using Shared.DTOs;
using Shared.DTOs.Dispatch;
using System.Linq;
using System.Threading.Tasks;

namespace Service
{
    public class AlertService(IUnitOfWork unitOfWork) : IAlertService
    {
        public async Task<PagedResponse<AlertDto>> GetAlertsPagedAsync(int page, int limit)
        {
            var query = await unitOfWork.GetRepository<DispatchAlert, int>()
                .GetAllAsync(predicate: a => true);

            var totalItems = query.Count();
            var items = query.OrderByDescending(a => a.Timestamp)
                             .Skip((page - 1) * limit)
                             .Take(limit)
                             .Select(a => new AlertDto
                             {
                                 AlertId = a.AlertId,
                                 Level = a.Level,
                                 Title = a.Title,
                                 Message = a.Message,
                                 Zone = a.Zone,
                                 Recommendation = a.Recommendation,
                                 Timestamp = a.Timestamp
                             })
                             .ToList();

            return new PagedResponse<AlertDto>
            {
                Data = items,
                Meta = new PaginationMeta
                {
                    Page = page,
                    Limit = limit,
                    TotalItems = totalItems,
                    TotalPages = (int)System.Math.Ceiling(totalItems / (double)limit)
                }
            };
        }

        public async Task CreateAlertAsync(AlertDto alert)
        {
            var entity = new DispatchAlert
            {
                AlertId = alert.AlertId ?? System.Guid.NewGuid().ToString(),
                Level = alert.Level,
                Title = alert.Title,
                Message = alert.Message,
                Zone = alert.Zone ?? "System",
                Recommendation = alert.Recommendation,
                Timestamp = System.DateTime.UtcNow
            };
            await unitOfWork.GetRepository<DispatchAlert, int>().AddAsync(entity);
            await unitOfWork.SaveChangesAsync();
        }
    }
}
