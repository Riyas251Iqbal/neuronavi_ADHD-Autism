// lib/data/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neuronavi/core/constants.dart';
import 'package:neuronavi/data/models/achievement_model.dart';
import 'package:neuronavi/data/models/task_model.dart';
import 'package:neuronavi/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Methods
  Future<void> setUser(UserModel user) async {
    try {
      print('FirestoreService: Setting user ${user.uid} with role ${user.role}');
      await _db
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
      print('FirestoreService: User set successfully');
    } catch (e) {
      print('FirestoreService: Error setting user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      print('FirestoreService: Getting user $uid');
      final doc = await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      if (doc.exists && doc.data() != null) {
        print('FirestoreService: User found - ${doc.data()}');
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      print('FirestoreService: User not found');
      return null;
    } catch (e) {
      print('FirestoreService: Error getting user: $e');
      return null;
    }
  }
  
  Future<UserModel?> findUserByEmail(String email) async {
    try {
      print('FirestoreService: Finding user by email: $email');
      final querySnapshot = await _db
          .collection(AppConstants.usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        print('FirestoreService: User found by email - ${doc.data()}');
        return UserModel.fromMap(doc.data(), doc.id);
      }
      print('FirestoreService: No user found with email: $email');
      return null;
    } catch (e) {
      print('FirestoreService: Error finding user by email: $e');
      return null;
    }
  }

  // Task Methods
  Future<void> createTask(TaskModel task) async {
    try {
      print('FirestoreService: Creating task: ${task.title}');
      await _db
          .collection(AppConstants.tasksCollection)
          .add(task.toMap());
      print('FirestoreService: Task created successfully');
    } catch (e) {
      print('FirestoreService: Error creating task: $e');
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      print('FirestoreService: Updating task: ${task.id}');
      await _db
          .collection(AppConstants.tasksCollection)
          .doc(task.id)
          .update(task.toMap());
      print('FirestoreService: Task updated successfully');
    } catch (e) {
      print('FirestoreService: Error updating task: $e');
      rethrow;
    }
  }
  
  Stream<List<TaskModel>> getTasksForUser(String userId, UserRole role) {
    String field = role == UserRole.parent ? 'parentId' : 'childId';
    print('FirestoreService: Setting up task stream for $field = $userId');
    return _db
        .collection(AppConstants.tasksCollection)
        .where(field, isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print('FirestoreService: Received ${snapshot.docs.length} tasks');
          return snapshot.docs
              .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Achievement Methods
  Future<void> setInitialAchievements(String childId) async {
    try {
      print('FirestoreService: Setting initial achievements for $childId');
      await _db
          .collection(AppConstants.achievementsCollection)
          .doc(childId)
          .set(AchievementModel(childId: childId).toMap());
      print('FirestoreService: Initial achievements set successfully');
    } catch (e) {
      print('FirestoreService: Error setting initial achievements: $e');
      rethrow;
    }
  }

  Stream<AchievementModel?> getAchievements(String childId) {
    print('FirestoreService: Setting up achievements stream for $childId');
    return _db
        .collection(AppConstants.achievementsCollection)
        .doc(childId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        print('FirestoreService: Achievements received');
        return AchievementModel.fromMap(doc.data()!, doc.id);
      }
      print('FirestoreService: No achievements found');
      return null;
    });
  }
  
  Future<void> updateAchievements(String childId, Map<String, dynamic> data) async {
    try {
      print('FirestoreService: Updating achievements for $childId');
      await _db
          .collection(AppConstants.achievementsCollection)
          .doc(childId)
          .update(data);
      print('FirestoreService: Achievements updated successfully');
    } catch (e) {
      print('FirestoreService: Error updating achievements: $e');
      rethrow;
    }
  }
}