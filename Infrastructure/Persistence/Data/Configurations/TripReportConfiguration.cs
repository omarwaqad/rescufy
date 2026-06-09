using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class TripReportConfiguration : IEntityTypeConfiguration<TripReport>
    {
        public void Configure(EntityTypeBuilder<TripReport> builder)
        {
            builder.HasKey(tr => tr.Id);

            builder.Property(tr => tr.MedicalProcedures)
                .IsRequired();

            // One-to-One with Request
            builder.HasOne(tr => tr.Request)
                .WithOne(r => r.TripReport)
                .HasForeignKey<TripReport>(tr => tr.RequestId)
                .OnDelete(DeleteBehavior.Restrict);

            // One-to-Many with Patient
            builder.HasOne(tr => tr.Patient)
                .WithMany(p => p.TripReports)
                .HasForeignKey(tr => tr.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            // One-to-Many with Hospital
            builder.HasOne(tr => tr.Hospital)
                .WithMany(h => h.TripReports)
                .HasForeignKey(tr => tr.HospitalId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
