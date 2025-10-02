enum UserRole { parent, child }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? linkedAccountId; // Parent links to child, child links to parent

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.linkedAccountId,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: (data['role'] == 'parent') ? UserRole.parent : UserRole.child,
      linkedAccountId: data['linkedAccountId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role == UserRole.parent ? 'parent' : 'child',
      'linkedAccountId': linkedAccountId,
    };
  }
}