using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class AmbulanceConfiguration : IEntityTypeConfiguration<Ambulance>
{
    public void Configure(EntityTypeBuilder<Ambulance> builder)
    {
        builder.ToTable(name: "Ambulances");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
               .HasMaxLength(200)
               .IsRequired();

        builder.Property(x => x.VehicleInfo)
               .HasMaxLength(300);

        builder.Property(x => x.DriverPhone)
               .HasMaxLength(20)
               .IsRequired();

        builder.Property(x => x.AmbulanceStatus)
               .HasConversion<int>()
               .IsRequired();

        builder.Property(x => x.SimLatitude)
               .HasPrecision(9, 6);

        builder.Property(x => x.SimLongitude)
               .HasPrecision(9, 6);

        builder.Property(x => x.AmbulanceNumber)
               .HasMaxLength(50)
               .IsRequired();
               
        builder.HasIndex(x => x.AmbulanceNumber)
               .IsUnique();

        builder.Property(x => x.StartingPrice)
               .HasColumnType("decimal(18,2)");

        // Relationships
        builder.HasOne(x => x.Driver)
               .WithMany()
               .HasForeignKey(x => x.DriverId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(x => x.Paramedic)
               .WithMany()
               .HasForeignKey(x => x.ParamedicId)
               .OnDelete(DeleteBehavior.Restrict);

        builder.HasOne(x => x.AmbulancePoint)
               .WithMany(ap => ap.Ambulances)
               .HasForeignKey(x => x.AmbulancePointId)
               .OnDelete(DeleteBehavior.SetNull);
    }
}
