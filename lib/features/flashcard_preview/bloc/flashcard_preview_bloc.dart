import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreviewBloc
    extends Bloc<FlashcardPreviewEvent, FlashcardPreviewState> {
  late final FlashcardsBloc _flashcardsBloc;
  late final CoursesBloc _coursesBloc;
  late final GroupsBloc _groupsBloc;

  FlashcardPreviewBloc({
    required FlashcardsBloc flashcardsBloc,
    required CoursesBloc coursesBloc,
    required GroupsBloc groupsBloc,
  }) : super(const FlashcardPreviewState()) {
    _flashcardsBloc = flashcardsBloc;
    _coursesBloc = coursesBloc;
    _groupsBloc = groupsBloc;
    on<FlashcardPreviewEventInitialize>(_initialize);
  }

  void _initialize(
    FlashcardPreviewEventInitialize event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    final Flashcard? flashcard =
        _flashcardsBloc.state.getFlashcardById(event.flashcardId);
    if (flashcard != null) {
      final Group? group = _groupsBloc.state.getGroupById(flashcard.groupId);
      if (group != null) {
        final String? courseName = _coursesBloc.state.getCourseNameById(
          group.courseId,
        );
        if (courseName != null) {
          emit(state.copyWith(
            flashcard: flashcard,
            group: group,
            courseName: courseName,
          ));
        }
      }
    }
  }
}
