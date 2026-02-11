using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class HospitalConfiguration : IEntityTypeConfiguration<Hospital>
{
    public void Configure(EntityTypeBuilder<Hospital> builder)
    {
        builder.ToTable("Hospitals");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
               .HasMaxLength(300)
               .IsRequired();

        builder.Property(x => x.Address)
               .HasMaxLength(500)
               .IsRequired();

        builder.Property(x => x.ContactPhone)
               .HasMaxLength(20)
               .IsRequired();

        builder.Property(x => x.CapacityNotes)
               .HasMaxLength(1000);
    }
}