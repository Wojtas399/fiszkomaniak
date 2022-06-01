import 'dart:async';
import 'package:equatable/equatable.dart';
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
  late final UserBloc _userBloc;
  late final FlashcardsBloc _flashcardsBloc;
  StreamSubscription<UserState>? _userStateListener;
  StreamSubscription<FlashcardsState>? _flashcardsStateListener;

  AchievementsBloc({
    required UserBloc userBloc,
    required FlashcardsBloc flashcardsBloc,
  }) : super(const AchievementsState()) {
    _userBloc = userBloc;
    _flashcardsBloc = flashcardsBloc;
    on<AchievementsEventInitialize>(_initialize);
    on<AchievementsEventUserStateUpdated>(_userStateUpdated);
    on<AchievementsEventFlashcardsStateUpdated>(_flashcardsStateUpdated);
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

  void _flashcardsStateUpdated(
    AchievementsEventFlashcardsStateUpdated event,
    Emitter<AchievementsState> emit,
  ) {
    emit(state.copyWith(
      allFlashcardsAmount: event.newAmountOfAllFlashcards,
    ));
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
          newAmountOfAllFlashcards: state.amountOfAllFlashcards,
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
}
