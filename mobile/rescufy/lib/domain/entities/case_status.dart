enum CaseStatus { accepted, onTheWay, arrived, pickedUp, underExecuting, delivered }

extension CaseStatusX on CaseStatus {
  String get serverValue => switch (this) {
    CaseStatus.accepted => 'Accepted',
    CaseStatus.onTheWay => 'OnTheWay',
    CaseStatus.arrived => 'Arrived',
    CaseStatus.pickedUp => 'PickedUp',
    CaseStatus.underExecuting => 'UnderExecuting',
    CaseStatus.delivered => 'Delivered',
  };

  String get label => switch (this) {
    CaseStatus.accepted => 'Accepted',
    CaseStatus.onTheWay => 'On The Way',
    CaseStatus.arrived => 'Arrived',
    CaseStatus.pickedUp => 'Picked Up',
    CaseStatus.underExecuting => 'Under Executing',
    CaseStatus.delivered => 'Delivered',
  };

  String? get driverActionLabel => switch (this) {
    CaseStatus.accepted => 'Start Trip',
    CaseStatus.onTheWay => 'Arrived To Patient',
    CaseStatus.arrived => 'Patient Picked Up',
    CaseStatus.pickedUp => 'Heading To Hospital',
    CaseStatus.underExecuting => 'Delivered To Hospital',
    CaseStatus.delivered => null,
  };

  CaseStatus? get nextDriverStatus => switch (this) {
    CaseStatus.accepted => CaseStatus.onTheWay,
    CaseStatus.onTheWay => CaseStatus.arrived,
    CaseStatus.arrived => CaseStatus.pickedUp,
    CaseStatus.pickedUp => CaseStatus.underExecuting,
    CaseStatus.underExecuting => CaseStatus.delivered,
    CaseStatus.delivered => null,
  };
}

extension CaseStatusParsing on String {
  CaseStatus toCaseStatus() => switch (toLowerCase()) {
    'accepted' => CaseStatus.accepted,
    'ontheway' => CaseStatus.onTheWay,
    'arrived' => CaseStatus.arrived,
    'pickedup' => CaseStatus.pickedUp,
    'underexecuting' => CaseStatus.underExecuting,
    'delivered' => CaseStatus.delivered,
    _ => CaseStatus.accepted,
  };
}
