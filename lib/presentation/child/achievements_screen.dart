import 'package:flutter/material.dart';
import 'package:neuronavi/data/providers/achievement_provider.dart';
import 'package:neuronavi/presentation/common/widgets/achievement_badge.dart';
import 'package:neuronavi/presentation/common/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Achievements'),
      ),
      body: Consumer<AchievementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.achievementModel == null) {
            return const Center(child: Text('No achievements data found.'));
          }

          final achievements = provider.achievementModel!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 30),
                    const SizedBox(width: 16),
                    Text(
                      '${achievements.points} Points',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Badges Earned',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (achievements.badges.isEmpty)
                const Center(child: Text('Keep completing tasks to earn badges!'))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: achievements.badges.length,
                  itemBuilder: (context, index) {
                    return AchievementBadge(
                      badgeId: achievements.badges[index],
                    );
                  },
                )
            ],
          );
        },
      ),
    );
  }
}