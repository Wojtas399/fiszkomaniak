import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/profile/bloc/profile_bloc.dart';
import 'package:fiszkomaniak/features/profile/profile_dialogs.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockUserBloc extends Mock implements UserBloc {}

class MockProfileDialogs extends Mock implements ProfileDialogs {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  final UserBloc userBloc = MockUserBloc();
  final ProfileDialogs profileDialogs = MockProfileDialogs();
  final ImagePicker imagePicker = MockImagePicker();
  late ProfileBloc bloc;
  final User loggedUser = createUser(avatarUrl: 'avatar/url');

  setUp(() {
    bloc = ProfileBloc(
      userBloc: userBloc,
      profileDialogs: profileDialogs,
      imagePicker: imagePicker,
    );
    when(() => userBloc.state).thenReturn(UserState(loggedUser: loggedUser));
    when(() => userBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    reset(userBloc);
    reset(profileDialogs);
    reset(imagePicker);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventInitialize()),
    expect: () => [ProfileState(userData: loggedUser)],
  );

  blocTest(
    'user updated',
    build: () => bloc,
    act: (_) => bloc.add(ProfileEventUserUpdated(newUserData: loggedUser)),
    expect: () => [ProfileState(userData: loggedUser)],
  );

  blocTest(
    'avatar pressed, no avatar set',
    build: () => ProfileBloc(
      userBloc: userBloc,
      profileDialogs: profileDialogs,
      imagePicker: imagePicker,
    ),
    setUp: () {
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (ProfileBloc profileBloc) => profileBloc.add(
      ProfileEventAvatarPressed(),
    ),
    verify: (_) {
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verify(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'avatar pressed, edit, image source not selected',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => null);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verifyNever(() => imagePicker.pickImage(source: ImageSource.gallery));
      verifyNever(() => profileDialogs.askForImageConfirmation('path/to/file'));
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'avatar pressed, edit, image not selected',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => null);
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verifyNever(() => profileDialogs.askForImageConfirmation('path/to/file'));
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'avatar pressed, edit, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verify(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      ).called(1);
    },
  );

  blocTest(
    'avatar pressed, edit, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.edit);
      when(() => profileDialogs.askForImageSource())
          .thenAnswer((_) async => ImageSource.gallery);
      when(() => imagePicker.pickImage(source: ImageSource.gallery))
          .thenAnswer((_) async => XFile('path/to/file'));
      when(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForImageSource()).called(1);
      verify(() => imagePicker.pickImage(source: ImageSource.gallery))
          .called(1);
      verify(() => profileDialogs.askForImageConfirmation('path/to/file'))
          .called(1);
      verifyNever(
        () => userBloc.add(
          UserEventSaveNewAvatar(imageFullPath: 'path/to/file'),
        ),
      );
    },
  );

  blocTest(
    'avatar pressed, delete, confirmed',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.delete);
      when(() => profileDialogs.askForDeleteAvatarConfirmation())
          .thenAnswer((_) async => true);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForDeleteAvatarConfirmation()).called(1);
      verify(() => userBloc.add(UserEventRemoveAvatar())).called(1);
    },
  );

  blocTest(
    'avatar pressed, delete, cancelled',
    build: () => bloc,
    setUp: () {
      when(() => profileDialogs.askForAvatarAction())
          .thenAnswer((_) async => AvatarActions.delete);
      when(() => profileDialogs.askForDeleteAvatarConfirmation())
          .thenAnswer((_) async => false);
    },
    act: (_) {
      bloc.add(ProfileEventInitialize());
      bloc.add(ProfileEventAvatarPressed());
    },
    verify: (_) {
      verify(() => profileDialogs.askForAvatarAction()).called(1);
      verify(() => profileDialogs.askForDeleteAvatarConfirmation()).called(1);
      verifyNever(() => userBloc.add(UserEventRemoveAvatar()));
    },
  );
}
