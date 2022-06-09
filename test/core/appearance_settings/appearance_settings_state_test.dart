import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppearanceSettingsState state;

  setUp(() {
    state = const AppearanceSettingsState();
  });

  test('initial state', () {
    expect(state.initializationStatus, InitializationStatus.loading);
    expect(state.httpStatus, const HttpStatusInitial());
    expect(state.isDarkModeOn, false);
    expect(state.isDarkModeCompatibilityWithSystemOn, false);
    expect(state.isSessionTimerInvisibilityOn, false);
  });

  test('copy with initialization status', () {
    const InitializationStatus status = InitializationStatus.ready;

    final state2 = state.copyWith(initializationStatus: status);
    final state3 = state2.copyWith();

    expect(state2.initializationStatus, status);
    expect(state3.initializationStatus, status);
  });

  test('copy with is dark mode on', () {
    final state2 = state.copyWith(isDarkModeOn: true);
    final state3 = state2.copyWith();

    expect(state2.isDarkModeOn, true);
    expect(state3.isDarkModeOn, true);
  });

  test('copy with is dark mode compatibility with system on', () {
    final state2 = state.copyWith(isDarkModeCompatibilityWithSystemOn: true);
    final state3 = state2.copyWith();

    expect(state2.isDarkModeCompatibilityWithSystemOn, true);
    expect(state3.isDarkModeCompatibilityWithSystemOn, true);
  });

  test('copy with is session timer visibility on', () {
    final state2 = state.copyWith(isSessionTimerInvisibilityOn: true);
    final state3 = state2.copyWith();

    expect(state2.isSessionTimerInvisibilityOn, true);
    expect(state3.isSessionTimerInvisibilityOn, true);
  });

  test('copy with http status', () {
    const HttpStatus status = HttpStatusSuccess();

    final state2 = state.copyWith(httpStatus: status);
    final state3 = state2.copyWith();

    expect(state2.httpStatus, status);
    expect(state3.httpStatus, const HttpStatusInitial());
  });
}
