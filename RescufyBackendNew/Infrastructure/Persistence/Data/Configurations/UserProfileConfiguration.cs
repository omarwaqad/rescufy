using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class UserProfileConfiguration : IEntityTypeConfiguration<UserProfile>
{
    public void Configure(EntityTypeBuilder<UserProfile> builder)
    {
        builder.ToTable("UserProfiles");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.BloodType)
               .HasMaxLength(10)
               .IsRequired();

        builder.Property(x => x.MedicalNotes)
               .HasMaxLength(1000);

        builder.Property(x => x.EmergencyContactName)
               .HasMaxLength(200)
               .IsRequired();

        builder.Property(x => x.EmergencyContactPhone)
               .HasMaxLength(20)
               .IsRequired();

        builder.HasOne(x => x.ApplicationUser)
               .WithOne(u => u.UserProfile)
               .HasForeignKey<UserProfile>(x => x.UserId)
               .OnDelete(DeleteBehavior.Cascade);
    }
}
