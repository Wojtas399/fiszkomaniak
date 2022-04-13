import 'package:equatable/equatable.dart';

abstract class FlashcardsStatus extends Equatable {
  const FlashcardsStatus();

  @override
  List<Object> get props => [];
}

class FlashcardsStatusInitial extends FlashcardsStatus {
  const FlashcardsStatusInitial();
}

class FlashcardsStatusLoaded extends FlashcardsStatus {}

class FlashcardsStatusLoading extends FlashcardsStatus {}

class FlashcardsStatusFlashcardsAdded extends FlashcardsStatus {}

class FlashcardsStatusFlashcardsSaved extends FlashcardsStatus {}

class FlashcardsStatusError extends FlashcardsStatus {
  final String message;

  const FlashcardsStatusError({required this.message});

  @override
  List<Object> get props => [message];
}
