namespace Domain.Models
{
    public class UserProfile
    {
        public int Id { get; set; }
        public string UserId { get; set; } = default!;
        public string BloodType { get; set; } = default!;
        public string MedicalNotes { get; set; } = default!;
        public string EmergencyContactName { get; set; } = default!;
        public string EmergencyContactPhone { get; set; } = default!;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; }

        // Navigation Properties
        public ApplicationUser ApplicationUser { get; set; } = default!;
    }

}