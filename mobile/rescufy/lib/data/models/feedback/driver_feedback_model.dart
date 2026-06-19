import 'package:equatable/equatable.dart';

class DriverFeedbackModel extends Equatable {
  const DriverFeedbackModel({
    required this.driverId,
    required this.requestId,
    required this.rate,
    this.comment,
  });

  final String driverId;
  final int requestId;
  final int rate;
  final String? comment;

  Map<String, dynamic> toJson() => {
    'driverId': driverId,
    'requestId': requestId,
    'rate': rate,
    'comment': comment ?? '',
  };

  @override
  List<Object?> get props => [driverId, requestId, rate, comment];
}
