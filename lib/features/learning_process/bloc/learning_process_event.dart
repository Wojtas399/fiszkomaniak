import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';

abstract class LearningProcessEvent {}

class LearningProcessEventInitialize extends LearningProcessEvent {
  final LearningProcessData data;

  LearningProcessEventInitialize({required this.data});
}
