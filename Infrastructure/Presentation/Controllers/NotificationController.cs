using ServiceAbstraction;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace Presentation.Controllers
{
    [Authorize]
    public class NotificationController(INotificationService notificationService) : ApiController
    {
        /// <summary>
        /// Retrieves a paged list of notifications for the authenticated user.
        /// </summary>
        /// <param name="pageNumber">The page number (starts from 1)</param>
        /// <param name="pageSize">Number of items per page</param>
        /// <response code="200">Returns a paged list of notifications</response>
        [HttpGet]
        [ProducesResponseType(typeof(Shared.DTOs.General.PaginatedResultDto<Shared.DTOs.Notification.NotificationDto>), StatusCodes.Status200OK)]
        public async Task<IActionResult> GetNotifications(
            [FromQuery] int pageNumber = 1,
            [FromQuery] int pageSize = 20)
        {
            var userId = GetIdFromToken();
            var result = await notificationService.GetUserNotificationsPagedAsync(userId, pageNumber, pageSize);
            return Ok(result);
        }

        /// <summary>
        /// Retrieves the count of unread notifications for the authenticated user.
        /// </summary>
        /// <response code="200">Returns the unread count</response>
        [HttpGet("unread-count")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetUnreadCount()
        {
            var userId = GetIdFromToken();
            var count = await notificationService.GetUnreadCountAsync(userId);
            return Ok(new { count });
        }

        /// <summary>
        /// Marks a specific notification as read.
        /// </summary>
        /// <param name="id">The notification unique identifier</param>
        /// <response code="200">Successfully marked as read</response>
        [HttpPost("{id}/read")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> MarkAsRead([FromRoute] int id)
        {
            var userId = GetIdFromToken();
            await notificationService.MarkAsReadAsync(id, userId);
            return Ok();
        }

        /// <summary>
        /// Marks all notifications of the authenticated user as read.
        /// </summary>
        /// <response code="200">All notifications marked as read</response>
        [HttpPost("mark-all-read")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> MarkAllRead()
        {
            var userId = GetIdFromToken();
            await notificationService.MarkAllReadAsync(userId);
            return Ok();
        }

        /// <summary>
        /// Deletes a specific notification.
        /// </summary>
        /// <param name="id">The notification unique identifier</param>
        /// <response code="200">Notification deleted successfully</response>
        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            var userId = GetIdFromToken();
            await notificationService.DeleteNotificationAsync(id, userId);
            return Ok();
        }
    }
}