class Subtask {
  final String id;
  final String title;
  bool isCompleted;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class TaskModel {
  final String id;
  final String title;
  final String parentId;
  final String childId;
  final List<Subtask> subtasks;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.parentId,
    required this.childId,
    required this.subtasks,
    required this.createdAt,
  });

  double get progress {
    if (subtasks.isEmpty) return 0.0;
    final completedCount = subtasks.where((s) => s.isCompleted).length;
    return completedCount / subtasks.length;
  }
  
  bool get isCompleted {
    return progress == 1.0;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      title: map['title'],
      parentId: map['parentId'],
      childId: map['childId'],
      subtasks: (map['subtasks'] as List)
          .map((subtaskMap) => Subtask.fromMap(subtaskMap))
          .toList(),
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'parentId': parentId,
      'childId': childId,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
      'createdAt': createdAt,
    };
  }
}