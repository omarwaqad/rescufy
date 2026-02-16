namespace ServiceAbstraction
{
    public interface IAIService
    {
        Task<(string Description, string Status, string Severity)> AnalyzeRequestAsync(string description);
    }
}
