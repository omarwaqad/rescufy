namespace Shared.DTOs.UserProfile
{
    public class UserProfileDto
    {
        public int Id { get; set; }
        public string BloodType { get; set; } = default!;
        public float WeightKg { get; set; }
        public float HeightCm { get; set; }
        public bool PregnancyStatus { get; set; }
        public string MedicalNotes { get; set; } = default!;
        public string? ProfileImageUrl { get; set; }
    }

    public class UpdateUserProfileDto
    {
        public string? BloodType { get; set; }
        public float? WeightKg { get; set; }
        public float? HeightCm { get; set; }
        public bool? PregnancyStatus { get; set; }
        public string? MedicalNotes { get; set; }
        public string? ProfileImageUrl { get; set; }
    }
}
