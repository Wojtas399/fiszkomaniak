import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fiszkomaniak/repositories/auth_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

void main() {
  final FireAuthService fireAuthService = MockFireAuthService();
  final auth = MockFirebaseAuth();
  late AuthRepository fireAuthRepository;

  setUp(() {
    fireAuthRepository = AuthRepository(fireAuthService: fireAuthService);
  });

  tearDown(() {
    reset(fireAuthService);
  });

  test('get user changes stream', () {
    when(() => fireAuthService.getUserChangesStream())
        .thenAnswer((_) => auth.userChanges());

    Stream<User?> userChangesStream = fireAuthRepository.getUserChangesStream();

    expect(userChangesStream, auth.userChanges());
  });

  test('sign in', () async {
    const SignInModel data = SignInModel(
      email: 'email@example.com',
      password: 'password123',
    );
    when(
      () => fireAuthService.signIn(email: data.email, password: data.password),
    ).thenAnswer((_) async => '');

    await fireAuthRepository.signIn(data);

    verify(
      () => fireAuthService.signIn(email: data.email, password: data.password),
    ).called(1);
  });

  test('sign up', () async {
    const SignUpModel data = SignUpModel(
      username: 'username',
      email: 'email@example.com',
      password: 'password123',
    );
    when(
      () => fireAuthService.signUp(
        username: data.username,
        email: data.email,
        password: data.password,
      ),
    ).thenAnswer((_) async => '');

    await fireAuthRepository.signUp(data);

    verify(
      () => fireAuthService.signUp(
        username: data.username,
        email: data.email,
        password: data.password,
      ),
    ).called(1);
  });

  test('send password reset email', () async {
    const String email = 'email@example.com';
    when(() => fireAuthService.sendPasswordResetEmail(email: email))
        .thenAnswer((_) async => '');

    await fireAuthRepository.sendPasswordResetEmail(email);

    verify(() => fireAuthService.sendPasswordResetEmail(email: email))
        .called(1);
  });
}
