import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardPreviewBloc
    extends Bloc<FlashcardPreviewEvent, FlashcardPreviewState> {
  late final FlashcardsBloc _flashcardsBloc;

  FlashcardPreviewBloc({
    required FlashcardsBloc flashcardsBloc,
  }) : super(const FlashcardPreviewState()) {
    _flashcardsBloc = flashcardsBloc;
    on<FlashcardPreviewEventInitialize>(_initialize);
  }

  void _initialize(
    FlashcardPreviewEventInitialize event,
    Emitter<FlashcardPreviewState> emit,
  ) {
    final Flashcard? flashcard =
        _flashcardsBloc.state.getFlashcardById(event.flashcardId);
    if (flashcard != null) {
      emit(state.copyWith(flashcard: flashcard));
    }
  }
}
