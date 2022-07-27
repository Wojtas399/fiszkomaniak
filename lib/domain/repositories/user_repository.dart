import 'package:rxdart/rxdart.dart';
import '../../firebase/models/fire_doc_model.dart';
import '../../firebase/models/day_flashcard_db_model.dart';
import '../../firebase/models/day_db_model.dart';
import '../../firebase/models/user_db_model.dart';
import '../../firebase/services/fire_avatar_service.dart';
import '../../firebase/services/fire_user_service.dart';
import '../../firebase/fire_extensions.dart';
import '../../interfaces/user_interface.dart';
import '../../models/day_flashcard_model.dart';
import '../../models/day_model.dart';
import '../entities/user.dart';

class UserRepository implements UserInterface {
  late final FireUserService _fireUserService;
  late final FireAvatarService _fireAvatarService;
  BehaviorSubject<User?>? _user$;

  UserRepository({
    required FireUserService fireUserService,
    required FireAvatarService fireAvatarService,
  }) {
    _fireUserService = fireUserService;
    _fireAvatarService = fireAvatarService;
  }

  @override
  Stream<User>? get user$ => _user$?.stream.whereType<User>();

  @override
  Stream<String?>? get avatarUrl$ => user$?.map((user) => user.avatarUrl);

  @override
  Future<void> loadUser() async {
    if (_user$ == null) {
      final userFromDb = await _fireUserService.loadLoggedUserData();
      final avatarUrl = await _fireAvatarService.loadLoggedUserAvatarUrl();
      final User? user = _convertUserFromDbToModel(userFromDb, avatarUrl);
      _user$ = BehaviorSubject<User?>.seeded(user);
    }
  }

  @override
  Future<void> addUserData({
    required String userId,
    required String username,
  }) async {
    await _fireUserService.addUserData(userId, username);
  }

  @override
  Future<void> updateAvatar({required String imagePath}) async {
    await _fireAvatarService.saveNewLoggedUserAvatar(imagePath);
    final newAvatarUrl = await _fireAvatarService.loadLoggedUserAvatarUrl();
    _user$?.add(
      _user$?.value?.copyWithAvatarUrl(newAvatarUrl),
    );
  }

  @override
  Future<void> updateUsername({required String newUsername}) async {
    await _fireUserService.saveNewUsername(newUsername);
    _user$?.add(
      _user$?.value?.copyWith(username: newUsername),
    );
  }

  @override
  Future<void> deleteAvatar() async {
    await _fireAvatarService.removeLoggedUserAvatar();
    _user$?.add(
      _user$?.value?.copyWithAvatarUrl(null),
    );
  }

  @override
  Future<void> deleteAllUserData() async {
    await _fireUserService.removeLoggedUserData();
  }

  @override
  void reset() {
    _user$?.close();
    _user$ = null;
  }

  User? _convertUserFromDbToModel(
    FireDoc<UserDbModel>? fireDocument,
    String? avatarUrl,
  ) {
    final UserDbModel? data = fireDocument?.doc;
    final String? loggedUserEmail = _fireUserService.getLoggedUserEmail();
    if (data != null && loggedUserEmail != null) {
      return User(
        avatarUrl: avatarUrl,
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
