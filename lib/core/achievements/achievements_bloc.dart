import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/date_model.dart';
import '../../utils/date_utils.dart';
import '../flashcards/flashcards_bloc.dart';
import '../user/user_bloc.dart';

part 'achievements_event.dart';

part 'achievements_state.dart';

part 'achievements_status.dart';

class AchievementsBloc extends Bloc<AchievementsEvent, AchievementsState> {
  late final AchievementsInterface _achievementsInterface;
  late final UserBloc _userBloc;
  late final FlashcardsBloc _flashcardsBloc;
  StreamSubscription<UserState>? _userStateListener;
  StreamSubscription<FlashcardsState>? _flashcardsStateListener;

  AchievementsBloc({
    required AchievementsInterface achievementsInterface,
    required UserBloc userBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const AchievementsState()) {
    _achievementsInterface = achievementsInterface;
    _userBloc = userBloc;
    _flashcardsBloc = flashcardsBloc;
    on<AchievementsEventInitialize>(_initialize);
    on<AchievementsEventUserStateUpdated>(_userStateUpdated);
    on<AchievementsEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
    on<AchievementsEventNewConditionAchieved>(_newConditionAchieved);
    on<AchievementsEventAddNewFlashcards>(_addNewFlashcards);
    on<AchievementsEventAddRememberedFlashcards>(_addRememberedFlashcards);
    on<AchievementsEventAddSession>(_addSession);
  }

  @override
  Future<void> close() {
    _userStateListener?.cancel();
    _flashcardsStateListener?.cancel();
    return super.close();
  }

  void _initialize(
    AchievementsEventInitialize event,
    Emitter<AchievementsState> emit,
  ) {
    emit(state.copyWith(
      daysStreak: _getDaysStreak(_userBloc.state.loggedUser),
      allFlashcardsAmount: _flashcardsBloc.state.amountOfAllFlashcards,
    ));
    _setUserStateListener();
    _setFlashcardsStateListener();
  }

  void _userStateUpdated(
    AchievementsEventUserStateUpdated event,
    Emitter<AchievementsState> emit,
  ) {
    final int newDaysStreak = _getDaysStreak(event.updatedLoggedUser);
    AchievementsStatus? newStatus;
    if (newDaysStreak > 1 && newDaysStreak == state.daysStreak + 1) {
      newStatus = AchievementsStatusDaysStreakUpdated(
        newDaysStreak: newDaysStreak,
      );
    }
    emit(state.copyWith(
      status: newStatus,
      daysStreak: newDaysStreak,
    ));
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

  void _setUserStateListener() {
    _userStateListener ??= _userBloc.stream.listen(
      (state) => add(
        AchievementsEventUserStateUpdated(updatedLoggedUser: state.loggedUser),
      ),
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

  int _getDaysStreak(User? loggedUser) {
    int daysStreak = 0;
    final List<Date>? dates = loggedUser?.days.map((day) => day.date).toList();
    if (dates != null) {
      daysStreak = DateUtils.getDaysInARow(Date.now(), dates).length;
      if (daysStreak == 0) {
        daysStreak = DateUtils.getDaysInARow(
          Date.now().subtractDays(1),
          dates,
        ).length;
      }
    }
    return daysStreak;
  }

  List<String> _createFlashcardsIds(
    final String groupId,
    final List<int> flashcardsIndexes,
  ) {
    return flashcardsIndexes.map((index) => '$groupId$index').toList();
  }
}
