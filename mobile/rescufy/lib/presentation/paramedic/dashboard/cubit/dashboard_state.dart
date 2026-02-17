import 'package:rescufy/domain/entities/incoming_request.dart';

class DashboardState {
  final bool isOnline;
  final IncomingRequest? incomingRequest;

  const DashboardState({required this.isOnline, required this.incomingRequest});

  DashboardState copyWith({bool? isOnline, IncomingRequest? incomingRequest}) {
    return DashboardState(
      isOnline: isOnline ?? this.isOnline,
      incomingRequest: incomingRequest,
    );
  }

  factory DashboardState.initial() {
    return const DashboardState(isOnline: false, incomingRequest: null);
  }
}
