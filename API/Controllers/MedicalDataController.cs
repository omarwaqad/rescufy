using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using ServiceAbstraction;
using Shared.DTOs.UserProfile;
using System.Security.Claims;
using Shared.Enums;

namespace API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class MedicalDataController(IProfileService profileService) : ControllerBase
    {
        private string? CurrentUserId => User.FindFirstValue(ClaimTypes.NameIdentifier);

        // Medications

        /// <summary>
        /// Retrieves the list of medications for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the list of medications</response>
        [HttpGet("medications")]
        [ProducesResponseType(typeof(IEnumerable<MedicationDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetMedications()
        {
            if (CurrentUserId == null) return Unauthorized();
            return Ok(await profileService.GetMedicationsAsync(CurrentUserId));
        }

        /// <summary>
        /// Adds a new medication record for the authenticated user.
        /// </summary>
        /// <param name="dto">The medication details</param>
        /// <response code="200">Returns the added medication</response>
        [HttpPost("medications")]
        [ProducesResponseType(typeof(MedicationDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddMedication([FromBody] CreateMedicationDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.AddMedicationAsync(CurrentUserId, dto);
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing medication record.
        /// </summary>
        /// <param name="id">The medication unique identifier</param>
        /// <param name="dto">The updated medication details</param>
        /// <response code="200">Returns the updated medication</response>
        [HttpPut("medications/{id}")]
        [ProducesResponseType(typeof(MedicationDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateMedication([FromRoute] Guid id, [FromBody] CreateMedicationDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.UpdateMedicationAsync(CurrentUserId, id, dto);
            if (result == null) return NotFound();
            return Ok(result);
        }

        /// <summary>
        /// Deletes a specific medication record.
        /// </summary>
        /// <param name="id">The medication unique identifier</param>
        /// <response code="204">Medication deleted successfully</response>
        [HttpDelete("medications/{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteMedication([FromRoute] Guid id)
        {
            if (CurrentUserId == null) return Unauthorized();
            await profileService.DeleteMedicationAsync(CurrentUserId, id);
            return NoContent();
        }

        // Allergies

        /// <summary>
        /// Retrieves the list of allergies for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the list of allergies</response>
        [HttpGet("allergies")]
        [ProducesResponseType(typeof(IEnumerable<AllergyDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetAllergies()
        {
            if (CurrentUserId == null) return Unauthorized();
            return Ok(await profileService.GetAllergiesAsync(CurrentUserId));
        }

        /// <summary>
        /// Adds a new allergy record for the authenticated user.
        /// </summary>
        /// <param name="dto">The allergy details</param>
        /// <response code="200">Returns the added allergy</response>
        [HttpPost("allergies")]
        [ProducesResponseType(typeof(AllergyDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddAllergy([FromBody] CreateAllergyDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.AddAllergyAsync(CurrentUserId, dto);
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing allergy record.
        /// </summary>
        /// <param name="id">The allergy unique identifier</param>
        /// <param name="dto">The updated allergy details</param>
        /// <response code="200">Returns the updated allergy</response>
        [HttpPut("allergies/{id}")]
        [ProducesResponseType(typeof(AllergyDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateAllergy([FromRoute] Guid id, [FromBody] CreateAllergyDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.UpdateAllergyAsync(CurrentUserId, id, dto);
            if (result == null) return NotFound();
            return Ok(result);
        }

        /// <summary>
        /// Deletes a specific allergy record.
        /// </summary>
        /// <param name="id">The allergy unique identifier</param>
        /// <response code="204">Allergy deleted successfully</response>
        [HttpDelete("allergies/{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteAllergy([FromRoute] Guid id)
        {
            if (CurrentUserId == null) return Unauthorized();
            await profileService.DeleteAllergyAsync(CurrentUserId, id);
            return NoContent();
        }

        // Chronic Diseases

        /// <summary>
        /// Retrieves the list of chronic diseases for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the list of chronic diseases</response>
        [HttpGet("chronic-diseases")]
        [ProducesResponseType(typeof(IEnumerable<ChronicDiseaseDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetChronicDiseases()
        {
            if (CurrentUserId == null) return Unauthorized();
            return Ok(await profileService.GetChronicDiseasesAsync(CurrentUserId));
        }

        /// <summary>
        /// Adds a new chronic disease record for the authenticated user.
        /// </summary>
        /// <param name="dto">The chronic disease details</param>
        /// <response code="200">Returns the added chronic disease</response>
        [HttpPost("chronic-diseases")]
        [ProducesResponseType(typeof(ChronicDiseaseDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddChronicDisease([FromBody] CreateChronicDiseaseDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.AddChronicDiseaseAsync(CurrentUserId, dto);
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing chronic disease record.
        /// </summary>
        /// <param name="id">The chronic disease unique identifier</param>
        /// <param name="dto">The updated chronic disease details</param>
        /// <response code="200">Returns the updated chronic disease</response>
        [HttpPut("chronic-diseases/{id}")]
        [ProducesResponseType(typeof(ChronicDiseaseDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateChronicDisease([FromRoute] Guid id, [FromBody] CreateChronicDiseaseDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.UpdateChronicDiseaseAsync(CurrentUserId, id, dto);
            if (result == null) return NotFound();
            return Ok(result);
        }

        /// <summary>
        /// Deletes a specific chronic disease record.
        /// </summary>
        /// <param name="id">The chronic disease unique identifier</param>
        /// <response code="204">Chronic disease deleted successfully</response>
        [HttpDelete("chronic-diseases/{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteChronicDisease([FromRoute] Guid id)
        {
            if (CurrentUserId == null) return Unauthorized();
            await profileService.DeleteChronicDiseaseAsync(CurrentUserId, id);
            return NoContent();
        }

        // Emergency Contacts

        /// <summary>
        /// Retrieves the list of emergency contacts for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the list of emergency contacts</response>
        [HttpGet("emergency-contacts")]
        [ProducesResponseType(typeof(IEnumerable<EmergencyContactDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetEmergencyContacts()
        {
            if (CurrentUserId == null) return Unauthorized();
            return Ok(await profileService.GetEmergencyContactsAsync(CurrentUserId));
        }

        /// <summary>
        /// Adds a new emergency contact for the authenticated user.
        /// </summary>
        /// <param name="dto">The contact details</param>
        /// <response code="200">Returns the added contact</response>
        [HttpPost("emergency-contacts")]
        [ProducesResponseType(typeof(EmergencyContactDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddEmergencyContact([FromBody] CreateEmergencyContactDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.AddEmergencyContactAsync(CurrentUserId, dto);
            return Ok(result);
        }

        /// <summary>
        /// Updates an existing emergency contact record.
        /// </summary>
        /// <param name="id">The contact unique identifier</param>
        /// <param name="dto">The updated contact details</param>
        /// <response code="200">Returns the updated contact</response>
        [HttpPut("emergency-contacts/{id}")]
        [ProducesResponseType(typeof(EmergencyContactDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateEmergencyContact([FromRoute] Guid id, [FromBody] CreateEmergencyContactDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.UpdateEmergencyContactAsync(CurrentUserId, id, dto);
            if (result == null) return NotFound();
            return Ok(result);
        }

        /// <summary>
        /// Deletes a specific emergency contact.
        /// </summary>
        /// <param name="id">The contact unique identifier</param>
        /// <response code="204">Contact deleted successfully</response>
        [HttpDelete("emergency-contacts/{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteEmergencyContact([FromRoute] Guid id)
        {
            if (CurrentUserId == null) return Unauthorized();
            await profileService.DeleteEmergencyContactAsync(CurrentUserId, id);
            return NoContent();
        }

        // Past Surgeries

        /// <summary>
        /// Retrieves the list of past surgeries for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the list of surgeries</response>
        [HttpGet("past-surgeries")]
        [ProducesResponseType(typeof(IEnumerable<PastSurgeryDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetPastSurgeries()
        {
            if (CurrentUserId == null) return Unauthorized();
            return Ok(await profileService.GetPastSurgeriesAsync(CurrentUserId));
        }

        /// <summary>
        /// Adds a new past surgery record for the authenticated user.
        /// </summary>
        /// <param name="dto">The surgery details</param>
        /// <response code="200">Returns the added surgery record</response>
        [HttpPost("past-surgeries")]
        [ProducesResponseType(typeof(PastSurgeryDto), StatusCodes.Status200OK)]
        public async Task<IActionResult> AddPastSurgery([FromBody] CreatePastSurgeryDto dto)
        {
            if (CurrentUserId == null) return Unauthorized();
            var result = await profileService.AddPastSurgeryAsync(CurrentUserId, dto);
            return Ok(result);
        }

        /// <summary>
        /// Deletes a specific past surgery record.
        /// </summary>
        /// <param name="id">The surgery unique identifier</param>
        /// <response code="204">Surgery record deleted successfully</response>
        [HttpDelete("past-surgeries/{id}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeletePastSurgery([FromRoute] Guid id)
        {
            if (CurrentUserId == null) return Unauthorized();
            await profileService.DeletePastSurgeryAsync(CurrentUserId, id);
            return NoContent();
        }
    }
}
