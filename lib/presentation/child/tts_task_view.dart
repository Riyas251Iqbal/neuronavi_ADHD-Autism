// The functionality of this screen has been integrated directly into
// the TaskProgressScreen with the volume icon. This file can be
// removed or kept as a placeholder for a different, more dedicated TTS view.
import 'package:flutter/material.dart';

class TtsTaskView extends StatelessWidget {
  const TtsTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Reader'),
      ),
      body: const Center(
        child: Text(
          'This screen could provide a focused, one-subtask-at-a-time view with large text and TTS buttons.',
        ),
      ),
    );
  }
}