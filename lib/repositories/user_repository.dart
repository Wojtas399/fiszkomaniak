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
  Stream<User> getLoggedUserSnapshots() {
    return Rx.combineLatest2(
      _fireAvatarService.getLoggedUserAvatarSnapshots(),
      _fireUserService.getLoggedUserSnapshots(),
      (String? avatarUrl, DocumentSnapshot<UserDbModel> userDbModel) {
        return _createUserModel(avatarUrl, userDbModel);
      },
    ).whereType<User>();
  }

  @override
  Future<void> saveNewAvatar({required String fullPath}) async {
    await _fireAvatarService.saveNewLoggedUserAvatar(fullPath);
  }

  @override
  Future<void> removeAvatar() async {
    await _fireAvatarService.removeLoggedUserAvatar();
  }

  @override
  Future<void> saveNewUsername({required String newUsername}) async {
    await _fireUserService.saveNewUsername(newUsername);
  }

  @override
  Future<void> saveNewRememberedFlashcardsInDays({
    required String groupId,
    required List<int> indexesOfFlashcards,
  }) async {
    await _fireUserService.saveNewRememberedFlashcards(
      groupId,
      indexesOfFlashcards,
    );
  }

  User? _createUserModel(
    String? avatarUrl,
    DocumentSnapshot<UserDbModel> fireDocument,
  ) {
    final UserDbModel? data = fireDocument.data();
    final String? loggedUserEmail = FireUser.loggedUserEmail;
    if (data != null && loggedUserEmail != null) {
      return User(
        email: loggedUserEmail,
        username: data.username,
        avatarUrl: avatarUrl,
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
