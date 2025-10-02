import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:neuronavi/app.dart';
import 'package:neuronavi/data/providers/achievement_provider.dart';
import 'package:neuronavi/data/providers/auth_provider.dart';
import 'package:neuronavi/data/providers/notification_provider.dart';
import 'package:neuronavi/data/providers/task_provider.dart';
import 'package:neuronavi/data/services/achievements_service.dart';
import 'package:neuronavi/data/services/auth_service.dart';
import 'package:neuronavi/data/services/firestore_service.dart';
import 'package:neuronavi/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Services
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final achievementsService = AchievementsService(firestoreService);

    return MultiProvider(
      providers: [
        // AuthProvider depends only on AuthService
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, firestoreService),
        ),
        // ChangeNotifierProxyProvider rebuilds providers when another provider they depend on changes.
        // Here, TaskProvider, AchievementProvider, etc., depend on the user's authentication state.
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (_) => TaskProvider(null, firestoreService),
          update: (_, authProvider, previousTaskProvider) =>
              TaskProvider(authProvider.userModel, firestoreService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AchievementProvider>(
          create: (_) => AchievementProvider(null, achievementsService),
          update: (_, authProvider, __) =>
              AchievementProvider(authProvider.userModel, achievementsService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, NotificationProvider>(
          create: (_) => NotificationProvider(null, firestoreService),
          update: (_, authProvider, __) =>
              NotificationProvider(authProvider.userModel, firestoreService),
        ),
      ],
      child: const App(),
    );
  }
}