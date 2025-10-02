import 'package:flutter/material.dart';
// import 'package:neuronavi/core/app_theme.dart';

class AchievementBadge extends StatelessWidget {
  final String badgeId;
  final bool earned;

  const AchievementBadge({
    super.key,
    required this.badgeId,
    this.earned = true,
  });

  // A simple map to get display info for badges
  static const Map<String, dynamic> _badgeInfo = {
    'task_completed_badge': {
      'icon': Icons.check_circle,
      'label': 'Task Master',
      'color': Colors.green,
    },
    'first_task': {
      'icon': Icons.star,
      'label': 'First Step',
      'color': Colors.amber,
    },
    // Add more badges here
  };

  @override
  Widget build(BuildContext context) {
    final info = _badgeInfo[badgeId] ??
        {'icon': Icons.help, 'label': 'Unknown', 'color': Colors.grey};

    return Opacity(
      opacity: earned ? 1.0 : 0.3,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: info['color'],
            child: Icon(
              info['icon'],
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            info['label'],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}