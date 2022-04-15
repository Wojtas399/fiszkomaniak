import 'package:fiszkomaniak/features/flashcards_preview/bloc/flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/flashcards_preview/bloc/flashcards_preview_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlashcardsPreviewBloc
    extends Bloc<FlashcardsPreviewEvent, FlashcardsPreviewState> {
  FlashcardsPreviewBloc() : super(const FlashcardsPreviewState()) {
    on<FlashcardsPreviewEventInitialize>(_initialize);
  }

  void _initialize(
    FlashcardsPreviewEventInitialize event,
    Emitter<FlashcardsPreviewState> emit,
  ) {
    //TODO
  }
}
