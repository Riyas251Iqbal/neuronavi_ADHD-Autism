import 'package:flutter/material.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/presentation/common/widgets/custom_button.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome to\nNeuroNavi',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose your role to get started',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'I am a Parent / Caregiver',
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.register,
                    arguments: UserRole.parent,
                  );
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'I am a Child',
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.register,
                    arguments: UserRole.child,
                  );
                },
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                },
                child: const Text('Already have an account? Log In'),
              )
            ],
          ),
        ),
      ),
    );
  }
}