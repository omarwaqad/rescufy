using Domain.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

public class AuditLogConfiguration : IEntityTypeConfiguration<AuditLog>
{
    public void Configure(EntityTypeBuilder<AuditLog> builder)
    {
        builder.ToTable("AuditLogs");

        builder.HasKey(x => x.Id);

        builder.Property(x => x.Action)
               .HasMaxLength(200)
               .IsRequired();

        builder.Property(x => x.Details)
               .HasMaxLength(2000);

        // FIX: RequestId كان string، عدلناه logical FK int
        builder.Property<int?>("RequestId");

        builder.HasOne(x => x.Request)
               .WithMany(r => r.AuditLogs)
               .HasForeignKey("RequestId")
               .OnDelete(DeleteBehavior.SetNull);

        builder.HasOne(x => x.ApplicationUser)
               .WithMany(u => u.AuditLogs)
               .HasForeignKey(x => x.ActorId)
               .OnDelete(DeleteBehavior.Restrict);
    }
}
