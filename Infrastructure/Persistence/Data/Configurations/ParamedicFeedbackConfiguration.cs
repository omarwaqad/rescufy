using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Persistence.Data.Configurations
{
    public class ParamedicFeedbackConfiguration : IEntityTypeConfiguration<ParamedicFeedback>
    {
        public void Configure(EntityTypeBuilder<ParamedicFeedback> builder)
        {
            builder.ToTable("ParamedicFeedbacks");
            builder.HasKey(f => f.Id);

            builder.Property(f => f.Comment).IsRequired().HasMaxLength(1000);

            builder.HasOne(f => f.User)
                .WithMany()
                .HasForeignKey(f => f.UserId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(f => f.Paramedic)
                .WithMany()
                .HasForeignKey(f => f.ParamedicId)
                .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(f => f.Request)
                .WithMany()
                .HasForeignKey(f => f.RequestId)
                .OnDelete(DeleteBehavior.NoAction);
        }
    }
}
