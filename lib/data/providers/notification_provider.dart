import 'package:flutter/material.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/services/firestore_service.dart';
import 'package:neuronavi/data/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final UserModel? _userModel;
  final FirestoreService _firestoreService;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;

  NotificationProvider(this._userModel, this._firestoreService) {
    if (_userModel != null) {
      // In a real app, you'd fetch notifications here.
      // fetchNotifications();
    }
  }
  // This is a placeholder for now. Full implementation requires a stream from Firestore.
  // void fetchNotifications() { ... }
}