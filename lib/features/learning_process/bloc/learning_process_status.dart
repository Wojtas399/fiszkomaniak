part of 'learning_process_bloc.dart';

abstract class LearningProcessStatus extends Equatable {
  const LearningProcessStatus();

  @override
  List<Object> get props => [];
}

class LearningProcessStatusInitial extends LearningProcessStatus {
  const LearningProcessStatusInitial();
}

class LearningProcessStatusLoaded extends LearningProcessStatus {}

class LearningProcessStatusInProgress extends LearningProcessStatus {}

class LearningProcessStatusReset extends LearningProcessStatus {}
