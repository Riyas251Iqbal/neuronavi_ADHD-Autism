class NotificationModel {
  final String id;
  final String toUserId;
  final String title;
  final String body;
  final DateTime createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.toUserId,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return NotificationModel(
      id: documentId,
      toUserId: map['toUserId'],
      title: map['title'],
      body: map['body'],
      createdAt: map['createdAt'].toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'toUserId': toUserId,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }
}