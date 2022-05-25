import 'dart:async';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_status.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreviewBloc
    extends Bloc<FlashcardPreviewEvent, FlashcardPreviewState> {
  late final FlashcardsBloc _flashcardsBloc;
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;
  late final FlashcardPreviewDialogs _flashcardPreviewDialogs;
  StreamSubscription? _flashcardsStateSubscription;

  FlashcardPreviewBloc({
    required FlashcardsBloc flashcardsBloc,
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
    required FlashcardPreviewDialogs flashcardPreviewDialogs,
  }) : super(const FlashcardPreviewState()) {
    _flashcardsBloc = flashcardsBloc;
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    _flashcardPreviewDialogs = flashcardPreviewDialogs;
    on<FlashcardPreviewEventInitialize>(_initialize);
    on<FlashcardPreviewEventQuestionChanged>(_questionChanged);
    on<FlashcardPreviewEventAnswerChanged>(_answerChanged);
    on<FlashcardPreviewEventResetChanges>(_resetChanges);
    on<FlashcardPreviewEventSaveChanges>(_saveChanges);
    on<FlashcardPreviewEventRemoveFlashcard>(_removeFlashcard);
    on<FlashcardPreviewEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
  }

  void _initialize(
    FlashcardPreviewEventInitialize event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    final Flashcard? flashcard = _flashcardsBloc.state.getFlashcardFromGroup(
      event.params.groupId,
      event.params.flashcardIndex,
    );
    if (flashcard != null) {
      final Group? group = _groupsBloc.state.getGroupById(event.params.groupId);
      if (group != null) {
        final String? courseName = _coursesBloc.state.getCourseNameById(
          group.courseId,
        );
        if (courseName != null) {
          emit(state.copyWith(
            flashcard: flashcard,
            group: group,
            courseName: courseName,
            status: FlashcardPreviewStatusLoaded(),
          ));
        }
      }
    }
    _setFlashcardsStateListener();
  }

  void _questionChanged(
    FlashcardPreviewEventQuestionChanged event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      newQuestion: event.question,
      status: FlashcardPreviewStatusQuestionChanged(),
    ));
  }

  void _answerChanged(
    FlashcardPreviewEventAnswerChanged event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      newAnswer: event.answer,
      status: FlashcardPreviewStatusAnswerChanged(),
    ));
  }

  void _resetChanges(
    FlashcardPreviewEventResetChanges event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    emit(state.copyWith(
      newQuestion: state.flashcard?.question,
      newAnswer: state.flashcard?.answer,
      status: FlashcardPreviewStatusReset(),
    ));
  }

  Future<void> _saveChanges(
    FlashcardPreviewEventSaveChanges event,
    Emitter<FlashcardPreviewState> emit,
  ) async {
    if (state.newAnswer == '' || state.newQuestion == '') {
      _flashcardPreviewDialogs.showEmptyFlashcardInfo();
    } else {
      final bool confirmation =
          await _flashcardPreviewDialogs.askForSaveConfirmation();
      final Flashcard? flashcard = state.flashcard;
      final String? groupId = state.group?.id;
      if (confirmation && flashcard != null && groupId != null) {
        _flashcardsBloc.add(FlashcardsEventUpdateFlashcard(
          groupId: groupId,
          flashcard: flashcard.copyWith(
            question: state.newQuestion,
            answer: state.newAnswer,
          ),
        ));
      }
    }
  }

  Future<void> _removeFlashcard(
    FlashcardPreviewEventRemoveFlashcard event,
    Emitter<FlashcardPreviewState> emit,
  ) async {
    final bool confirmation =
        await _flashcardPreviewDialogs.askForDeleteConfirmation();
    final String? groupId = state.group?.id;
    final Flashcard? flashcard = state.flashcard;
    if (confirmation && groupId != null && flashcard != null) {
      _flashcardsBloc.add(
        FlashcardsEventRemoveFlashcard(
          groupId: groupId,
          flashcard: flashcard,
        ),
      );
    }
  }

  void _flashcardsStateUpdated(
    FlashcardPreviewEventFlashcardsStateUpdated event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    final Flashcard? flashcard = _flashcardsBloc.state.getFlashcardFromGroup(
      state.group?.id,
      state.flashcard?.index,
    );
    if (flashcard != null) {
      emit(state.copyWith(flashcard: flashcard));
    }
  }

  void _setFlashcardsStateListener() {
    _flashcardsStateSubscription = _flashcardsBloc.stream.listen((_) {
      add(FlashcardPreviewEventFlashcardsStateUpdated());
    });
  }

  @override
  Future<void> close() {
    _flashcardsStateSubscription?.cancel();
    return super.close();
  }
}
