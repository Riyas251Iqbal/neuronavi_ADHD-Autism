// Placeholder for parent to manage rewards.
import 'package:flutter/material.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Rewards'),
      ),
      body: const Center(
        child: Text('Parents can assign/manage rewards (like movie night) here.'),
      ),
    );
  }
}