import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/achievement_db_model.dart';

class FireAchievementsService {
  final String allFlashcardsAmountId = 'AllFlashcardsAmount';
  final String rememberedFlashcardsAmountId = 'RememberedFlashcardsAmount';
  final String finishedSessionsAmountId = 'FinishedSessionsAmount';

  Stream<QuerySnapshot<AchievementDbModel>> getSnapshots() {
    return FireReferences.achievementsRefWithConverter.snapshots();
  }

  Future<void> initializeAchievements() async {
    final List<int> conditionsValues = [
      100,
      250,
      500,
      1000,
      2500,
      5000,
      10000,
      25000,
      50000,
      100000,
      250000,
      500000,
      1000000,
    ];
    final List<AchievementConditionDbModel> conditions = conditionsValues
        .map((value) => AchievementConditionDbModel(
              conditionValue: value,
              status: 'uncompleted',
            ))
        .toList();
    final batch = FireInstances.firestore.batch();
    final allFlashcardsAmountDoc =
        FireReferences.achievementsRefWithConverter.doc(allFlashcardsAmountId);
    final rememberedFlashcardsAmountDoc = FireReferences
        .achievementsRefWithConverter
        .doc(rememberedFlashcardsAmountId);
    final finishedSessionsAmountDoc = FireReferences
        .achievementsRefWithConverter
        .doc(finishedSessionsAmountId);
    final initialAchievementData = AchievementDbModel(
      completedElementsIds: const [],
      conditions: conditions,
    );
    batch.set(allFlashcardsAmountDoc, initialAchievementData);
    batch.set(rememberedFlashcardsAmountDoc, initialAchievementData);
    batch.set(finishedSessionsAmountDoc, initialAchievementData);
    await batch.commit();
  }

  Future<int?> updateAllFlashcardsAmount(
    List<String> flashcardsIds,
  ) async {
    return await _updateFlashcardsAchievement(
      achievementId: allFlashcardsAmountId,
      newCompletedFlashcardsIds: flashcardsIds,
    );
  }

  Future<int?> updateRememberedFlashcardsAmount(
    List<String> rememberedFlashcardsIds,
  ) async {
    return await _updateFlashcardsAchievement(
      achievementId: rememberedFlashcardsAmountId,
      newCompletedFlashcardsIds: rememberedFlashcardsIds,
    );
  }

  Future<int?> updateFinishedSessionsAmount(final String? newSessionId) async {
    final doc = await FireReferences.achievementsRefWithConverter
        .doc(finishedSessionsAmountId)
        .get();
    final List<String>? sessionsIds = doc.data()?.completedElementsIds;
    if (sessionsIds != null) {
      final updatedSessionsIds = [...sessionsIds];
      updatedSessionsIds.add(
        newSessionId ?? _getNextQuickSessionId(sessionsIds),
      );
      final uniqueSessionsIds = updatedSessionsIds.toSet().toList();
      await FireReferences.achievementsRefWithConverter
          .doc(finishedSessionsAmountId)
          .update(AchievementDbModel(completedElementsIds: uniqueSessionsIds)
              .toJson());
      return uniqueSessionsIds.length;
    }
    return null;
  }

  Future<int?> getNextAchievedCondition({
    required String achievementType,
    required int value,
  }) async {
    final doc = await FireReferences.achievementsRefWithConverter
        .doc(achievementType)
        .get();
    final List<AchievementConditionDbModel> conditions = [
      ...?doc.data()?.conditions,
    ];
    final int? nextUnreachedConditionValue = conditions
        .firstWhere((condition) => condition.status == 'uncompleted')
        .conditionValue;
    if (nextUnreachedConditionValue != null &&
        value >= nextUnreachedConditionValue) {
      final int conditionIndex = conditions.indexWhere(
        (condition) => condition.conditionValue == nextUnreachedConditionValue,
      );
      if (conditionIndex >= 0) {
        conditions[conditionIndex] =
            conditions[conditionIndex].copyWithStatus('completed');
        await FireReferences.achievementsRefWithConverter
            .doc(achievementType)
            .update(AchievementDbModel(conditions: conditions).toJson());
      }
      return nextUnreachedConditionValue;
    }
    return null;
  }

  Future<int?> _updateFlashcardsAchievement({
    required String achievementId,
    required List<String> newCompletedFlashcardsIds,
  }) async {
    final doc = await FireReferences.achievementsRefWithConverter
        .doc(achievementId)
        .get();
    final List<String>? flashcardsIds = doc.data()?.completedElementsIds;
    if (flashcardsIds != null) {
      final updatedFlashcardsIds = [...flashcardsIds];
      updatedFlashcardsIds.addAll(newCompletedFlashcardsIds);
      final uniqueFlashcardsIds = updatedFlashcardsIds.toSet().toList();
      await FireReferences.achievementsRefWithConverter
          .doc(achievementId)
          .update(AchievementDbModel(completedElementsIds: uniqueFlashcardsIds)
              .toJson());
      return uniqueFlashcardsIds.length;
    }
    return null;
  }

  String _getNextQuickSessionId(List<String> existingSessionsIds) {
    if (existingSessionsIds.isEmpty) {
      return 'quickSession1';
    }
    final int latestQuickSessionNumber = existingSessionsIds
        .where((id) => id.contains('quickSession'))
        .map((id) => id.replaceAll('quickSession', ''))
        .map((numberAsString) => int.parse(numberAsString))
        .reduce(max);
    return 'quickSession${latestQuickSessionNumber + 1}';
  }
}
