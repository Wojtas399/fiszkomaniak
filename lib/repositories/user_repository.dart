import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/day_flashcard_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_user_service.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/day_flashcard_model.dart';
import 'package:fiszkomaniak/models/day_model.dart';
import 'package:fiszkomaniak/firebase/fire_converters.dart';
import '../firebase/models/day_db_model.dart';
import '../firebase/models/user_db_model.dart';
import '../models/user_model.dart';

class UserRepository implements UserInterface {
  late final FireUserService _fireUserService;

  UserRepository({
    required FireUserService fireUserService,
  }) {
    _fireUserService = fireUserService;
  }

  @override
  Stream<User> getLoggedUserSnapshots() async* {
    final Stream<User?> stream = _fireUserService
        .getLoggedUserSnapshots()
        .map(_convertFireDocumentToUserModel);
    await for (final value in stream) {
      if (value != null) {
        yield value;
      }
    }
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

  User? _convertFireDocumentToUserModel(
      DocumentSnapshot<UserDbModel> document) {
    final UserDbModel? data = document.data();
    if (data != null) {
      return User(days: _convertFireDaysToDayModel(data.days));
    }
    return null;
  }

  List<Day> _convertFireDaysToDayModel(List<DayDbModel>? days) {
    return (days ?? [])
        .map(
          (day) => Day(
            date: FireConverters.convertStringToDateTime(day.date),
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
