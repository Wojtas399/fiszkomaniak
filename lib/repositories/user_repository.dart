import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'package:fiszkomaniak/firebase/models/day_flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_avatar_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/day_flashcard_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/firebase/fire_extensions.dart';
import 'package:rxdart/rxdart.dart';
import '../firebase/models/day_db_model.dart';
import '../firebase/models/user_db_model.dart';
import '../models/user_model.dart';

class UserRepository implements UserInterface {
  final _loggedUserAvatarUrl$ = BehaviorSubject<String?>.seeded(null);
  final _loggedUserData$ = BehaviorSubject<User?>.seeded(null);
  late final FireUserService _fireUserService;
  late final FireAvatarService _fireAvatarService;

  UserRepository({
    required FireUserService fireUserService,
    required FireAvatarService fireAvatarService,
  }) {
    _fireUserService = fireUserService;
    _fireAvatarService = fireAvatarService;
  }

  @override
  Stream<String> get loggedUserAvatarUrl$ =>
      _loggedUserAvatarUrl$.stream.whereType<String>();

  @override
  Stream<User> get loggedUserData$ => _loggedUserData$.stream.whereType<User>();

  @override
  Future<void> loadLoggedUserAvatar() async {
    if (_loggedUserAvatarUrl$.value == null) {
      _loggedUserAvatarUrl$.add(
        await _fireAvatarService.loadLoggedUserAvatarUrl(),
      );
    }
  }

  @override
  Future<void> loadLoggedUserData() async {
    if (_loggedUserData$.value == null) {
      final userFromDb = await _fireUserService.loadLoggedUserData();
      _loggedUserData$.add(_convertUserFromDbToModel(userFromDb));
    }
  }

  @override
  Future<void> addUser({
    required String userId,
    required String username,
  }) async {
    await _fireUserService.addUser(userId, username);
  }

  @override
  Future<void> saveNewAvatar({required String fullPath}) async {
    await _fireAvatarService.saveNewLoggedUserAvatar(fullPath);
    final newAvatarUrl = await _fireAvatarService.loadLoggedUserAvatarUrl();
    _loggedUserAvatarUrl$.add(newAvatarUrl);
  }

  @override
  Future<void> removeAvatar() async {
    await _fireAvatarService.removeLoggedUserAvatar();
  }

  @override
  Future<void> saveNewUsername({required String newUsername}) async {
    await _fireUserService.saveNewUsername(newUsername);
    _loggedUserData$.add(
      _loggedUserData$.value?.copyWith(username: newUsername),
    );
  }

  User? _convertUserFromDbToModel(DocumentSnapshot<UserDbModel> fireDocument) {
    final UserDbModel? data = fireDocument.data();
    final String? loggedUserEmail = FireUser.loggedUserEmail;
    if (data != null && loggedUserEmail != null) {
      return User(
        email: loggedUserEmail,
        username: data.username,
        days: _convertFireDaysToDayModel(data.days),
      );
    }
    return null;
  }

  List<Day> _convertFireDaysToDayModel(List<DayDbModel>? days) {
    return (days ?? [])
        .map(
          (day) => Day(
            date: day.date.toDate(),
            rememberedFlashcards: _convertFireDayFlashcardsToDayFlashcardsModel(
              day.rememberedFlashcards,
            ),
          ),
        )
        .toList();
  }

  List<DayFlashcard> _convertFireDayFlashcardsToDayFlashcardsModel(
    List<DayFlashcardDbModel> flashcards,
  ) {
    return flashcards
        .map(
          (flashcard) => DayFlashcard(
            groupId: flashcard.groupId,
            flashcardIndex: flashcard.flashcardIndex,
          ),
        )
        .toList();
  }
}
