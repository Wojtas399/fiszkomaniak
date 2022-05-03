import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import '../../../models/session_model.dart';

class LearningProcessState extends Equatable {
  final LearningProcessData? data;
  final List<Flashcard> flashcards;
  final List<int> indexesOfRememberedFlashcards;
  final int indexOfDisplayedFlashcard;

  int get amountOfAllFlashcards => flashcards.length;

  int get amountOfRememberedFlashcards => indexesOfRememberedFlashcards.length;

  const LearningProcessState({
    this.data,
    this.flashcards = const [],
    this.indexesOfRememberedFlashcards = const [],
    this.indexOfDisplayedFlashcard = 0,
  });

  LearningProcessState copyWith({
    LearningProcessData? data,
    List<Flashcard>? flashcards,
    List<int>? indexesOfRememberedFlashcards,
    int? indexOfDisplayedFlashcard,
  }) {
    return LearningProcessState(
      data: data ?? this.data,
      flashcards: flashcards ?? this.flashcards,
      indexesOfRememberedFlashcards:
          indexesOfRememberedFlashcards ?? this.indexesOfRememberedFlashcards,
      indexOfDisplayedFlashcard:
          indexOfDisplayedFlashcard ?? this.indexOfDisplayedFlashcard,
    );
  }

  @override
  List<Object> get props => [
        data ?? '',
        flashcards,
        indexesOfRememberedFlashcards,
        indexOfDisplayedFlashcard,
      ];
}

class LearningProcessData extends Equatable {
  final String? sessionId;
  final String groupId;
  final TimeOfDay? duration;
  final FlashcardsType flashcardsType;
  final bool areQuestionsAndAnswersSwapped;

  const LearningProcessData({
    required this.groupId,
    required this.flashcardsType,
    required this.areQuestionsAndAnswersSwapped,
    this.sessionId,
    this.duration,
  });

  @override
  List<Object> get props => [
        groupId,
        flashcardsType,
        areQuestionsAndAnswersSwapped,
        sessionId ?? '',
        duration ?? '',
      ];
}
