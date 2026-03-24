import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tally_task/models/task_model.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks_v1';

  static Future<List<TaskItem>> loadTasks() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? raw = preferences.getString(_tasksKey);

    if (raw == null || raw.isEmpty) {
      return <TaskItem>[];
    }

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(TaskItem.fromJson)
          .toList();
    } catch (_) {
      return <TaskItem>[];
    }
  }

  static Future<void> saveTasks(List<TaskItem> tasks) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String raw = jsonEncode(
      tasks.map((TaskItem task) => task.toJson()).toList(),
    );
    await preferences.setString(_tasksKey, raw);
  }
}
