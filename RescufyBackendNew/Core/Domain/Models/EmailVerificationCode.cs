namespace Domain.Models
{
    public class EmailVerificationCode:BaseEntity<int>
    {
        public string Code { get; set; }
        public DateTime ExpirationTime { get; set; }
        public string ApplicationUserId { get; set; }
        public ApplicationUser ApplicationUser { get; set; }
    }
}
