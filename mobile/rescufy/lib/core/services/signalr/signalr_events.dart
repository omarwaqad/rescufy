import 'package:rescufy/core/constants/signalr_constants.dart';

class NotificationHubEvents {
  NotificationHubEvents._();

  static const String receiveNotification = SignalREvents.receiveNotification;
  static const String requestCreated = SignalREvents.requestCreated;
  static const String statusChanged = SignalREvents.statusChanged;
  static const String ambulanceReassigned = SignalREvents.ambulanceReassigned;
  static const String requestCancelled = SignalREvents.requestCancelled;
  static const String reportAdded = SignalREvents.reportAdded;
  static const String newRequest = SignalREvents.newRequest;
  static const String requestUpdated = SignalREvents.requestUpdated;
  static const String receiveEmergencyRequest =
      SignalREvents.receiveEmergencyRequest;

  static const List<String> all = [
    receiveNotification,
    requestCreated,
    statusChanged,
    ambulanceReassigned,
    requestCancelled,
    reportAdded,
    newRequest,
    requestUpdated,
    receiveEmergencyRequest,
  ];
}

class AmbulanceHubEvents {
  AmbulanceHubEvents._();

  static const String receiveLocationUpdate = SignalREvents.receiveLocationUpdate;
}

class AmbulanceHubMethods {
  AmbulanceHubMethods._();

  static const String joinRequestGroup = SignalRMethods.joinRequestGroup;
  static const String leaveRequestGroup = SignalRMethods.leaveRequestGroup;
  static const String updateLocation = SignalRMethods.updateLocation;
  static const String acceptRequest = SignalRMethods.acceptRequest;
}

class SignalRPayloadKeys {
  SignalRPayloadKeys._();

  static const String requestId = 'requestId';
  static const String caseId = 'caseId';
  static const String patientName = 'patientName';
  static const String patientAge = 'patientAge';
  static const String patientGender = 'patientGender';
  static const String emergencyType = 'emergencyType';
  static const String severity = 'severity';
  static const String description = 'description';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String address = 'address';
  static const String hospitalName = 'hospitalName';
  static const String createdAt = 'createdAt';
  static const String aiSummary = 'aiSummary';
  static const String allergies = 'allergies';
  static const String chronicDiseases = 'chronicDiseases';
  static const String currentMedications = 'currentMedications';
  static const String bloodType = 'bloodType';
  static const String status = 'status';
  static const String message = 'message';
  static const String title = 'title';
  static const String body = 'body';
  static const String updatedAt = 'updatedAt';
}
