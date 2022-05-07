import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/core/user/user_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_event.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_status.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState> {
  late final UserBloc _userBloc;
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final LearningProcessDialogs _dialogs;
  late final Navigation _navigation;

  LearningProcessBloc({
    required UserBloc userBloc,
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required LearningProcessDialogs learningProcessDialogs,
    required Navigation navigation,
  }) : super(const LearningProcessState()) {
    _userBloc = userBloc;
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _dialogs = learningProcessDialogs;
    _navigation = navigation;
    on<LearningProcessEventInitialize>(_initialize);
    on<LearningProcessEventRememberedFlashcard>(_rememberedFlashcard);
    on<LearningProcessEventForgottenFlashcard>(_forgottenFlashcard);
    on<LearningProcessEventReset>(_reset);
    on<LearningProcessEventTimeFinished>(_timeFinished);
    on<LearningProcessEventEndSession>(_endSession);
    on<LearningProcessEventExit>(_exit);
  }

  void _initialize(
    LearningProcessEventInitialize event,
    Emitter<LearningProcessState> emit,
  ) {
    final Group? group = _groupsBloc.state.getGroupById(event.data.groupId);
    final String? courseName = _coursesBloc.state.getCourseNameById(
      group?.courseId,
    );
    if (group != null && courseName != null) {
      final int amountOfFlashcardsInStack = group.flashcards
          .where(
            (flashcard) => state.doesFlashcardMatchToFlashcardsType(
              flashcard,
              event.data.flashcardsType,
            ),
          )
          .length;
      emit(state.copyWith(
        courseName: courseName,
        group: group,
        duration: event.data.duration,
        areQuestionsAndAnswersSwapped: event.data.areQuestionsAndAnswersSwapped,
        flashcardsType: event.data.flashcardsType,
        amountOfFlashcardsInStack: amountOfFlashcardsInStack,
        status: LearningProcessStatusLoaded(),
      ));
    }
  }

  void _rememberedFlashcard(
    LearningProcessEventRememberedFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<int> indexesOfRememberedFlashcards = [
      ...state.indexesOfRememberedFlashcards,
    ];
    if (!indexesOfRememberedFlashcards.contains(event.flashcardIndex)) {
      indexesOfRememberedFlashcards.add(event.flashcardIndex);
    }
    emit(state.copyWith(
      indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
      status: LearningProcessStatusInProgress(),
    ));
  }

  void _forgottenFlashcard(
    LearningProcessEventForgottenFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<int> indexesOfRememberedFlashcards = [
      ...state.indexesOfRememberedFlashcards,
    ];
    indexesOfRememberedFlashcards.removeWhere(
      (id) => id == event.flashcardIndex,
    );
    emit(state.copyWith(
      indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
      status: LearningProcessStatusInProgress(),
    ));
  }

  void _reset(
    LearningProcessEventReset event,
    Emitter<LearningProcessState> emit,
  ) {
    final FlashcardsType? flashcardsType = event.newFlashcardsType;
    int amountOfFlashcardsInStack = state.amountOfFlashcardsInStack;
    if (flashcardsType != null) {
      amountOfFlashcardsInStack = state.flashcards
          .where(
            (flashcard) => state.doesFlashcardMatchToFlashcardsType(
              flashcard,
              flashcardsType,
            ),
          )
          .length;
    }
    emit(state.copyWith(
      indexOfDisplayedFlashcard: 0,
      flashcardsType: flashcardsType,
      amountOfFlashcardsInStack: amountOfFlashcardsInStack,
      status: LearningProcessStatusReset(),
    ));
  }

  Future<void> _timeFinished(
    LearningProcessEventTimeFinished event,
    Emitter<LearningProcessState> emit,
  ) async {
    final bool decision = await _dialogs.askForContinuing();
    if (decision) {
      emit(state.copyWith(removedDuration: true));
    } else {
      await _saveFlashcards();
      _navigation.moveBack();
    }
  }

  Future<void> _endSession(
    LearningProcessEventEndSession event,
    Emitter<LearningProcessState> emit,
  ) async {
    await _saveFlashcards();
    _navigation.moveBack();
  }

  Future<void> _exit(
    LearningProcessEventExit event,
    Emitter<LearningProcessState> emit,
  ) async {
    final bool confirmation = await _dialogs.askForSaveConfirmation();
    if (confirmation) {
      await _saveFlashcards();
    }
    _navigation.moveBack();
  }

  Future<void> _saveFlashcards() async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      _userBloc.add(UserEventSaveNewRememberedFlashcards(
        groupId: groupId,
        rememberedFlashcardsIndexes: state.indexesOfRememberedFlashcards,
      ));
    }
  }

  int _getNewIndexOfDisplayedFlashcard() {
    if (state.indexOfDisplayedFlashcard + 1 < state.amountOfFlashcardsInStack) {
      return state.indexOfDisplayedFlashcard + 1;
    }
    return state.indexOfDisplayedFlashcard;
  }
}
