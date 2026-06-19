import 'package:equatable/equatable.dart';

class ParamedicFeedbackModel extends Equatable {
  const ParamedicFeedbackModel({
    required this.paramedicId,
    required this.requestId,
    required this.rate,
    this.comment,
  });

  final String paramedicId;
  final int requestId;
  final int rate;
  final String? comment;

  Map<String, dynamic> toJson() => {
    'paramedicId': paramedicId,
    'requestId': requestId,
    'rate': rate,
    'comment': comment ?? '',
  };

  @override
  List<Object?> get props => [paramedicId, requestId, rate, comment];
}
