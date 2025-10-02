import 'package:flutter/material.dart';
import 'package:neuronavi/core/utils/tts_helper.dart';
import 'package:neuronavi/data/models/task_model.dart';
import 'package:neuronavi/data/providers/achievement_provider.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskProgressScreen extends StatefulWidget {
  final TaskModel task;
  const TaskProgressScreen({super.key, required this.task});

  @override
  State<TaskProgressScreen> createState() => _TaskProgressScreenState();
}

class _TaskProgressScreenState extends State<TaskProgressScreen> {
  final TtsHelper _ttsHelper = TtsHelper();

  @override
  void dispose() {
    _ttsHelper.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final currentTask = taskProvider.tasks.firstWhere(
            (t) => t.id == widget.task.id,
            orElse: () => widget.task);

        return Scaffold(
          appBar: AppBar(
            title: Text(currentTask.title),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: currentTask.subtasks.length,
            itemBuilder: (context, index) {
              final subtask = currentTask.subtasks[index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: CheckboxListTile(
                  title: Text(
                    subtask.title,
                    style: TextStyle(
                      decoration: subtask.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  value: subtask.isCompleted,
                  onChanged: (bool? value) async {
                    if (value != null) {
                      await taskProvider.toggleSubtaskCompletion(
                          currentTask.id, subtask.id);

                      if (value == true && mounted) {
                        final achievementProvider = Provider.of<AchievementProvider>(context, listen: false);
                        achievementProvider.addPointsForSubtask();

                        final updatedTask = taskProvider.tasks.firstWhere((t) => t.id == currentTask.id);
                        if(updatedTask.isCompleted) {
                          achievementProvider.awardBadgeForTaskCompletion();
                        }
                      }
                    }
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () {
                      _ttsHelper.speak(subtask.title);
                    },
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        );
      },
    );
  }
}