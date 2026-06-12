class SignalREvents {
  SignalREvents._();

  static const String receiveNotification = 'ReceiveNotification';
  static const String requestCreated = 'RequestCreated';
  static const String statusChanged = 'StatusChanged';
  static const String ambulanceReassigned = 'AmbulanceReassigned';
  static const String requestCancelled = 'RequestCancelled';
  static const String reportAdded = 'ReportAdded';
  static const String newRequest = 'NewRequest';
  static const String requestUpdated = 'RequestUpdated';
  static const String receiveEmergencyRequest = 'ReceiveEmergencyRequest';
  static const String receiveLocationUpdate = 'ReceiveLocationUpdate';
}

class SignalRMethods {
  SignalRMethods._();

  static const String joinRequestGroup = 'JoinRequestGroup';
  static const String leaveRequestGroup = 'LeaveRequestGroup';
  static const String updateLocation = 'UpdateLocation';
  static const String acceptRequest = 'AcceptRequest';
}
