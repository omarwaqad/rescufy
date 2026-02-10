using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class RequestConfiguration : IEntityTypeConfiguration<Request>
{
    public void Configure(EntityTypeBuilder<Request> builder)
    {
        builder.ToTable("Requests");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Description)
               .HasMaxLength(2000)
               .IsRequired();

        builder.Property(x => x.Latitude)
               .HasPrecision(9, 6);

        builder.Property(x => x.Longitude)
               .HasPrecision(9, 6);

        builder.Property(x => x.Address)
               .HasMaxLength(500)
               .IsRequired();

        builder.Property(x => x.RequestStatus)
               .HasConversion<int>()
               .IsRequired();

        builder.HasOne(x => x.ApplicationUser)
               .WithMany(u => u.Requests)
               .HasForeignKey(x => x.UserId)
               .OnDelete(DeleteBehavior.Restrict);

        // FIX: One-to-One with AIAnalysis (AIAnalysis is dependent)
        builder.HasOne(x => x.AIAnalysis)
               .WithOne(a => a.Request)
               .HasForeignKey<AIAnalysis>(a => a.RequestId)
               .OnDelete(DeleteBehavior.Cascade);
    }
}
