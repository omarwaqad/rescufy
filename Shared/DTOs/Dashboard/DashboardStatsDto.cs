namespace Shared.DTOs.Dashboard
{
    public class DashboardStatsDto
    {
        public int TotalRequests { get; set; }
        public int CompletedRequests { get; set; }
        public int FailedCancelledRequests { get; set; }
        public int TotalReports { get; set; }
    }
}
