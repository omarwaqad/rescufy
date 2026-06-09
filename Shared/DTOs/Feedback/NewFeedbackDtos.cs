using System.ComponentModel.DataAnnotations;

namespace Shared.DTOs.Feedback
{
    public class CreateHospitalFeedbackDto
    {
        [Required]
        public int HospitalId { get; set; }
        [Required]
        public int RequestId { get; set; }
        [Range(1, 5)]
        public int Rate { get; set; }
        [Required]
        public string Comment { get; set; } = default!;
    }

    public class CreateParamedicFeedbackDto
    {
        [Required]
        public string ParamedicId { get; set; } = default!;
        [Required]
        public int RequestId { get; set; }
        [Range(1, 5)]
        public int Rate { get; set; }
        [Required]
        public string Comment { get; set; } = default!;
    }

    public class CreateDriverFeedbackDto
    {
        [Required]
        public string DriverId { get; set; } = default!;
        [Required]
        public int RequestId { get; set; }
        [Range(1, 5)]
        public int Rate { get; set; }
        [Required]
        public string Comment { get; set; } = default!;
    }

    public class HospitalFeedbackDto
    {
        public int Id { get; set; }
        public int HospitalId { get; set; }
        public int RequestId { get; set; }
        public int Rate { get; set; }
        public string Comment { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
    }

    public class ParamedicFeedbackDto
    {
        public int Id { get; set; }
        public string ParamedicId { get; set; } = default!;
        public int RequestId { get; set; }
        public int Rate { get; set; }
        public string Comment { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
    }

    public class DriverFeedbackDto
    {
        public int Id { get; set; }
        public string DriverId { get; set; } = default!;
        public int RequestId { get; set; }
        public int Rate { get; set; }
        public string Comment { get; set; } = default!;
        public DateTime CreatedAt { get; set; }
    }
}
