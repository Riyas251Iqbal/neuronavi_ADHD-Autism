// lib/presentation/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/core/utils/validators.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:neuronavi/presentation/common/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _childEmailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _childEmailController.dispose();
    super.dispose();
  }

  void _submit(UserRole role) async {
    if (_formKey.currentState!.validate()) {
      print('\n=== Register Screen: Form validated ===');
      print('Name: ${_nameController.text.trim()}');
      print('Email: ${_emailController.text.trim()}');
      print('Role: $role');
      print('Child Email: ${_childEmailController.text.trim()}');
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: role,
        linkedAccountEmail: role == UserRole.parent && _childEmailController.text.trim().isNotEmpty
            ? _childEmailController.text.trim()
            : null,
      );

      if (!mounted) return;

      if (success) {
        print('Register Screen: Registration successful, navigating...');
        if (role == UserRole.parent) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.parentDashboard);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.childDashboard);
        }
      } else {
        print('Register Screen: Registration failed');
        final errorMsg = authProvider.errorMessage ?? 
            'Registration failed. The email may already be in use or the child account was not found.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      print('Register Screen: Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ModalRoute.of(context)!.settings.arguments as UserRole;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create ${role == UserRole.parent ? "Parent" : "Child"} Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              if (authProvider.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    Validators.validateNotEmpty(value, 'Full Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              if (role == UserRole.parent) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _childEmailController,
                  decoration: const InputDecoration(
                      labelText: 'Child\'s Account Email (Optional)'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return Validators.validateEmail(value);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'You can link to your child\'s account now or later. Make sure your child has already created their account first.',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              CustomButton(
                text: 'Register',
                isLoading: authProvider.status == AuthStatus.authenticating,
                onPressed: () => _submit(role),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
                child: const Text('Already have an account? Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}