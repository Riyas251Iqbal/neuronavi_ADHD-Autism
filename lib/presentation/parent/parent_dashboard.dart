import 'package:flutter/material.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:neuronavi/presentation/common/widgets/custom_card.dart';
import 'package:neuronavi/presentation/common/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authProvider.userModel?.name ?? 'Parent'}'),
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
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                taskProvider.fetchTasks();
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Child\'s Task Progress',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  if (taskProvider.tasks.isEmpty)
                    const Center(
                      child: Text('No tasks assigned yet. Create one!'),
                    ),
                  ...taskProvider.tasks.map((task) {
                    return CustomCard(
                      onTap: () {
                        // Navigate to task detail screen
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            '${(task.progress * 100).toStringAsFixed(0)}% Complete',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          CustomProgressBar(progress: task.progress),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.createTask);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}