import 'package:flutter/material.dart';
import 'package:neuronavi/data/models/achievement_model.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/services/achievements_service.dart';

class AchievementProvider with ChangeNotifier {
  final UserModel? _userModel;
  final AchievementsService _achievementsService;

  AchievementModel? _achievementModel;
  bool _isLoading = false;

  AchievementModel? get achievementModel => _achievementModel;
  bool get isLoading => _isLoading;

  AchievementProvider(this._userModel, this._achievementsService) {
    if (_userModel != null && _userModel!.role == UserRole.child) {
      fetchAchievements();
    }
  }

  void fetchAchievements() {
    _isLoading = true;
    notifyListeners();
    _achievementsService.getAchievements(_userModel!.uid).listen((achievements) {
      _achievementModel = achievements;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addPointsForSubtask() async {
    if (_userModel != null) {
      await _achievementsService.addPoints(_userModel!.uid);
    }
  }
  
  Future<void> awardBadgeForTaskCompletion() async {
    if (_userModel != null) {
      await _achievementsService.checkAndAwardBadges(_userModel!.uid);
    }
  }
}