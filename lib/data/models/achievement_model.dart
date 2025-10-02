class AchievementModel {
  final String childId;
  final int points;
  final List<String> badges;

  AchievementModel({
    required this.childId,
    this.points = 0,
    this.badges = const [],
  });

  factory AchievementModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AchievementModel(
      childId: documentId,
      points: map['points'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'points': points,
      'badges': badges,
    };
  }
}