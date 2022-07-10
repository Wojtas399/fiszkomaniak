import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/flashcard.dart';
import '../../flashcards_stack/bloc/flashcards_stack_models.dart';
import '../learning_process_data.dart';

part 'learning_process_event.dart';

part 'learning_process_state.dart';

part 'learning_process_status.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState> {
  late final CoursesInterface _coursesInterface;
  // late final SessionsBloc _sessionsBloc;
  late final AchievementsBloc _achievementsBloc;
  late final LearningProcessDialogs _dialogs;
  late final Navigation _navigation;

  LearningProcessBloc({
    required CoursesInterface coursesInterface,
    // required SessionsBloc sessionsBloc,
    required AchievementsBloc achievementsBloc,
    required LearningProcessDialogs learningProcessDialogs,
    required Navigation navigation,
  }) : super(const LearningProcessState()) {
    _coursesInterface = coursesInterface;
    // _sessionsBloc = sessionsBloc;
    _achievementsBloc = achievementsBloc;
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

  Future<void> _initialize(
    LearningProcessEventInitialize event,
    Emitter<LearningProcessState> emit,
  ) async {
    // final Group? group = _groupsBloc.state.getGroupById(event.data.groupId);
    // if (group != null) {
    //   final String courseName =
    //       await _coursesInterface.getCourseNameById(group.courseId).first;
    //   final int amountOfFlashcardsInStack =
    //       FlashcardsUtils.getAmountOfFlashcardsMatchingToFlashcardsType(
    //     group.flashcards,
    //     event.data.flashcardsType,
    //   );
    //   final List<int> indexesOfRememberedFlashcards =
    //       FlashcardsUtils.getIndexesOfRememberedFlashcards(group.flashcards);
    //   final List<int> indexesOfNotRememberedFlashcards =
    //       FlashcardsUtils.getIndexesOfNotRememberedFlashcards(group.flashcards);
    //   emit(state.copyWith(
    //     sessionId: event.data.sessionId,
    //     courseName: courseNam/e,
    //     group: group,
    //     duration: event.data.duration,
    //     areQuestionsAndAnswersSwapped: event.data.areQuestionsAndAnswersSwapped,
    //     indexesOfRememberedFlashcards: indexesOfRememberedFlashcards,
    //     indexesOfNotRememberedFlashcards: indexesOfNotRememberedFlashcards,
    //     flashcardsType: event.data.flashcardsType,
    //     amountOfFlashcardsInStack: amountOfFlashcardsInStack,
    //     status: LearningProcessStatusLoaded(),
    //   ));
    // }
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
      _addSessionToAchievements();
      _removeSession();
      _navigation.moveBack();
    }
  }

  Future<void> _endSession(
    LearningProcessEventEndSession event,
    Emitter<LearningProcessState> emit,
  ) async {
    _saveFlashcards();
    _addSessionToAchievements();
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
      // _flashcardsBloc.add(FlashcardsEventSaveRememberedFlashcards(
      //   groupId: groupId,
      //   flashcardsIndexes: state.indexesOfRememberedFlashcards,
      // ));
      _achievementsBloc.add(AchievementsEventAddRememberedFlashcards(
        groupId: groupId,
        rememberedFlashcardsIndexes: state.indexesOfRememberedFlashcards,
      ));
    }
  }

  void _addSessionToAchievements() {
    _achievementsBloc.add(
      AchievementsEventAddSession(sessionId: state.sessionId),
    );
  }

  void _removeSession() {
    final String? sessionId = state.sessionId;
    if (sessionId != null && sessionId.isNotEmpty) {
      // _sessionsBloc.add(SessionsEventRemoveSession(
      //   sessionId: sessionId,
      //   removeAfterLearningProcess: true,
      // ));
    }
  }

  int _getNewIndexOfDisplayedFlashcard() {
    if (state.indexOfDisplayedFlashcard + 1 < state.amountOfFlashcardsInStack) {
      return state.indexOfDisplayedFlashcard + 1;
    }
    return state.indexOfDisplayedFlashcard;
  }
}
