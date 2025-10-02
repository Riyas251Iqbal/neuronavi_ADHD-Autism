// This would be built out to show more detail about a specific task.
// For now, it's a placeholder.
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: const Center(
        child: Text('Details about the task progress will be shown here.'),
      ),
    );
  }
}