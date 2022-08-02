import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/remove_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flashcard_preview_event.dart';

part 'flashcard_preview_state.dart';

class FlashcardPreviewBloc
    extends Bloc<FlashcardPreviewEvent, FlashcardPreviewState> {
  late final GetGroupUseCase _getGroupUseCase;
  late final GetCourseUseCase _getCourseUseCase;
  late final UpdateFlashcardUseCase _updateFlashcardUseCase;
  late final RemoveFlashcardUseCase _removeFlashcardUseCase;
  late final FlashcardPreviewDialogs _flashcardPreviewDialogs;
  StreamSubscription<Group>? _groupListener;

  FlashcardPreviewBloc({
    required GetGroupUseCase getGroupUseCase,
    required GetCourseUseCase getCourseUseCase,
    required UpdateFlashcardUseCase updateFlashcardUseCase,
    required RemoveFlashcardUseCase removeFlashcardUseCase,
    required FlashcardPreviewDialogs flashcardPreviewDialogs,
    Flashcard? flashcard,
    Group? group,
    String courseName = '',
    String question = '',
    String answer = '',
  }) : super(
          FlashcardPreviewState(
            status: const BlocStatusInitial(),
            flashcard: flashcard,
            group: group,
            courseName: courseName,
            question: question,
            answer: answer,
          ),
        ) {
    _getGroupUseCase = getGroupUseCase;
    _getCourseUseCase = getCourseUseCase;
    _updateFlashcardUseCase = updateFlashcardUseCase;
    _removeFlashcardUseCase = removeFlashcardUseCase;
    _flashcardPreviewDialogs = flashcardPreviewDialogs;
    on<FlashcardPreviewEventInitialize>(_initialize);
    on<FlashcardPreviewEventGroupUpdated>(_groupUpdated);
    on<FlashcardPreviewEventQuestionChanged>(_questionChanged);
    on<FlashcardPreviewEventAnswerChanged>(_answerChanged);
    on<FlashcardPreviewEventResetChanges>(_resetChanges);
    on<FlashcardPreviewEventSaveChanges>(_saveChanges);
    on<FlashcardPreviewEventRemoveFlashcard>(_removeFlashcard);
  }

  @override
  Future<void> close() {
    _groupListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    FlashcardPreviewEventInitialize event,
    Emitter<FlashcardPreviewState> emit,
  ) async {
    _setGroupListener(event.groupId);
    final Group group =
        await _getGroupUseCase.execute(groupId: event.groupId).first;
    final String courseName = await _getCourseUseCase
        .execute(courseId: group.courseId)
        .map((course) => course.name)
        .first;
    final Flashcard flashcard = group.flashcards[event.flashcardIndex];
    emit(state.copyWith(
      status: const BlocStatusComplete<FlashcardPreviewInfoType>(
        info: FlashcardPreviewInfoType.questionAndAnswerHaveBeenInitialized,
      ),
      flashcard: flashcard,
      group: group,
      courseName: courseName,
      question: flashcard.question,
      answer: flashcard.answer,
    ));
  }

  void _groupUpdated(
    FlashcardPreviewEventGroupUpdated event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    final int? flashcardIndex = state.flashcard?.index;
    if (flashcardIndex != null && !_hasFlashcardBeenRemoved()) {
      final Flashcard updatedFlashcard = event.group.flashcards[flashcardIndex];
      emit(state.copyWith(
        group: event.group,
        flashcard: updatedFlashcard,
        question: updatedFlashcard.question,
        answer: updatedFlashcard.answer,
      ));
    }
  }

  void _questionChanged(
    FlashcardPreviewEventQuestionChanged event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      question: event.question,
    ));
  }

  void _answerChanged(
    FlashcardPreviewEventAnswerChanged event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      answer: event.answer,
    ));
  }

  void _resetChanges(
    FlashcardPreviewEventResetChanges event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      status: const BlocStatusComplete<FlashcardPreviewInfoType>(
        info: FlashcardPreviewInfoType.questionAndAnswerHaveBeenReset,
      ),
      question: state.flashcard?.question,
      answer: state.flashcard?.answer,
    ));
  }

  Future<void> _saveChanges(
    FlashcardPreviewEventSaveChanges event,
    Emitter<FlashcardPreviewState> emit,
  ) async {
    if (_isFlashcardIncomplete()) {
      emit(state.copyWith(
        status: const BlocStatusComplete<FlashcardPreviewInfoType>(
          info: FlashcardPreviewInfoType.flashcardIsIncomplete,
        ),
      ));
    } else {
      final String? groupId = state.group?.id;
      final Flashcard? flashcard = state.flashcard;
      if (groupId != null &&
          flashcard != null &&
          await _hasSaveOperationBeenConfirmed()) {
        emit(state.copyWith(status: const BlocStatusLoading()));
        await _updateFlashcardUseCase.execute(
          groupId: groupId,
          flashcard: flashcard.copyWith(
            question: state.question,
            answer: state.answer,
          ),
        );
        emit(state.copyWith(
          status: const BlocStatusComplete<FlashcardPreviewInfoType>(
            info: FlashcardPreviewInfoType.flashcardHasBeenUpdated,
          ),
        ));
      }
    }
  }

  Future<void> _removeFlashcard(
    FlashcardPreviewEventRemoveFlashcard event,
    Emitter<FlashcardPreviewState> emit,
  ) async {
    final String? groupId = state.group?.id;
    final int? flashcardIndex = state.flashcard?.index;
    if (groupId != null &&
        flashcardIndex != null &&
        await _hasFlashcardRemovalBeenConfirmed()) {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _removeFlashcardUseCase.execute(
        groupId: groupId,
        flashcardIndex: flashcardIndex,
      );
      emit(state.copyWith(
        status: const BlocStatusComplete<FlashcardPreviewInfoType>(
          info: FlashcardPreviewInfoType.flashcardHasBeenRemoved,
        ),
      ));
    }
  }

  void _setGroupListener(String groupId) {
    _groupListener = _getGroupUseCase.execute(groupId: groupId).listen(
          (group) => add(
            FlashcardPreviewEventGroupUpdated(group: group),
          ),
        );
  }

  bool _isFlashcardIncomplete() {
    return state.question.isEmpty || state.answer.isEmpty;
  }

  Future<bool> _hasSaveOperationBeenConfirmed() async {
    return await _flashcardPreviewDialogs.askForSaveConfirmation();
  }

  Future<bool> _hasFlashcardRemovalBeenConfirmed() async {
    return await _flashcardPreviewDialogs.askForDeleteConfirmation();
  }

  bool _hasFlashcardBeenRemoved() {
    final BlocStatus status = state.status;
    return status is BlocStatusComplete &&
        status.info == FlashcardPreviewInfoType.flashcardHasBeenRemoved;
  }
}
