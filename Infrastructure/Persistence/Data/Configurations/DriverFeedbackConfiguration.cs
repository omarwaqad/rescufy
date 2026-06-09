using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class DriverFeedbackConfiguration : IEntityTypeConfiguration<DriverFeedback>
    {
        public void Configure(EntityTypeBuilder<DriverFeedback> builder)
        {
            builder.ToTable("DriverFeedbacks");
            builder.HasKey(f => f.Id);

            builder.Property(f => f.Comment).IsRequired().HasMaxLength(1000);

            builder.HasOne(f => f.User)
                .WithMany()
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(f => f.Driver)
                .WithMany()
                .HasForeignKey(f => f.DriverId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(f => f.Request)
                .WithMany()
                .HasForeignKey(f => f.RequestId)
                .OnDelete(DeleteBehavior.NoAction);
        }
    }
}
