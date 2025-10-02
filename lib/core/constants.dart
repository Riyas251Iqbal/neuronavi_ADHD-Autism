class AppConstants {
  // Firestore Collections
  static const String usersCollection = 'users';
  static const String tasksCollection = 'tasks';
  static const String achievementsCollection = 'achievements';
  static const String notificationsCollection = 'notifications';

  // Gemini AI Prompt
  static const String aiPrompt =
      "Break down the following high-level task into a simple, ordered list of actionable sub-tasks for a child. Each sub-task should be a short, clear instruction. Do not add any introductory or concluding text, just the list. For example, for the task 'Clean your bedroom', respond with a list like: 1. Make your bed. 2. Put all your toys in the toy box. 3. Place dirty clothes in the laundry basket. 4. Arrange books on the shelf. The task is: ";
}