import 'package:flutter/material.dart';
import 'package:neuronavi/core/app_theme.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress; // from 0.0 to 1.0

  const CustomProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.grey[300],
        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
      ),
    );
  }
}