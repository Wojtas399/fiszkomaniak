import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:fiszkomaniak/utils/flashcards_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/flashcard_model.dart';
import '../../flashcards_stack/bloc/flashcards_stack_models.dart';
import '../learning_process_data.dart';

part 'learning_process_event.dart';

part 'learning_process_state.dart';

part 'learning_process_status.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState> {
  late final UserBloc _userBloc;
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final SessionsBloc _sessionsBloc;
  late final LearningProcessDialogs _dialogs;
  late final Navigation _navigation;

  LearningProcessBloc({
    required UserBloc userBloc,
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required SessionsBloc sessionsBloc,
    required LearningProcessDialogs learningProcessDialogs,
    required Navigation navigation,
  }) : super(const LearningProcessState()) {
    _userBloc = userBloc;
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _sessionsBloc = sessionsBloc;
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
      final int amountOfFlashcardsInStack =
          FlashcardsUtils.getAmountOfFlashcardsMatchingToFlashcardsType(
        group.flashcards,
        event.data.flashcardsType,
      );
      final List<int> indexesOfRememberedFlashcards =
          FlashcardsUtils.getIndexesOfRememberedFlashcards(group.flashcards);
      final List<int> indexesOfNotRememberedFlashcards =
          FlashcardsUtils.getIndexesOfNotRememberedFlashcards(group.flashcards);
      emit(state.copyWith(
        sessionId: event.data.sessionId,
        courseName: courseName,
        group: group,
        duration: event.data.duration,
        areQuestionsAndAnswersSwapped: event.data.areQuestionsAndAnswersSwapped,
        indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
        indexesOfNotRememberedFlashcards: indexesOfNotRememberedFlashcards,
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
    final List<int> indexesOfNotRememberedFlashcards = [
      ...state.indexesOfNotRememberedFlashcards,
    ];
    if (!indexesOfRememberedFlashcards.contains(event.flashcardIndex)) {
      indexesOfRememberedFlashcards.add(event.flashcardIndex);
    }
    indexesOfNotRememberedFlashcards.removeWhere(
      (id) => id == event.flashcardIndex,
    );
    emit(state.copyWith(
      indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
      indexesOfNotRememberedFlashcards: indexesOfNotRememberedFlashcards,
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
    final List<int> indexesOfNotRememberedFlashcards = [
      ...state.indexesOfNotRememberedFlashcards,
    ];
    indexesOfRememberedFlashcards.removeWhere(
      (id) => id == event.flashcardIndex,
    );
    if (!indexesOfNotRememberedFlashcards.contains(event.flashcardIndex)) {
      indexesOfNotRememberedFlashcards.add(event.flashcardIndex);
    }
    emit(state.copyWith(
      indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
      indexesOfNotRememberedFlashcards: indexesOfNotRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
      status: LearningProcessStatusInProgress(),
    ));
  }

  void _reset(
    LearningProcessEventReset event,
    Emitter<LearningProcessState> emit,
  ) {
    final FlashcardsType flashcardsType = event.newFlashcardsType;
    int amountOfFlashcardsInStack = state.flashcards
        .where((flashcard) => state.doesFlashcardBelongToFlashcardsType(
              flashcard,
              flashcardsType,
            ))
        .length;
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
      _saveFlashcards();
      _removeSession();
      _navigation.moveBack();
    }
  }

  Future<void> _endSession(
    LearningProcessEventEndSession event,
    Emitter<LearningProcessState> emit,
  ) async {
    _saveFlashcards();
    _removeSession();
    _navigation.moveBack();
  }

  Future<void> _exit(
    LearningProcessEventExit event,
    Emitter<LearningProcessState> emit,
  ) async {
    final bool confirmation = await _dialogs.askForSaveConfirmation();
    if (confirmation) {
      _saveFlashcards();
    }
    _navigation.moveBack();
  }

  void _saveFlashcards() {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      _userBloc.add(UserEventSaveNewRememberedFlashcards(
        groupId: groupId,
        rememberedFlashcardsIndexes: state.indexesOfRememberedFlashcards,
      ));
    }
  }

  Future<void> _removeSession() async {
    final String? sessionId = state.sessionId;
    if (sessionId != null) {
      _sessionsBloc.add(SessionsEventRemoveSession(
        sessionId: sessionId,
        removeAfterLearningProcess: true,
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
