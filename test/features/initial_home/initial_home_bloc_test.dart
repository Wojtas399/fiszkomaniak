import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/auth/is_user_logged_use_case.dart';
import 'package:fiszkomaniak/features/initial_home/bloc/initial_home_bloc.dart';

class MockIsUserLoggedUseCase extends Mock implements IsUserLoggedUseCase {}

void main() {
  final isUserLoggedUseCase = MockIsUserLoggedUseCase();

  InitialHomeBloc createBloc() {
    return InitialHomeBloc(isUserLoggedUseCase: isUserLoggedUseCase);
  }

  InitialHomeState createState({
    InitialHomeMode mode = InitialHomeMode.login,
    bool isUserLogged = false,
  }) {
    return InitialHomeState(
      mode: mode,
      isUserLogged: isUserLogged,
    );
  }

  tearDown(() {
    reset(isUserLoggedUseCase);
  });

  blocTest(
    'initialize, should set user login status',
    build: () => createBloc(),
    setUp: () {
      when(
        () => isUserLoggedUseCase.execute(),
      ).thenAnswer((_) => Stream.value(true));
    },
    act: (InitialHomeBloc bloc) {
      bloc.add(InitialHomeEventInitialize());
    },
    expect: () => [
      createState(isUserLogged: true),
    ],
    verify: (_) {
      verify(
        () => isUserLoggedUseCase.execute(),
      ).called(1);
    },
  );

  blocTest(
    'change mode, should update mode in state',
    build: () => createBloc(),
    act: (InitialHomeBloc bloc) {
      bloc.add(
        InitialHomeEventChangeMode(mode: InitialHomeMode.register),
      );
    },
    expect: () => [
      createState(mode: InitialHomeMode.register),
    ],
  );
}
