import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/repositories/achievements_repository.dart';
import 'package:fiszkomaniak/firebase/models/achievement_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_achievements_service.dart';

class MockFireAchievementsService extends Mock
    implements FireAchievementsService {}

void main() {
  final fireAchievementsService = MockFireAchievementsService();
  late AchievementsRepository repository;

  setUp(() {
    repository = AchievementsRepository(
      fireAchievementsService: fireAchievementsService,
    );
  });

  tearDown(() {
    reset(fireAchievementsService);
  });

  test(
    'load all flashcards amount, should set amount of completed elements from all flashcards amount achievement',
    () async {
      const List<String> completedElementsIds = ['f1', 'f2', 'f3'];
      when(
        () => fireAchievementsService.loadAllFlashcardsAmount(),
      ).thenAnswer(
        (_) async => const AchievementDbModel(
          completedElementsIds: completedElementsIds,
        ),
      );

      await repository.loadAllFlashcardsAmount();

      expect(
        await repository.allFlashcardsAmount$.first,
        completedElementsIds.length,
      );
    },
  );

  test(
    'load all flashcards amount, should set 0 if completed elements are set as null',
    () async {
      when(
        () => fireAchievementsService.loadAllFlashcardsAmount(),
      ).thenAnswer((_) async => const AchievementDbModel());

      await repository.loadAllFlashcardsAmount();

      expect(await repository.allFlashcardsAmount$.first, 0);
    },
  );

  test(
    'set initial achievements, should call method responsible for initializing achievements in db',
    () async {
      when(
        () => fireAchievementsService.initializeAchievements(),
      ).thenAnswer((_) async => '');

      await repository.setInitialAchievements();

      verify(
        () => fireAchievementsService.initializeAchievements(),
      ).called(1);
    },
  );

  group(
    'add flashcards',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];
      const String groupId = 'group1';
      const List<String> flashcardsIds = ['group10', 'group11'];
      const String allFlashcardsAmountId = 'allFlashcardsAmount';

      setUp(() {
        when(
          () => fireAchievementsService.updateAllFlashcardsAmount(
            flashcardsIds,
          ),
        ).thenAnswer((_) async => 100);
        when(
          () => fireAchievementsService.allFlashcardsAmountId,
        ).thenReturn(allFlashcardsAmountId);
      });

      test(
        'should call method responsible for updating all flashcards amount and should assign new achievement value to stream',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: allFlashcardsAmountId,
              value: 100,
            ),
          ).thenAnswer((_) async => null);

          await repository.addFlashcards(
            groupId: groupId,
            flashcards: flashcards,
          );

          expect(await repository.allFlashcardsAmount$.first, 100);
          expect(
            await repository.allFlashcardsAchievedCondition$.first,
            null,
          );
          verify(
            () => fireAchievementsService.updateAllFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: allFlashcardsAmountId,
              value: 100,
            ),
          ).called(1);
        },
      );

      test(
        'should assign new achieved value to stream if it is reached',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: allFlashcardsAmountId,
              value: 100,
            ),
          ).thenAnswer((_) async => 100);

          await repository.addFlashcards(
            groupId: groupId,
            flashcards: flashcards,
          );

          expect(
            await repository.allFlashcardsAchievedCondition$.first,
            100,
          );
          verify(
            () => fireAchievementsService.updateAllFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: allFlashcardsAmountId,
              value: 100,
            ),
          ).called(1);
        },
      );

      test(
        'should just call method responsible for updating all flashcards amount if returned new achievement value is null',
        () async {
          when(
            () => fireAchievementsService.updateAllFlashcardsAmount(
              flashcardsIds,
            ),
          ).thenAnswer((_) async => null);
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async => null);

          await repository.addFlashcards(
            groupId: groupId,
            flashcards: flashcards,
          );

          expect(await repository.allFlashcardsAmount$.first, null);
          verify(
            () => fireAchievementsService.updateAllFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verifyNever(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          );
        },
      );
    },
  );

  group(
    'add remembered flashcards',
    () {
      const String groupId = 'g1';
      final List<Flashcard> flashcards = [
        createFlashcard(index: 0),
        createFlashcard(index: 1),
      ];
      const List<String> flashcardsIds = ['g10', 'g11'];
      const String rememberedFlashcardsId = 'rememberedFlashcardsId';

      setUp(() {
        when(
          () => fireAchievementsService.updateRememberedFlashcardsAmount(
            flashcardsIds,
          ),
        ).thenAnswer((_) async => 100);
        when(
          () => fireAchievementsService.rememberedFlashcardsAmountId,
        ).thenReturn(rememberedFlashcardsId);
      });

      test(
        'should call method responsible for updating remembered flashcards amount',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: rememberedFlashcardsId,
              value: 100,
            ),
          ).thenAnswer((_) async => null);

          await repository.addRememberedFlashcards(
            groupId: groupId,
            rememberedFlashcards: flashcards,
          );

          expect(
            await repository.rememberedFlashcardsAchievedCondition$.first,
            null,
          );
          verify(
            () => fireAchievementsService.updateRememberedFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: rememberedFlashcardsId,
              value: 100,
            ),
          ).called(1);
        },
      );

      test(
        'should assign new achieved value to stream if it is reached',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: rememberedFlashcardsId,
              value: 100,
            ),
          ).thenAnswer((_) async => 100);

          await repository.addRememberedFlashcards(
            groupId: groupId,
            rememberedFlashcards: flashcards,
          );

          expect(
            await repository.rememberedFlashcardsAchievedCondition$.first,
            100,
          );
          verify(
            () => fireAchievementsService.updateRememberedFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: rememberedFlashcardsId,
              value: 100,
            ),
          ).called(1);
        },
      );

      test(
        'should just call method responsible for updating remembered flashcards amount if returned new achievement value is null',
        () async {
          when(
            () => fireAchievementsService.updateRememberedFlashcardsAmount(
              flashcardsIds,
            ),
          ).thenAnswer((_) async => null);
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async => null);

          await repository.addRememberedFlashcards(
            groupId: groupId,
            rememberedFlashcards: flashcards,
          );

          verify(
            () => fireAchievementsService.updateRememberedFlashcardsAmount(
              flashcardsIds,
            ),
          ).called(1);
          verifyNever(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          );
        },
      );
    },
  );

  group(
    'add finished session',
    () {
      const String sessionId = 's1';
      const String finishedSessionsId = 'finishedSessionsId';

      setUp(() {
        when(
          () => fireAchievementsService.updateFinishedSessionsAmount(
            sessionId,
          ),
        ).thenAnswer((_) async => 10);
        when(
          () => fireAchievementsService.finishedSessionsAmountId,
        ).thenReturn(finishedSessionsId);
      });

      test(
        'should call method responsible for updating finished sessions amount',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: finishedSessionsId,
              value: 10,
            ),
          ).thenAnswer((_) async => null);

          await repository.addFinishedSession(sessionId: sessionId);

          expect(
            await repository.finishedSessionsAchievedCondition$.first,
            null,
          );
          verify(
            () => fireAchievementsService.updateFinishedSessionsAmount(
              sessionId,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: finishedSessionsId,
              value: 10,
            ),
          ).called(1);
        },
      );

      test(
        'should assign new achieved value to stream if it is reached',
        () async {
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: finishedSessionsId,
              value: 10,
            ),
          ).thenAnswer((_) async => 10);

          await repository.addFinishedSession(sessionId: sessionId);

          expect(
            await repository.finishedSessionsAchievedCondition$.first,
            10,
          );
          verify(
            () => fireAchievementsService.updateFinishedSessionsAmount(
              sessionId,
            ),
          ).called(1);
          verify(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: finishedSessionsId,
              value: 10,
            ),
          ).called(1);
        },
      );

      test(
        'should just call method responsible for updating finished sessions amount if returned new achievement value is null',
        () async {
          when(
            () => fireAchievementsService.updateFinishedSessionsAmount(
              sessionId,
            ),
          ).thenAnswer((_) async => null);
          when(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          ).thenAnswer((_) async => null);

          await repository.addFinishedSession(sessionId: sessionId);

          verify(
            () => fireAchievementsService.updateFinishedSessionsAmount(
              sessionId,
            ),
          ).called(1);
          verifyNever(
            () => fireAchievementsService.getNextAchievedCondition(
              achievementType: any(named: 'achievementType'),
              value: any(named: 'value'),
            ),
          );
        },
      );
    },
  );
}
