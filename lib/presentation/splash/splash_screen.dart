import 'package:flutter/material.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted || _hasNavigated) return;
    
    _navigate();
  }

  void _navigate() {
    if (_hasNavigated || !mounted) return;
    
    _hasNavigated = true;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated && authProvider.userModel != null) {
      if (authProvider.userModel!.role == UserRole.parent) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.parentDashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.childDashboard);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'NeuroNavi',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}