import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/flashcards_stack/flashcards_stack_model.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/entities/flashcard.dart';
import '../../../domain/use_cases/achievements/add_finished_session_use_case.dart';
import '../../../domain/use_cases/courses/get_course_use_case.dart';
import '../../../domain/use_cases/sessions/save_session_progress_use_case.dart';
import '../../../domain/use_cases/groups/get_group_use_case.dart';
import '../../../domain/use_cases/sessions/remove_session_use_case.dart';
import '../../../models/bloc_status.dart';
import '../learning_process_dialogs.dart';
import '../learning_process_utils.dart';
import '../learning_process_data.dart';

part 'learning_process_event.dart';

part 'learning_process_state.dart';

class LearningProcessBloc
    extends Bloc<LearningProcessEvent, LearningProcessState>
    with LearningProcessUtils {
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final SaveSessionProgressUseCase _saveSessionProgressUseCase;
  late final AddFinishedSessionUseCase _addFinishedSessionUseCase;
  late final RemoveSessionUseCase _removeSessionUseCase;
  late final LearningProcessDialogs _dialogs;

  LearningProcessBloc({
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    required SaveSessionProgressUseCase saveSessionProgressUseCase,
    required AddFinishedSessionUseCase addFinishedSessionUseCase,
    required RemoveSessionUseCase removeSessionUseCase,
    required LearningProcessDialogs learningProcessDialogs,
    BlocStatus status = const BlocStatusInitial(),
    String? sessionId,
    String courseName = '',
    Group? group,
    Duration? duration,
    bool areQuestionsAndAnswersSwapped = false,
    List<Flashcard> rememberedFlashcards = const [],
    List<Flashcard> notRememberedFlashcards = const [],
    int indexOfDisplayedFlashcard = 0,
    FlashcardsType? flashcardsType,
    int amountOfFlashcardsInStack = 0,
  }) : super(
          LearningProcessState(
            status: status,
            sessionId: sessionId,
            courseName: courseName,
            group: group,
            duration: duration,
            areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
            rememberedFlashcards: rememberedFlashcards,
            notRememberedFlashcards: notRememberedFlashcards,
            indexOfDisplayedFlashcard: indexOfDisplayedFlashcard,
            flashcardsType: flashcardsType,
            amountOfFlashcardsInStack: amountOfFlashcardsInStack,
          ),
        ) {
    _getGroupUseCase = getGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    _saveSessionProgressUseCase = saveSessionProgressUseCase;
    _addFinishedSessionUseCase = addFinishedSessionUseCase;
    _removeSessionUseCase = removeSessionUseCase;
    _dialogs = learningProcessDialogs;
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
    emit(state.copyWith(status: const BlocStatusLoading()));
    final Group group = await _getGroup(event.data.groupId);
    final String courseName = await _getCourseName(group.courseId);
    emit(state.copyWith(
      status: const BlocStatusComplete<LearningProcessInfoType>(
        info: LearningProcessInfoType.initialDataHasBeenLoaded,
      ),
      sessionId: event.data.sessionId,
      courseName: courseName,
      group: group,
      duration: event.data.duration,
      areQuestionsAndAnswersSwapped: event.data.areQuestionsAndAnswersSwapped,
      rememberedFlashcards: getRememberedFlashcards(group.flashcards),
      notRememberedFlashcards: getNotRememberedFlashcards(group.flashcards),
      flashcardsType: event.data.flashcardsType,
      amountOfFlashcardsInStack: getAmountOfFlashcardsMatchingToFlashcardsType(
        group.flashcards,
        event.data.flashcardsType,
      ),
    ));
  }

  void _rememberedFlashcard(
    LearningProcessEventRememberedFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<Flashcard> originalFlashcards = state.group?.flashcards ?? [];
    List<Flashcard> rememberedFlashcards = [...state.rememberedFlashcards];
    final List<Flashcard> notRememberedFlashcards = [
      ...state.notRememberedFlashcards,
    ];
    rememberedFlashcards.add(originalFlashcards[event.flashcardIndex]);
    rememberedFlashcards = rememberedFlashcards.toSet().toList();
    notRememberedFlashcards.removeWhere(
      (Flashcard flashcard) => flashcard.index == event.flashcardIndex,
    );
    emit(state.copyWith(
      rememberedFlashcards: rememberedFlashcards,
      notRememberedFlashcards: notRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
    ));
  }

  void _forgottenFlashcard(
    LearningProcessEventForgottenFlashcard event,
    Emitter<LearningProcessState> emit,
  ) {
    final List<Flashcard> originalFlashcards = state.group?.flashcards ?? [];
    final List<Flashcard> rememberedFlashcards = [
      ...state.rememberedFlashcards
    ];
    List<Flashcard> notRememberedFlashcards = [
      ...state.notRememberedFlashcards,
    ];
    notRememberedFlashcards.add(originalFlashcards[event.flashcardIndex]);
    notRememberedFlashcards = notRememberedFlashcards.toSet().toList();
    rememberedFlashcards.removeWhere(
      (Flashcard flashcard) => flashcard.index == event.flashcardIndex,
    );
    emit(state.copyWith(
      rememberedFlashcards: rememberedFlashcards,
      notRememberedFlashcards: notRememberedFlashcards,
      indexOfDisplayedFlashcard: _getNewIndexOfDisplayedFlashcard(),
    ));
  }

  void _reset(
    LearningProcessEventReset event,
    Emitter<LearningProcessState> emit,
  ) {
    final FlashcardsType flashcardsType = event.newFlashcardsType;
    int amountOfFlashcardsInStack = (state.group?.flashcards ?? [])
        .where(
          (flashcard) => state.doesFlashcardBelongToFlashcardsType(
            flashcard,
            flashcardsType,
          ),
        )
        .length;
    emit(state.copyWith(
      status: const BlocStatusComplete<LearningProcessInfoType>(
        info: LearningProcessInfoType.flashcardsStackHasBeenReset,
      ),
      indexOfDisplayedFlashcard: 0,
      flashcardsType: flashcardsType,
      amountOfFlashcardsInStack: amountOfFlashcardsInStack,
    ));
  }

  Future<void> _timeFinished(
    LearningProcessEventTimeFinished event,
    Emitter<LearningProcessState> emit,
  ) async {
    if (await _doesUserWantToContinue()) {
      emit(state.copyWith(removedDuration: true));
    } else {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _saveProgress();
      await _addSessionToAchievements();
      await _removeSession();
      emit(state.copyWith(
        status: const BlocStatusComplete<LearningProcessInfoType>(
          info: LearningProcessInfoType.sessionHasBeenFinished,
        ),
      ));
    }
  }

  Future<void> _endSession(
    LearningProcessEventEndSession event,
    Emitter<LearningProcessState> emit,
  ) async {
    emit(state.copyWith(status: const BlocStatusLoading()));
    await _saveProgress();
    await _addSessionToAchievements();
    await _removeSession();
    emit(state.copyWith(
      status: const BlocStatusComplete<LearningProcessInfoType>(
        info: LearningProcessInfoType.sessionHasBeenFinished,
      ),
    ));
  }

  Future<void> _exit(
    LearningProcessEventExit event,
    Emitter<LearningProcessState> emit,
  ) async {
    final bool saveConfirmation = await _dialogs.askForSaveConfirmation();
    if (saveConfirmation) {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _saveProgress();
      await _addSessionToAchievements();
    }
    emit(state.copyWith(
      status: const BlocStatusComplete<LearningProcessInfoType>(
        info: LearningProcessInfoType.sessionHasBeenAborted,
      ),
    ));
  }

  Future<Group> _getGroup(String groupId) async {
    return await _getGroupUseCase.execute(groupId: groupId).first;
  }

  Future<String> _getCourseName(String courseId) async {
    return await _getCourseUseCase
        .execute(courseId: courseId)
        .map((course) => course.name)
        .first;
  }

  int _getNewIndexOfDisplayedFlashcard() {
    if (state.indexOfDisplayedFlashcard + 1 < state.amountOfFlashcardsInStack) {
      return state.indexOfDisplayedFlashcard + 1;
    }
    return state.indexOfDisplayedFlashcard;
  }

  Future<bool> _doesUserWantToContinue() async {
    return await _dialogs.askForContinuing();
  }

  Future<void> _saveProgress() async {
    final String? groupId = state.group?.id;
    if (groupId != null) {
      await _saveSessionProgressUseCase.execute(
        groupId: groupId,
        rememberedFlashcards: state.rememberedFlashcards,
      );
    }
  }

  Future<void> _addSessionToAchievements() async {
    await _addFinishedSessionUseCase.execute(sessionId: state.sessionId);
  }

  Future<void> _removeSession() async {
    final String? sessionId = state.sessionId;
    if (sessionId != null && sessionId.isNotEmpty) {
      await _removeSessionUseCase.execute(sessionId: sessionId);
    }
  }
}
