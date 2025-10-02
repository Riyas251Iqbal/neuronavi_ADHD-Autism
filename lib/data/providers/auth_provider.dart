// lib/data/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neuronavi/data/models/user_model.dart';
import 'package:neuronavi/data/services/auth_service.dart';
import 'package:neuronavi/data/services/firestore_service.dart';

enum AuthStatus { uninitialized, authenticated, authenticating, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthStatus _status = AuthStatus.uninitialized;
  User? _firebaseUser;
  UserModel? _userModel;
  String? _errorMessage;

  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider(this._authService, this._firestoreService) {
    print('AuthProvider: Initializing...');
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    print('AuthProvider: Auth state changed - User: ${user?.email ?? "null"}');
    if (user == null) {
      _status = AuthStatus.unauthenticated;
      _firebaseUser = null;
      _userModel = null;
      print('AuthProvider: Status set to unauthenticated');
    } else {
      _firebaseUser = user;
      print('AuthProvider: Fetching user model for ${user.uid}');
      _userModel = await _firestoreService.getUser(user.uid);
      if (_userModel != null) {
        print('AuthProvider: User model loaded - Role: ${_userModel!.role}');
        _status = AuthStatus.authenticated;
      } else {
        print('AuthProvider: WARNING - User model not found in Firestore!');
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? linkedAccountEmail,
  }) async {
    print('\n=== AuthProvider: Starting Sign Up ===');
    print('Name: $name');
    print('Email: $email');
    print('Role: $role');
    print('Linked Email: ${linkedAccountEmail ?? "none"}');
    
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Create Firebase Auth user
      print('Step 1: Creating Firebase Auth user...');
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      
      if (user == null) {
        print('ERROR: Firebase Auth user creation failed');
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Failed to create account. Email may already be in use.';
        notifyListeners();
        return false;
      }
      print('SUCCESS: Firebase Auth user created - UID: ${user.uid}');

      // Step 2: Handle parent linking to child (if applicable)
      String? linkedId;
      if (role == UserRole.parent) {
        print('Step 2: Parent account - checking for child link...');
        if (linkedAccountEmail != null && linkedAccountEmail.isNotEmpty) {
          print('Searching for child with email: $linkedAccountEmail');
          final childUser = await _firestoreService.findUserByEmail(linkedAccountEmail);
          
          if (childUser == null) {
            print('ERROR: Child account not found!');
            print('Cleaning up - signing out created user...');
            await _authService.signOut();
            _status = AuthStatus.unauthenticated;
            _errorMessage = 'Child account not found. Please ask your child to create their account first.';
            notifyListeners();
            return false;
          }
          
          linkedId = childUser.uid;
          print('SUCCESS: Found child account - UID: $linkedId');
        } else {
          print('No child email provided - skipping link');
        }
      } else {
        print('Step 2: Child account - no linking needed');
      }

      // Step 3: Create UserModel
      print('Step 3: Creating UserModel...');
      _userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
        linkedAccountId: linkedId,
      );
      print('UserModel created: ${_userModel!.toMap()}');

      // Step 4: Save to Firestore
      print('Step 4: Saving user to Firestore...');
      await _firestoreService.setUser(_userModel!);
      print('SUCCESS: User saved to Firestore');

      // Step 5: Create achievements for child
      if (role == UserRole.child) {
        print('Step 5: Creating initial achievements...');
        await _firestoreService.setInitialAchievements(user.uid);
        print('SUCCESS: Initial achievements created');
      } else {
        print('Step 5: Skipping achievements (parent account)');
      }

      // Step 6: Update status
      _firebaseUser = user;
      _status = AuthStatus.authenticated;
      print('=== Sign Up Complete - SUCCESS ===\n');
      notifyListeners();
      return true;
      
    } catch (e) {
      print('=== ERROR during sign up: $e ===');
      _status = AuthStatus.unauthenticated;
      _errorMessage = 'Registration failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    print('\n=== AuthProvider: Starting Sign In ===');
    print('Email: $email');
    
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Sign in with Firebase Auth
      print('Step 1: Signing in with Firebase Auth...');
      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      
      if (user == null) {
        print('ERROR: Firebase Auth sign in failed');
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Invalid email or password.';
        notifyListeners();
        return false;
      }
      print('SUCCESS: Firebase Auth sign in - UID: ${user.uid}');

      // Step 2: Fetch user data from Firestore
      print('Step 2: Fetching user data from Firestore...');
      _userModel = await _firestoreService.getUser(user.uid);
      
      if (_userModel == null) {
        print('ERROR: User data not found in Firestore!');
        await _authService.signOut();
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'User data not found. Please contact support.';
        notifyListeners();
        return false;
      }
      
      print('SUCCESS: User data loaded - Role: ${_userModel!.role}');
      
      // Step 3: Update status
      _firebaseUser = user;
      _status = AuthStatus.authenticated;
      print('=== Sign In Complete - SUCCESS ===\n');
      notifyListeners();
      return true;
      
    } catch (e) {
      print('=== ERROR during sign in: $e ===');
      _status = AuthStatus.unauthenticated;
      _errorMessage = 'Login failed: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    print('AuthProvider: Signing out...');
    await _authService.signOut();
    _status = AuthStatus.unauthenticated;
    _firebaseUser = null;
    _userModel = null;
    _errorMessage = null;
    notifyListeners();
    print('AuthProvider: Sign out complete');
  }
}