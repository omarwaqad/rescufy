using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class AmbulancePointConfiguration : IEntityTypeConfiguration<AmbulancePoint>
    {
        public void Configure(EntityTypeBuilder<AmbulancePoint> builder)
        {
            builder.ToTable("AmbulancePoints");

            builder.HasKey(ap => ap.Id);

            builder.Property(ap => ap.Name)
                .IsRequired()
                .HasMaxLength(200);

            builder.Property(ap => ap.Latitude)
                .HasPrecision(9, 6)
                .IsRequired();

            builder.Property(ap => ap.Longitude)
                .HasPrecision(9, 6)
                .IsRequired();

            builder.Property(ap => ap.Address)
                .IsRequired()
                .HasMaxLength(500);

            builder.HasMany(ap => ap.Ambulances)
                .WithOne(a => a.AmbulancePoint)
                .HasForeignKey(a => a.AmbulancePointId)
                .OnDelete(DeleteBehavior.SetNull);
        }
    }
}
