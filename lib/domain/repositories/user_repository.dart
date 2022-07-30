import 'package:rxdart/rxdart.dart';
import '../../firebase/models/fire_doc_model.dart';
import '../../firebase/models/day_db_model.dart';
import '../../firebase/models/user_db_model.dart';
import '../../firebase/services/fire_avatar_service.dart';
import '../../firebase/services/fire_user_service.dart';
import '../../firebase/services/fire_days_service.dart';
import '../../firebase/fire_extensions.dart';
import '../../interfaces/user_interface.dart';
import '../entities/day.dart';
import '../entities/flashcard.dart';
import '../entities/user.dart';

class UserRepository implements UserInterface {
  late final FireUserService _fireUserService;
  late final FireAvatarService _fireAvatarService;
  late final FireDaysService _fireDaysService;
  final BehaviorSubject<User?> _user$ = BehaviorSubject<User?>.seeded(null);

  UserRepository({
    required FireUserService fireUserService,
    required FireAvatarService fireAvatarService,
    required FireDaysService fireDaysService,
  }) {
    _fireUserService = fireUserService;
    _fireAvatarService = fireAvatarService;
    _fireDaysService = fireDaysService;
  }

  @override
  Stream<User?> get user$ => _user$.stream;

  @override
  Stream<String?> get avatarUrl$ => user$.map((User? user) => user?.avatarUrl);

  @override
  Stream<List<Day>?> get days$ => user$.map((User? user) => user?.days);

  @override
  Future<void> loadUser() async {
    final userFromDb = await _fireUserService.loadLoggedUserData();
    final avatarUrl = await _fireAvatarService.loadLoggedUserAvatarUrl();
    final User? user = _convertUserFromDbToModel(userFromDb, avatarUrl);
    _user$.add(user);
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
    _user$.add(
      _user$.value?.copyWithAvatarUrl(newAvatarUrl),
    );
  }

  @override
  Future<void> updateUsername({required String newUsername}) async {
    await _fireUserService.saveNewUsername(newUsername);
    _user$.add(
      _user$.value?.copyWith(username: newUsername),
    );
  }

  @override
  Future<void> addRememberedFlashcardsToCurrentDay({
    required String groupId,
    required List<Flashcard> rememberedFlashcards,
  }) async {
    final List<DayDbModel>? updatedDays =
        await _fireDaysService.saveRememberedFlashcardsToCurrentDay(
      flashcardsIds: _getFlashcardsIds(rememberedFlashcards, groupId),
    );
    if (updatedDays != null) {
      _user$.add(
        _user$.value?.copyWith(
          days: _convertFireDaysToDayModel(updatedDays),
        ),
      );
    }
  }

  @override
  Future<void> deleteAvatar() async {
    await _fireAvatarService.removeLoggedUserAvatar();
    _user$.add(
      _user$.value?.copyWithAvatarUrl(null),
    );
  }

  @override
  Future<void> deleteAllUserData() async {
    await _fireUserService.removeLoggedUserData();
  }

  @override
  void reset() {
    _user$.add(null);
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
            amountOfRememberedFlashcards: day.rememberedFlashcardsIds.length,
          ),
        )
        .toList();
  }

  List<String> _getFlashcardsIds(
    List<Flashcard> flashcards,
    String groupId,
  ) {
    return flashcards
        .map((Flashcard flashcard) => flashcard.getId(groupId: groupId))
        .toList();
  }
}
