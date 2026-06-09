using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class FeedbackConfiguration : IEntityTypeConfiguration<Feedback>
    {
        public void Configure(EntityTypeBuilder<Feedback> builder)
        {
            builder.ToTable("Feedbacks");

            builder.HasKey(f => f.Id);

            builder.Property(f => f.Comment)
                .IsRequired()
                .HasMaxLength(1000);

            builder.HasOne(f => f.User)
                .WithMany(u => u.Feedbacks)
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(f => f.Hospital)
                .WithMany(h => h.Feedbacks)
                .HasForeignKey(f => f.HospitalId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasOne(f => f.Ambulance)
                .WithMany(a => a.Feedbacks)
                .HasForeignKey(f => f.AmbulanceId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
