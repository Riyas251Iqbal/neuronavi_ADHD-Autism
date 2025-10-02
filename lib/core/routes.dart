import 'package:flutter/material.dart';
import 'package:neuronavi/presentation/auth/login_screen.dart';
import 'package:neuronavi/presentation/auth/register_screen.dart';
import 'package:neuronavi/presentation/auth/role_selection_screen.dart';
import 'package:neuronavi/presentation/child/achievements_screen.dart';
import 'package:neuronavi/presentation/child/child_dashboard.dart';
import 'package:neuronavi/presentation/child/task_list_screen.dart';
import 'package:neuronavi/presentation/parent/create_task_screen.dart';
import 'package:neuronavi/presentation/parent/parent_dashboard.dart';
import 'package:neuronavi/presentation/parent/reward_screen.dart';
import 'package:neuronavi/presentation/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String parentDashboard = '/parent-dashboard';
  static const String childDashboard = '/child-dashboard';
  static const String createTask = '/create-task';
  static const String reward = '/reward';
  static const String taskList = '/task-list';
  static const String achievements = '/achievements';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    roleSelection: (context) => const RoleSelectionScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    parentDashboard: (context) => const ParentDashboard(),
    childDashboard: (context) => const ChildDashboard(),
    createTask: (context) => const CreateTaskScreen(),
    reward: (context) => const RewardScreen(),
    taskList: (context) => const TaskListScreen(),
    achievements: (context) => const AchievementsScreen(),
  };
}