import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../flashcards/flashcards_bloc.dart';

part 'achievements_event.dart';

part 'achievements_state.dart';

part 'achievements_status.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  late final AchievementsInterface _achievementsInterface;
  late final FlashcardsBloc _flashcardsBloc;
  StreamSubscription<FlashcardsState>? _flashcardsStateListener;

  AchievementsBloc({
    required AchievementsInterface achievementsInterface,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const AchievementsState()) {
    _achievementsInterface = achievementsInterface;
    _flashcardsBloc = flashcardsBloc;
    on<AchievementsEventInitialize>(_initialize);
    on<AchievementsEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
    on<AchievementsEventNewConditionAchieved>(_newConditionAchieved);
    on<AchievementsEventAddNewFlashcards>(_addNewFlashcards);
    on<AchievementsEventAddRememberedFlashcards>(_addRememberedFlashcards);
    on<AchievementsEventAddSession>(_addSession);
  }

  @override
  Future<void> close() {
    _flashcardsStateListener?.cancel();
    return super.close();
  }

  void _initialize(
    AchievementsEventInitialize event,
    Emitter<AchievementsState> emit,
  ) {
    emit(state.copyWith(
      allFlashcardsAmount: _flashcardsBloc.state.amountOfAllFlashcards,
    ));
    _setFlashcardsStateListener();
  }

  Future<void> _flashcardsStateUpdated(
    AchievementsEventFlashcardsStateUpdated event,
    Emitter<AchievementsState> emit,
  ) async {
    emit(state.copyWith(
      allFlashcardsAmount: event.amountOfAllFlashcards,
    ));
  }

  void _newConditionAchieved(
    AchievementsEventNewConditionAchieved event,
    Emitter<AchievementsState> emit,
  ) {
    emit(state.copyWith(
      status: AchievementsStatusNewConditionCompleted(
        achievementType: event.achievementType,
        completedConditionValue: event.completedConditionValue,
      ),
    ));
  }

  Future<void> _addNewFlashcards(
    AchievementsEventAddNewFlashcards event,
    Emitter<AchievementsState> emit,
  ) async {
    await _achievementsInterface.addNewFlashcards(
      flashcardsIds: _createFlashcardsIds(
        event.groupId,
        event.flashcardsIndexes,
      ),
      onAchievedNextCondition: (int completedConditionValue) {
        add(AchievementsEventNewConditionAchieved(
          achievementType: AchievementType.amountOfAllFlashcards,
          completedConditionValue: completedConditionValue,
        ));
      },
    );
  }

  Future<void> _addRememberedFlashcards(
    AchievementsEventAddRememberedFlashcards event,
    Emitter<AchievementsState> emit,
  ) async {
    await _achievementsInterface.addNewRememberedFlashcards(
      flashcardsIds: _createFlashcardsIds(
        event.groupId,
        event.rememberedFlashcardsIndexes,
      ),
      onAchievedNextCondition: (int completedConditionValue) {
        add(AchievementsEventNewConditionAchieved(
          achievementType: AchievementType.amountOfRememberedFlashcards,
          completedConditionValue: completedConditionValue,
        ));
      },
    );
  }

  Future<void> _addSession(
    AchievementsEventAddSession event,
    Emitter<AchievementsState> emit,
  ) async {
    await _achievementsInterface.addNewFinishedSession(
      sessionId: event.sessionId,
      onAchievedNextCondition: (int completedConditionValue) {
        add(AchievementsEventNewConditionAchieved(
          achievementType: AchievementType.amountOfFinishedSessions,
          completedConditionValue: completedConditionValue,
        ));
      },
    );
  }

  void _setFlashcardsStateListener() {
    _flashcardsStateListener ??= _flashcardsBloc.stream.listen(
      (state) => add(
        AchievementsEventFlashcardsStateUpdated(
          amountOfAllFlashcards: state.amountOfAllFlashcards,
        ),
      ),
    );
  }

  List<String> _createFlashcardsIds(
    final String groupId,
    final List<int> flashcardsIndexes,
  ) {
    return flashcardsIndexes.map((index) => '$groupId$index').toList();
  }
}
