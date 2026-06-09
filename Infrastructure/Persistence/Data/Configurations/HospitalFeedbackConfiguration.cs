using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class HospitalFeedbackConfiguration : IEntityTypeConfiguration<HospitalFeedback>
    {
        public void Configure(EntityTypeBuilder<HospitalFeedback> builder)
        {
            builder.ToTable("HospitalFeedbacks");
            builder.HasKey(f => f.Id);

            builder.Property(f => f.Comment).IsRequired().HasMaxLength(1000);

            builder.HasOne(f => f.User)
                .WithMany()
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(f => f.Hospital)
                .WithMany()
                .HasForeignKey(f => f.HospitalId)
                .OnDelete(DeleteBehavior.Restrict);

            builder.HasOne(f => f.Request)
                .WithMany()
                .HasForeignKey(f => f.RequestId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}
