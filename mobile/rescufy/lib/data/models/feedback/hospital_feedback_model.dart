import 'package:equatable/equatable.dart';

class HospitalFeedbackModel extends Equatable {
  const HospitalFeedbackModel({
    required this.hospitalId,
    required this.requestId,
    required this.rate,
    this.comment,
  });

  final int hospitalId;
  final int requestId;
  final int rate;
  final String? comment;

  Map<String, dynamic> toJson() => {
    'hospitalId': hospitalId,
    'requestId': requestId,
    'rate': rate,
    'comment': comment ?? '',
  };

  @override
  List<Object?> get props => [hospitalId, requestId, rate, comment];
}
