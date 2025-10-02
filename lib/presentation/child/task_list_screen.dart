import 'package:flutter/material.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:neuronavi/presentation/common/widgets/custom_card.dart';
import 'package:neuronavi/presentation/common/widgets/progress_bar.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All My Tasks'),
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return CustomCard(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/task-progress', // Define this route
                      arguments: task,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                           Expanded(child: CustomProgressBar(progress: task.progress)),
                           const SizedBox(width: 16),
                           Text('${(task.progress * 100).toStringAsFixed(0)}%'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}