namespace Shared.DTOs.Hospital
{
    public class HospitalWeeklyStatsDto
    {
        public int Year { get; set; }
        public int WeekNumber { get; set; }
        public int TotalCasesAccepted { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
    }
}
