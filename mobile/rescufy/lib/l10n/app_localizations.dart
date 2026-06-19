import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Rescufy'**
  String get appName;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Notifications setting
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage alerts'**
  String get manageAlerts;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Privacy setting
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// Privacy subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your data'**
  String get manageYourData;

  /// Help setting
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help subtitle
  ///
  /// In en, this message translates to:
  /// **'FAQ, contact us'**
  String get faqContactUs;

  /// Medications section title
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// Allergies section title
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// Chronic diseases section title
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseases;

  /// Past surgeries section title
  ///
  /// In en, this message translates to:
  /// **'Past Surgeries'**
  String get pastSurgeries;

  /// Emergency contacts section title
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// Language selection screen title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language selection description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseYourPreferredLanguage;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// User greeting
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String helloUser(String name);

  /// Home screen subtitle
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelp;

  /// Emergency services section title
  ///
  /// In en, this message translates to:
  /// **'Emergency Services'**
  String get emergencyServices;

  /// Request ambulance button
  ///
  /// In en, this message translates to:
  /// **'Request Ambulance'**
  String get requestAmbulance;

  /// Request ambulance subtitle
  ///
  /// In en, this message translates to:
  /// **'For myself or family member'**
  String get forMyselfOrFamily;

  /// Report emergency button
  ///
  /// In en, this message translates to:
  /// **'Report Emergency'**
  String get reportEmergency;

  /// Report emergency subtitle
  ///
  /// In en, this message translates to:
  /// **'Witnessing an emergency situation'**
  String get witnessingEmergency;

  /// Quick access section title
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// First aid card title
  ///
  /// In en, this message translates to:
  /// **'First Aid'**
  String get firstAid;

  /// First aid subtitle
  ///
  /// In en, this message translates to:
  /// **'Quick guides'**
  String get quickGuides;

  /// Hospitals card title
  ///
  /// In en, this message translates to:
  /// **'Hospitals'**
  String get hospitals;

  /// Hospitals subtitle
  ///
  /// In en, this message translates to:
  /// **'Find nearby'**
  String get findNearby;

  /// History card title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// History subtitle
  ///
  /// In en, this message translates to:
  /// **'Past requests'**
  String get pastRequests;

  /// Safety tips card title
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// Safety tips subtitle
  ///
  /// In en, this message translates to:
  /// **'Stay prepared'**
  String get stayPrepared;

  /// Emergency hotline banner title
  ///
  /// In en, this message translates to:
  /// **'Emergency Hotline'**
  String get emergencyHotline;

  /// Emergency hotline subtitle
  ///
  /// In en, this message translates to:
  /// **'24/7 Support • 123-456-7890'**
  String get support24_7;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Login screen header
  ///
  /// In en, this message translates to:
  /// **'Account Login Form'**
  String get accountLoginForm;

  /// Login form title
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Login button
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Sign up prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an Account? '**
  String get dontHaveAccount;

  /// Create account link
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// First aid dialog title
  ///
  /// In en, this message translates to:
  /// **'First Aid Guide'**
  String get firstAidGuide;

  /// First aid step 1
  ///
  /// In en, this message translates to:
  /// **'Check the scene for safety'**
  String get checkSceneSafety;

  /// First aid step 2
  ///
  /// In en, this message translates to:
  /// **'Call emergency services'**
  String get callEmergencyServices;

  /// First aid step 3
  ///
  /// In en, this message translates to:
  /// **'Check responsiveness'**
  String get checkResponsiveness;

  /// First aid step 4
  ///
  /// In en, this message translates to:
  /// **'Perform CPR if needed'**
  String get performCPR;

  /// First aid step 5
  ///
  /// In en, this message translates to:
  /// **'Stop bleeding with pressure'**
  String get stopBleeding;

  /// First aid step 6
  ///
  /// In en, this message translates to:
  /// **'Keep the person warm'**
  String get keepPersonWarm;

  /// First aid step 7
  ///
  /// In en, this message translates to:
  /// **'Monitor until help arrives'**
  String get monitorUntilHelp;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Nearby hospitals dialog title
  ///
  /// In en, this message translates to:
  /// **'Nearby Hospitals'**
  String get nearbyHospitals;

  /// Hospitals screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Compare nearby emergency-ready hospitals and head out fast.'**
  String get hospitalsSubtitle;

  /// Current user location label
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// Available/open status label
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get openNow;

  /// Limited status label
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get limited;

  /// Unavailable status label
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Available beds count label
  ///
  /// In en, this message translates to:
  /// **'{count} beds available'**
  String availableBeds(int count);

  /// Available ICU count label
  ///
  /// In en, this message translates to:
  /// **'{count} ICU available'**
  String icuAvailability(int count);

  /// Hospital starting price label
  ///
  /// In en, this message translates to:
  /// **'Starting from {price}'**
  String startingFromPrice(String price);

  /// Distance in kilometers label
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String distanceKm(String distance);

  /// Call action
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// Directions action
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// Refresh action
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Location unavailable label
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// Hospitals location error message
  ///
  /// In en, this message translates to:
  /// **'Enable location services to load nearby hospitals.'**
  String get enableLocationToFindHospitals;

  /// Empty hospitals state title
  ///
  /// In en, this message translates to:
  /// **'No nearby hospitals found'**
  String get noHospitalsNearby;

  /// Empty hospitals state subtitle
  ///
  /// In en, this message translates to:
  /// **'Try expanding the search radius or refresh your location.'**
  String get noHospitalsNearbyMessage;

  /// Hospitals load failure fallback
  ///
  /// In en, this message translates to:
  /// **'Unable to load nearby hospitals.'**
  String get hospitalsLoadFailed;

  /// Capacity status label
  ///
  /// In en, this message translates to:
  /// **'Live capacity'**
  String get liveCapacity;

  /// Map unavailable message
  ///
  /// In en, this message translates to:
  /// **'Map preview unavailable'**
  String get mapPreviewUnavailable;

  /// Map configuration hint
  ///
  /// In en, this message translates to:
  /// **'Add your Google Maps API key to enable the live map preview.'**
  String get mapConfigurationRequired;

  /// Hospital available status label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get hospitalStatusAvailable;

  /// Hospital unavailable status label
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get hospitalStatusUnavailable;

  /// Hospital unknown status label
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get hospitalStatusUnknown;

  /// Request history screen title
  ///
  /// In en, this message translates to:
  /// **'Request History'**
  String get requestHistoryTitle;

  /// Request history details bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestHistoryDetailsTitle;

  /// Empty request history title
  ///
  /// In en, this message translates to:
  /// **'No Request History'**
  String get requestHistoryEmptyTitle;

  /// Empty request history subtitle
  ///
  /// In en, this message translates to:
  /// **'Your emergency requests will appear here once you make your first request.'**
  String get requestHistoryEmptyMessage;

  /// Empty request history action
  ///
  /// In en, this message translates to:
  /// **'Make Your First Request'**
  String get requestHistoryFirstRequest;

  /// Request history load failure fallback
  ///
  /// In en, this message translates to:
  /// **'Unable to load request history.'**
  String get requestHistoryLoadFailed;

  /// Completed requests stat label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get requestHistoryCompleted;

  /// In progress requests stat label
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get requestHistoryInProgress;

  /// Cancelled requests stat label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get requestHistoryCancelled;

  /// Request ID label
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// Request status label
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get requestStatus;

  /// Created date label
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// Assigned ambulance plate label
  ///
  /// In en, this message translates to:
  /// **'Assigned Ambulance Plate'**
  String get assignedAmbulancePlate;

  /// Driver name label
  ///
  /// In en, this message translates to:
  /// **'Driver Name'**
  String get driverName;

  /// Hospital name label
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// Description field label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// View details action
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Unknown request status fallback
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownRequestStatus;

  /// Pending request status label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get requestStatusPending;

  /// Assigned request status label
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get requestStatusAssigned;

  /// Accepted request status label
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get requestStatusAccepted;

  /// On the way request status label
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get requestStatusOnTheWay;

  /// Arrived request status label
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get requestStatusArrived;

  /// Picked up request status label
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get requestStatusPickedUp;

  /// Under executing request status label
  ///
  /// In en, this message translates to:
  /// **'Under Executing'**
  String get requestStatusUnderExecuting;

  /// Delivered request status label
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get requestStatusDelivered;

  /// Not delivered request status label
  ///
  /// In en, this message translates to:
  /// **'Not Delivered'**
  String get requestStatusNotDelivered;

  /// Canceled request status label
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get requestStatusCanceled;

  /// Finished request status label
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get requestStatusFinished;

  /// Closed request status label
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get requestStatusClosed;

  /// Mark all notifications as read action
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllAsRead;

  /// Notifications load failure fallback
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications.'**
  String get notificationsLoadFailed;

  /// Empty notifications state title
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get notificationsEmptyTitle;

  /// Empty notifications state subtitle
  ///
  /// In en, this message translates to:
  /// **'You have no notifications at the moment.'**
  String get notificationsEmptyMessage;

  /// Unread notification label
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// Delete notification dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get deleteNotification;

  /// Delete notification confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get deleteNotificationConfirm;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Safety tip 1
  ///
  /// In en, this message translates to:
  /// **'Stay calm and assess the situation'**
  String get safetyTip1;

  /// Safety tip 2
  ///
  /// In en, this message translates to:
  /// **'Call emergency services immediately'**
  String get safetyTip2;

  /// Safety tip 3
  ///
  /// In en, this message translates to:
  /// **'Provide clear location information'**
  String get safetyTip3;

  /// Safety tip 4
  ///
  /// In en, this message translates to:
  /// **'Follow dispatcher instructions'**
  String get safetyTip4;

  /// Safety tip 5
  ///
  /// In en, this message translates to:
  /// **'Keep emergency contacts accessible'**
  String get safetyTip5;

  /// Safety tip 6
  ///
  /// In en, this message translates to:
  /// **'Know your medical information'**
  String get safetyTip6;

  /// Active request screen title
  ///
  /// In en, this message translates to:
  /// **'Active Request'**
  String get activeRequestTitle;

  /// View active request button
  ///
  /// In en, this message translates to:
  /// **'View Active Request'**
  String get viewActiveRequest;

  /// ETA label
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get etaLabel;

  /// Minutes suffix
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Not available fallback
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Case progress timeline label
  ///
  /// In en, this message translates to:
  /// **'Case Progress'**
  String get caseProgressLabel;

  /// Status assigned label
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get statusAssigned;

  /// Status accepted label
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// Status on the way label
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get statusOnTheWay;

  /// Status arrived label
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get statusArrived;

  /// Status picked up label
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get statusPickedUp;

  /// Status heading to hospital label
  ///
  /// In en, this message translates to:
  /// **'Heading To Hospital'**
  String get statusHeadingToHospital;

  /// Status delivered label
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// Status cancelled label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// Actions section label
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsLabel;

  /// Rate driver button
  ///
  /// In en, this message translates to:
  /// **'Rate Driver'**
  String get rateDriver;

  /// Rate paramedic button
  ///
  /// In en, this message translates to:
  /// **'Rate Paramedic'**
  String get rateParamedic;

  /// Rate hospital button
  ///
  /// In en, this message translates to:
  /// **'Rate Hospital'**
  String get rateHospital;

  /// Select rating hint
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get selectRating;

  /// Submit feedback button
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get submitFeedback;

  /// Feedback comment hint
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get feedbackCommentHint;

  /// Feedback submitted success message
  ///
  /// In en, this message translates to:
  /// **'Feedback submitted successfully'**
  String get feedbackSubmittedSuccess;

  /// Driver feedback submitted label
  ///
  /// In en, this message translates to:
  /// **'✓ Driver Feedback Submitted'**
  String get driverFeedbackSubmitted;

  /// Paramedic feedback submitted label
  ///
  /// In en, this message translates to:
  /// **'✓ Paramedic Feedback Submitted'**
  String get paramedicFeedbackSubmitted;

  /// Hospital feedback submitted label
  ///
  /// In en, this message translates to:
  /// **'✓ Hospital Feedback Submitted'**
  String get hospitalFeedbackSubmitted;

  /// Feedback not available message
  ///
  /// In en, this message translates to:
  /// **'Feedback information is not available for this request.'**
  String get feedbackNotAvailable;

  /// Rate driver not available
  ///
  /// In en, this message translates to:
  /// **'Rate Driver (Not Available)'**
  String get rateDriverNotAvailable;

  /// Rate paramedic not available
  ///
  /// In en, this message translates to:
  /// **'Rate Paramedic (Not Available)'**
  String get rateParamedicNotAvailable;

  /// Rate hospital not available
  ///
  /// In en, this message translates to:
  /// **'Rate Hospital (Not Available)'**
  String get rateHospitalNotAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
