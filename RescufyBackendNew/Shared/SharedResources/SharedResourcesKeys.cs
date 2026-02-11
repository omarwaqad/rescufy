using System.Threading.Channels;

namespace Shared.SharedResources
{
    public static class SharedResourcesKeys
    {
      
        public const string InvalidPagination = "InvalidPagination";
        public const string UserNotFound = "UserNotFound";
        public const string AnErrorOccured="AnErrorOccured";
        public const string InvalidEmail = "InvalidEmail";
        public const string SizeLimitExceeded = "SizeLimitExceeded";
        public const string Unauthorized = "Unauthorized";
        public const string LoginSuccessful = "LoginSuccessful";
        public const string InvalidCredentials = "InvalidCredentials";
        public const string CredentialsAreRequired = "CredentialsAreRequired";
        public const string OldPassIsIncorrect = "OldPassIsIncorrect";
        public const string PasswordChangedSuccessfully = "PasswordChangedSuccessfully";
        public const string OtpEmailSubject = "OtpEmailSubject";
        public const string InvalidOrExpiredOtp = "InvalidOrExpiredOtp";
        public const string OtpSentSuccessfully = "OtpSentSuccessfully";
        public const string ResetEmailSentSuccessfully = "ResetEmailSentSuccessfully";
        public const string EmailAlreadyExists = "EmailAlreadyExists";
        public const string AccountVerifiedSuccessfully = "AccountVerifiedSuccessfully";
        public const string CannotFollowYourself = "CannotFollowYourself";
        public const string AlreadyFollowingUser = "AlreadyFollowingUser";
        public const string UserNotAFollower = "UserNotAFollower";
        public const string FollowAdded = "FollowAdded";
        public const string CannotAddYourself = "CannotAddYourself";
        public const string AlreadyFriends = "AlreadyFriends";
        public const string CannotRemoveYourself = "CannotRemoveYourself";
        public const string FriendshipNotFound = "FriendshipNotFound";
        public const string FollowRemoved = "FollowRemoved";
        public const string CategoryNameAlreadyExist = "CategoryNameAlreadyExist";
        public const string CategoryNotFound = "CategoryNotFound";
        public const string CannotDeleteCategoryContainsPlaylists = "CannotDeleteCategoryContainsPlaylists";
        public const string InvalidVideoPlatform = "InvalidVideoPlatform";
        public const string PlaylistNotFound = "PlaylistNotFound";
        public const string PlaylistAcceptedMessage = "PlaylistAcceptedMessage";
        public const string PlaylistRejectedMessage = "PlaylistRejectedMessage";
        public const string PlaylistAlreadyAccepted = "PlaylistAlreadyAccepted";
        public const string PlaylistAlreadyRejected = "PlaylistAlreadyRejected";
        public const string RecievedFriendRequest = "RecievedFriendRequest";
        public const string FriendshipRequestNotFound = "FriendshipRequestNotFound";
        public const string FriendRequestAccepted = "FriendRequestAccepted";
        public const string UserNameAlreadyExist = "UserNameAlreadyExist";
        public const string InvalidLengthForUserName = "InvalidLengthForUserName";
        public const string InvalidCharsForUserName = "InvalidCharsForUserName";
        public const string ReservedUserName = "ReservedUserName";
        public const string UserNameIsNumber = "UserNameIsNumber";
        public const string VideoAlreadyExist = "VideoAlreadyExist";
        public const string VideoNotExist = "VideoNotExist";
        public const string LikedYourPost = "LikedYourPost";
        public const string VideoAlreadyAccepted = "VideoAlreadyAccepted";
        public const string VideoAcceptedMeesage = "VideoAcceptedMeesage";
        public const string VideoRejectedMeesage = "VideoRejectedMeesage";
        public const string UnauthorizedAction = "UnauthorizedAction";
        public const string CannotLikeYourOwnVideo = "CannotLikeYourOwnVideo";
        public const string AlreadyFriendRequestSent= "AlreadyFriendRequestSent";
        public const string CannotMentionYourself = "CannotMentionYourself";
        public const string NotFriends = "NotFriends";
        public const string YouWereMentionedInVideo = "YouWereMentionedInVideo";
        public const string FollowedUserNewPlaylistMessage = "FollowedUserNewPlaylistMessage";
        public const string FollowedUserNewVideoMessage = "FollowedUserNewVideoMessage";
        public const string VideoReportReason_InappropriateContent = "VideoReportReason_InappropriateContent";
        public const string VideoReportReason_PromotionalOrSpam = "VideoReportReason_PromotionalOrSpam";
        public const string VideoReportReason_MisleadingInformation = "VideoReportReason_MisleadingInformation";
        public const string VideoReportReason_ViolentContent = "VideoReportReason_ViolentContent";
        public const string VideoReportReason_DeletedVideo = "VideoReportReason_DeletedVideo";
        public const string VideoReportReason_Other = "VideoReportReason_Other";
        public const string VideoReportedMessage = "VideoReportedMessage";
        public const string VideoAlreadyReported = "VideoAlreadyReported";
    }
}
