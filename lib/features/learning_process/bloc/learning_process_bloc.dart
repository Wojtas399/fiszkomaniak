import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState> {
  LearningProcessBloc() : super(const LearningProcessState()) {
    on<LearningProcessEventInitialize>(_initialize);
  }

  void _initialize(
    LearningProcessEventInitialize event,
    Emitter<LearningProcessState> emit,
  ) {
    emit(state.copyWith(data: event.data));
  }
}
