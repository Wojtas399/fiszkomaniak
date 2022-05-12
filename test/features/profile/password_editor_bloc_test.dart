import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/profile/components/password_editor/bloc/password_editor_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigation extends Mock implements Navigation {}

void main() {
  final Navigation navigation = MockNavigation();
  late PasswordEditorBloc bloc;

  setUp(() {
    bloc = PasswordEditorBloc(navigation: navigation);
  });

  tearDown(() {
    reset(navigation);
  });

  blocTest(
    'current password changed',
    build: () => bloc,
    act: (_) => bloc.add(
      PasswordEditorEventCurrentPasswordChanged(value: 'value'),
    ),
    expect: () => [
      const PasswordEditorState(currentPassword: 'value'),
    ],
  );

  blocTest(
    'new password changed',
    build: () => bloc,
    act: (_) => bloc.add(
      PasswordEditorEventNewPasswordChanged(value: 'value'),
    ),
    expect: () => [
      const PasswordEditorState(newPassword: 'value'),
    ],
  );

  blocTest(
    'new password confirmation changed',
    build: () => bloc,
    act: (_) => bloc.add(
      PasswordEditorEventNewPasswordConfirmationChanged(value: 'value'),
    ),
    expect: () => [
      const PasswordEditorState(newPasswordConfirmation: 'value'),
    ],
  );

  blocTest(
    'submit, current password is incorrect',
    build: () => bloc,
    act: (_) {
      bloc.add(PasswordEditorEventNewPasswordChanged(value: 'new password'));
      bloc.add(PasswordEditorEventNewPasswordConfirmationChanged(
        value: 'new password',
      ));
      bloc.add(PasswordEditorEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => navigation.moveBack(objectToReturn: any(named: 'objectToReturn')),
      );
    },
  );

  blocTest(
    'submit, new password is incorrect',
    build: () => bloc,
    act: (_) {
      bloc.add(PasswordEditorEventCurrentPasswordChanged(value: 'current'));
      bloc.add(PasswordEditorEventNewPasswordChanged(value: 'new'));
      bloc.add(PasswordEditorEventNewPasswordConfirmationChanged(
        value: 'new password',
      ));
      bloc.add(PasswordEditorEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => navigation.moveBack(objectToReturn: any(named: 'objectToReturn')),
      );
    },
  );

  blocTest(
    'submit, new password confirmation is incorrect',
    build: () => bloc,
    act: (_) {
      bloc.add(PasswordEditorEventCurrentPasswordChanged(value: 'current'));
      bloc.add(PasswordEditorEventNewPasswordChanged(value: 'new password'));
      bloc.add(PasswordEditorEventNewPasswordConfirmationChanged(
        value: 'new pass',
      ));
      bloc.add(PasswordEditorEventSubmit());
    },
    verify: (_) {
      verifyNever(
        () => navigation.moveBack(objectToReturn: any(named: 'objectToReturn')),
      );
    },
  );

  blocTest(
    'submit, all values are correct',
    build: () => bloc,
    act: (_) {
      bloc.add(PasswordEditorEventCurrentPasswordChanged(value: 'current'));
      bloc.add(PasswordEditorEventNewPasswordChanged(value: 'new password'));
      bloc.add(PasswordEditorEventNewPasswordConfirmationChanged(
        value: 'new password',
      ));
      bloc.add(PasswordEditorEventSubmit());
    },
    verify: (_) {
      verify(
        () => navigation.moveBack(
          objectToReturn: const PasswordEditorReturns(
            currentPassword: 'current',
            newPassword: 'new password',
          ),
        ),
      ).called(1);
    },
  );
}
