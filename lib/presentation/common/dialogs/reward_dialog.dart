import 'package:flutter/material.dart';

Future<void> showRewardDialog({
  required BuildContext context,
  required String achievement,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('🎉 Achievement Unlocked! 🎉'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Congratulations! You\'ve earned the "$achievement" badge!'),
              const SizedBox(height: 20),
              const Text('Ask a parent about a special reward!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Awesome!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}