import 'package:flutter/material.dart';
import 'package:neuronavi/core/app_theme.dart';
import 'package:neuronavi/core/routes.dart';
import 'package:neuronavi/data/models/task_model.dart';
import 'package:neuronavi/presentation/child/task_progress_screen.dart';
// REMOVED: No longer need SplashScreen import here as it's handled by routes
// import 'package:neuronavi/presentation/splash/splash_screen.dart'; 

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroNavi',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // --- FIX IS HERE ---
      // REMOVE the 'home' property:
      // home: const SplashScreen(), 

      // ADD the 'initialRoute' property instead:
      initialRoute: AppRoutes.splash, // This tells Flutter to start at '/'
      // --- END OF FIX ---

      onGenerateRoute: (settings) {
        if (settings.name == '/task-progress') {
          final task = settings.arguments as TaskModel;
          return MaterialPageRoute(
            builder: (context) {
              return TaskProgressScreen(task: task);
            },
          );
        }

        final builder = AppRoutes.routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }
        
        return null; 
      },
      routes: AppRoutes.routes,
    );
  }
}