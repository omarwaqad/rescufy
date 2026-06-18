// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rescufy';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageAlerts => 'Manage alerts';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get manageYourData => 'Manage your data';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get faqContactUs => 'FAQ, contact us';

  @override
  String get medications => 'Medications';

  @override
  String get allergies => 'Allergies';

  @override
  String get chronicDiseases => 'Chronic Diseases';

  @override
  String get pastSurgeries => 'Past Surgeries';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get chooseYourPreferredLanguage => 'Choose your preferred language';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String helloUser(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get howCanWeHelp => 'How can we help you today?';

  @override
  String get emergencyServices => 'Emergency Services';

  @override
  String get requestAmbulance => 'Request Ambulance';

  @override
  String get forMyselfOrFamily => 'For myself or family member';

  @override
  String get reportEmergency => 'Report Emergency';

  @override
  String get witnessingEmergency => 'Witnessing an emergency situation';

  @override
  String get quickAccess => 'Quick Access';

  @override
  String get firstAid => 'First Aid';

  @override
  String get quickGuides => 'Quick guides';

  @override
  String get hospitals => 'Hospitals';

  @override
  String get findNearby => 'Find nearby';

  @override
  String get history => 'History';

  @override
  String get pastRequests => 'Past requests';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get stayPrepared => 'Stay prepared';

  @override
  String get emergencyHotline => 'Emergency Hotline';

  @override
  String get support24_7 => '24/7 Support • 123-456-7890';

  @override
  String get home => 'Home';

  @override
  String get accountLoginForm => 'Account Login Form';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get logIn => 'Log In';

  @override
  String get dontHaveAccount => 'Don\'t have an Account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get firstAidGuide => 'First Aid Guide';

  @override
  String get checkSceneSafety => 'Check the scene for safety';

  @override
  String get callEmergencyServices => 'Call emergency services';

  @override
  String get checkResponsiveness => 'Check responsiveness';

  @override
  String get performCPR => 'Perform CPR if needed';

  @override
  String get stopBleeding => 'Stop bleeding with pressure';

  @override
  String get keepPersonWarm => 'Keep the person warm';

  @override
  String get monitorUntilHelp => 'Monitor until help arrives';

  @override
  String get close => 'Close';

  @override
  String get nearbyHospitals => 'Nearby Hospitals';

  @override
  String get hospitalsSubtitle =>
      'Compare nearby emergency-ready hospitals and head out fast.';

  @override
  String get yourLocation => 'Your location';

  @override
  String get openNow => 'Open now';

  @override
  String get limited => 'Limited';

  @override
  String get unavailable => 'Unavailable';

  @override
  String availableBeds(int count) {
    return '$count beds available';
  }

  @override
  String icuAvailability(int count) {
    return '$count ICU available';
  }

  @override
  String startingFromPrice(String price) {
    return 'Starting from $price';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km away';
  }

  @override
  String get call => 'Call';

  @override
  String get directions => 'Directions';

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String get enableLocationToFindHospitals =>
      'Enable location services to load nearby hospitals.';

  @override
  String get noHospitalsNearby => 'No nearby hospitals found';

  @override
  String get noHospitalsNearbyMessage =>
      'Try expanding the search radius or refresh your location.';

  @override
  String get hospitalsLoadFailed => 'Unable to load nearby hospitals.';

  @override
  String get liveCapacity => 'Live capacity';

  @override
  String get mapPreviewUnavailable => 'Map preview unavailable';

  @override
  String get mapConfigurationRequired =>
      'Add your Google Maps API key to enable the live map preview.';

  @override
  String get hospitalStatusAvailable => 'Available';

  @override
  String get hospitalStatusUnavailable => 'Unavailable';

  @override
  String get hospitalStatusUnknown => 'Status unknown';

  @override
  String get requestHistoryTitle => 'Request History';

  @override
  String get requestHistoryDetailsTitle => 'Request Details';

  @override
  String get requestHistoryEmptyTitle => 'No Request History';

  @override
  String get requestHistoryEmptyMessage =>
      'Your emergency requests will appear here once you make your first request.';

  @override
  String get requestHistoryFirstRequest => 'Make Your First Request';

  @override
  String get requestHistoryLoadFailed => 'Unable to load request history.';

  @override
  String get requestHistoryCompleted => 'Completed';

  @override
  String get requestHistoryInProgress => 'In Progress';

  @override
  String get requestHistoryCancelled => 'Cancelled';

  @override
  String get requestId => 'Request ID';

  @override
  String get requestStatus => 'Request Status';

  @override
  String get createdDate => 'Created Date';

  @override
  String get assignedAmbulancePlate => 'Assigned Ambulance Plate';

  @override
  String get driverName => 'Driver Name';

  @override
  String get hospitalName => 'Hospital Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get addressLabel => 'Address';

  @override
  String get viewDetails => 'View Details';

  @override
  String get unknownRequestStatus => 'Unknown';

  @override
  String get requestStatusPending => 'Pending';

  @override
  String get requestStatusAssigned => 'Assigned';

  @override
  String get requestStatusAccepted => 'Accepted';

  @override
  String get requestStatusOnTheWay => 'On The Way';

  @override
  String get requestStatusArrived => 'Arrived';

  @override
  String get requestStatusPickedUp => 'Picked Up';

  @override
  String get requestStatusUnderExecuting => 'Under Executing';

  @override
  String get requestStatusDelivered => 'Delivered';

  @override
  String get requestStatusNotDelivered => 'Not Delivered';

  @override
  String get requestStatusCanceled => 'Canceled';

  @override
  String get requestStatusFinished => 'Finished';

  @override
  String get requestStatusClosed => 'Closed';

  @override
  String get markAllAsRead => 'Mark All Read';

  @override
  String get notificationsLoadFailed => 'Unable to load notifications.';

  @override
  String get notificationsEmptyTitle => 'No Notifications';

  @override
  String get notificationsEmptyMessage =>
      'You have no notifications at the moment.';

  @override
  String get unread => 'Unread';

  @override
  String get deleteNotification => 'Delete Notification';

  @override
  String get deleteNotificationConfirm =>
      'Are you sure you want to delete this notification?';

  @override
  String get delete => 'Delete';

  @override
  String get safetyTip1 => 'Stay calm and assess the situation';

  @override
  String get safetyTip2 => 'Call emergency services immediately';

  @override
  String get safetyTip3 => 'Provide clear location information';

  @override
  String get safetyTip4 => 'Follow dispatcher instructions';

  @override
  String get safetyTip5 => 'Keep emergency contacts accessible';

  @override
  String get safetyTip6 => 'Know your medical information';
}
