import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'active_case_state.dart';

class ActiveCaseCubit extends Cubit<ActiveCaseState> {
  ActiveCaseCubit() : super(ActiveCaseInitial());
}
