class IncomingRequest {
  final String id;
  final String condition;
  final String severity;
  final double distanceKm;

  const IncomingRequest({
    required this.id,
    required this.condition,
    required this.severity,
    required this.distanceKm,
  });
}
