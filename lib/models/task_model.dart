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

  final String id;
  final String title;
  final String description;
  TaskStatus status;
  final DateTime createdAt;
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
