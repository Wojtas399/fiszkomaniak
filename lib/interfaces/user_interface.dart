import '../domain/entities/user.dart';
import '../domain/entities/flashcard.dart';
import '../domain/entities/day.dart';

abstract class UserInterface {
  Stream<User?> get user$;

  Stream<String?> get avatarUrl$;

  Stream<List<Day>?> get days$;

  Stream<int?> get daysStreak$;

  Future<void> loadUser();

  Future<void> addUserData({
    required String userId,
    required String username,
  });

  Future<void> updateAvatar({required String imagePath});

  Future<void> updateUsername({required String newUsername});

  Future<void> addRememberedFlashcardsToCurrentDay({
    required String groupId,
    required List<Flashcard> rememberedFlashcards,
  });

  Future<void> deleteAvatar();

  Future<void> deleteAllUserData();

  void reset();
}
