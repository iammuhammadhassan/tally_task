enum TaskStatus { pending, urgent, done }

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    this.description = '',
    this.status = TaskStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskItem.fromTask(TaskItem other) {
    return TaskItem(
      id: other.id,
      title: other.title,
      description: other.description,
      status: other.status,
      createdAt: other.createdAt,
    );
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final String rawStatus = (json['status'] as String?) ?? 'pending';
    final TaskStatus status = TaskStatus.values.firstWhere(
      (TaskStatus item) => item.name == rawStatus,
      orElse: () => TaskStatus.pending,
    );

    return TaskItem(
      id:
          (json['id'] as String?) ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      status: status,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? ''),
    );
  }

  final String id;
  final String title;
  final String description;
  TaskStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.urgent:
        return 'Urgent';
      case TaskStatus.done:
        return 'Done';
    }
  }

  int get priority {
    switch (this) {
      case TaskStatus.urgent:
        return 0;
      case TaskStatus.pending:
        return 1;
      case TaskStatus.done:
        return 2;
    }
  }
}
