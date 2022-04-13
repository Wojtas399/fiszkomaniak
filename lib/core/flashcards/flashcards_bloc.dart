import 'dart:async';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/changed_document.dart';

class FlashcardsBloc extends Bloc<FlashcardsEvent, FlashcardsState> {
  late final FlashcardsInterface _flashcardsInterface;
  StreamSubscription<List<ChangedDocument<Flashcard>>>? _flashcardsSubscription;

  FlashcardsBloc({
    required FlashcardsInterface flashcardsInterface,
  }) : super(const FlashcardsState()) {
    _flashcardsInterface = flashcardsInterface;
    on<FlashcardsEventInitialize>(_initialize);
    on<FlashcardsEventFlashcardAdded>(_flashcardAdded);
    on<FlashcardsEventFlashcardUpdated>(_flashcardUpdated);
    on<FlashcardsEventFlashcardRemoved>(_flashcardRemoved);
    on<FlashcardsEventSave>(_save);
  }

  void _initialize(
    FlashcardsEventInitialize event,
    Emitter<FlashcardsState> emit,
  ) {
    _flashcardsSubscription =
        _flashcardsInterface.getFlashcardsSnapshots().listen((flashcards) {
      for (final flashcard in flashcards) {
        switch (flashcard.changeType) {
          case DbDocChangeType.added:
            add(FlashcardsEventFlashcardAdded(flashcard: flashcard.doc));
            break;
          case DbDocChangeType.updated:
            add(FlashcardsEventFlashcardUpdated(flashcard: flashcard.doc));
            break;
          case DbDocChangeType.removed:
            add(FlashcardsEventFlashcardRemoved(flashcardId: flashcard.doc.id));
            break;
        }
      }
    });
  }

  void _flashcardAdded(
    FlashcardsEventFlashcardAdded event,
    Emitter<FlashcardsState> emit,
  ) {
    emit(state.copyWith(
      allFlashcards: [...state.allFlashcards, event.flashcard],
    ));
  }

  void _flashcardUpdated(
    FlashcardsEventFlashcardUpdated event,
    Emitter<FlashcardsState> emit,
  ) {
    final List<Flashcard> allFlashcards = [...state.allFlashcards];
    final int indexOfUpdatedFlashcard = allFlashcards.indexWhere(
      (flashcard) => flashcard.id == event.flashcard.id,
    );
    allFlashcards[indexOfUpdatedFlashcard] = event.flashcard;
    emit(state.copyWith(allFlashcards: allFlashcards));
  }

  void _flashcardRemoved(
    FlashcardsEventFlashcardRemoved event,
    Emitter<FlashcardsState> emit,
  ) {
    final List<Flashcard> allFlashcards = [...state.allFlashcards];
    allFlashcards.removeWhere((flashcard) => flashcard.id == event.flashcardId);
    emit(state.copyWith(allFlashcards: allFlashcards));
  }

  Future<void> _save(
    FlashcardsEventSave event,
    Emitter<FlashcardsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FlashcardsStatusLoading()));
      if (event.flashcardsToUpdate.isNotEmpty) {
        await _flashcardsInterface.updateFlashcards(event.flashcardsToUpdate);
      }
      if (event.flashcardsToAdd.isNotEmpty) {
        await _flashcardsInterface.addFlashcards(event.flashcardsToAdd);
      }
      if (event.idsOfFlashcardsToRemove.isNotEmpty) {
        await _flashcardsInterface.removeFlashcards(
          event.idsOfFlashcardsToRemove,
        );
      }
      if (event.flashcardsToAdd.isNotEmpty &&
          event.flashcardsToUpdate.isEmpty &&
          event.idsOfFlashcardsToRemove.isEmpty) {
        emit(state.copyWith(status: FlashcardsStatusFlashcardsAdded()));
      } else {
        emit(state.copyWith(status: FlashcardsStatusFlashcardsSaved()));
      }
    } catch (error) {
      emit(state.copyWith(
        status: FlashcardsStatusError(message: error.toString()),
      ));
    }
  }

  @override
  Future<void> close() {
    _flashcardsSubscription?.cancel();
    return super.close();
  }
}
