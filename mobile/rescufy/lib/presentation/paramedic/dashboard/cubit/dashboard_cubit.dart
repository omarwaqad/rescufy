import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void toggleAvailability() {
    emit(state.copyWith(isOnline: !state.isOnline));
  }

  void receiveIncomingRequest(IncomingRequest request) {
    emit(state.copyWith(incomingRequest: request));
  }

  void acceptRequest() {
    emit(state.copyWith(incomingRequest: null));
  }

  void rejectRequest() {
    emit(state.copyWith(incomingRequest: null));
  }
}
