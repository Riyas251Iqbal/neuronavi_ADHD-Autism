import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neuronavi/data/models/achievement_model.dart';
import 'package:neuronavi/data/services/firestore_service.dart';

class AchievementsService {
  final FirestoreService _firestoreService;

  AchievementsService(this._firestoreService);

  // This was the missing method
  Stream<AchievementModel?> getAchievements(String childId) {
    return _firestoreService.getAchievements(childId);
  }

  // Called when a subtask is completed
  Future<void> addPoints(String childId, {int points = 10}) async {
    await _firestoreService.updateAchievements(childId, {
      'points': FieldValue.increment(points),
    });
  }

  // Called when a full task is completed
  Future<void> checkAndAwardBadges(String childId) async {
    // This is a simplified example.
    await _firestoreService.updateAchievements(childId, {
      'badges': FieldValue.arrayUnion(['task_completed_badge']),
    });
  }
}