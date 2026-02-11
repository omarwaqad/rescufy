using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class AIAnalysisConfiguration : IEntityTypeConfiguration<AIAnalysis>
{
    public void Configure(EntityTypeBuilder<AIAnalysis> builder)
    {
        builder.ToTable("AIAnalyses");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Summary)
               .HasMaxLength(2000)
               .IsRequired();

        builder.Property(x => x.EmergencyType)
               .HasConversion<int>()
               .IsRequired();

        builder.Property(x => x.Urgency)
               .HasMaxLength(100)
               .IsRequired();
    }
}