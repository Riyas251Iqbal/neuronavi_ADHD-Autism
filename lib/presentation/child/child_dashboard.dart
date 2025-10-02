import 'package:flutter/material.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/data/providers/achievement_provider.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:neuronavi/presentation/common/widgets/custom_card.dart';
import 'package:provider/provider.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final achievementProvider = Provider.of<AchievementProvider>(context);

    final upcomingTask = taskProvider.tasks.isNotEmpty
        ? taskProvider.tasks.firstWhere((t) => !t.isCompleted, orElse: () => taskProvider.tasks.first)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${authProvider.userModel?.name ?? 'there'}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.roleSelection, (route) => false);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Points Card
          CustomCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Points', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  achievementProvider.achievementModel?.points.toString() ?? '0',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Your Next Task',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),

          if (taskProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (upcomingTask == null)
            const CustomCard(child: Center(child: Text('No tasks for now! ✨')))
          else
            CustomCard(
              onTap: () => Navigator.of(context).pushNamed(
                '/task-progress', // Define this route
                arguments: upcomingTask,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(upcomingTask.title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to start working on it!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildDashboardButton(
                  context,
                  icon: Icons.list_alt,
                  label: 'All Tasks',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.taskList),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDashboardButton(
                  context,
                  icon: Icons.emoji_events,
                  label: 'Achievements',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.achievements),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}