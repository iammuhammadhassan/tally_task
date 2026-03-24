import 'package:flutter/material.dart';
import 'package:tally_task/models/task_model.dart';
import 'package:tally_task/services/task_storage.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, this.initialTasks = const <TaskItem>[]});

  final List<TaskItem> initialTasks;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final List<TaskItem> _tasks;
  TaskStatus? _selectedFilter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tasks = widget.initialTasks
        .map((TaskItem task) => TaskItem.fromTask(task))
        .toList();
  }

  List<TaskItem> _tasksForResult() {
    return _tasks.map((TaskItem task) => TaskItem.fromTask(task)).toList();
  }

  Future<void> _persistTasks() async {
    await TaskStorage.saveTasks(_tasksForResult());
  }

  List<TaskItem> get _visibleTasks {
    final List<TaskItem> filtered = _tasks.where((TaskItem task) {
      final bool statusMatch =
          _selectedFilter == null || task.status == _selectedFilter;
      final String combinedText = '${task.title} ${task.description}'
          .toLowerCase();
      final bool queryMatch = combinedText.contains(_searchQuery.toLowerCase());
      return statusMatch && queryMatch;
    }).toList();

    filtered.sort((TaskItem a, TaskItem b) {
      final int byPriority = a.status.priority.compareTo(b.status.priority);
      if (byPriority != 0) {
        return byPriority;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  int _countByStatus(TaskStatus status) {
    return _tasks.where((TaskItem task) => task.status == status).length;
  }

  Future<void> _showAddTaskDialog() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    TaskStatus selectedStatus = TaskStatus.pending;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task', style: TextStyle(fontFamily: 'Noto2')),
          content: StatefulBuilder(
            builder:
                (
                  BuildContext context,
                  void Function(void Function()) setLocalState,
                ) {
                  return Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Task title',
                            labelStyle: TextStyle(fontFamily: 'Noto2'),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a task title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Description (optional)',
                            labelStyle: TextStyle(fontFamily: 'Noto2'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<TaskStatus>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            labelStyle: TextStyle(fontFamily: 'Noto2'),
                          ),
                          items: TaskStatus.values
                              .map(
                                (TaskStatus status) =>
                                    DropdownMenuItem<TaskStatus>(
                                      value: status,
                                      child: Text(
                                        status.label,
                                        style: const TextStyle(
                                          fontFamily: 'Noto2',
                                        ),
                                      ),
                                    ),
                              )
                              .toList(),
                          onChanged: (TaskStatus? value) {
                            if (value != null) {
                              setLocalState(() {
                                selectedStatus = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  setState(() {
                    _tasks.add(
                      TaskItem(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        status: selectedStatus,
                      ),
                    );
                  });
                  _persistTasks();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateTaskStatus(TaskItem task, TaskStatus newStatus) {
    setState(() {
      task.status = newStatus;
    });
    _persistTasks();
  }

  void _deleteTask(TaskItem task) {
    final int removedIndex = _tasks.indexWhere((TaskItem t) => t.id == task.id);
    setState(() {
      _tasks.removeWhere((TaskItem t) => t.id == task.id);
    });
    _persistTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${task.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              final int safeIndex = removedIndex.clamp(0, _tasks.length);
              _tasks.insert(safeIndex, task);
            });
            _persistTasks();
          },
        ),
      ),
    );
  }

  void _clearDoneTasks() {
    setState(() {
      _tasks.removeWhere((TaskItem task) => task.status == TaskStatus.done);
    });
    _persistTasks();
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return const Color.fromARGB(255, 255, 193, 7);
      case TaskStatus.urgent:
        return const Color.fromARGB(255, 244, 67, 54);
      case TaskStatus.done:
        return const Color.fromARGB(255, 76, 175, 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TaskItem> visibleTasks = _visibleTasks;

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _tasksForResult());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'My Tasks',
            style: TextStyle(fontFamily: 'Pacifico'),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _tasksForResult());
            },
          ),
          actions: <Widget>[
            IconButton(
              tooltip: 'Clear completed tasks',
              onPressed: _countByStatus(TaskStatus.done) == 0
                  ? null
                  : _clearDoneTasks,
              icon: const Icon(Icons.cleaning_services),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddTaskDialog,
          label: const Text('Add Task', style: TextStyle(fontFamily: 'Noto2')),
          icon: const Icon(Icons.add),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 141, 2, 196),
                Color.fromARGB(255, 1, 40, 92),
                Color.fromARGB(255, 10, 4, 65),
                Color.fromARGB(255, 70, 0, 52),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 72, 16, 16),
              child: Column(
                children: <Widget>[
                  _buildSummary(),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (String value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Noto2',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Noto2',
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      filled: true,
                      // ignore: deprecated_member_use
                      fillColor: Colors.white.withOpacity(0.15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                  const SizedBox(height: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: visibleTasks.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              key: ValueKey<int>(visibleTasks.length),
                              itemCount: visibleTasks.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (BuildContext context, int index) {
                                final TaskItem task = visibleTasks[index];
                                return Dismissible(
                                  key: ValueKey<String>(task.id),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (_) => _deleteTask(task),
                                  background: Container(
                                    padding: const EdgeInsets.only(right: 20),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: _buildTaskCard(task),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _statusCountTile('Pending', _countByStatus(TaskStatus.pending)),
          _statusCountTile('Urgent', _countByStatus(TaskStatus.urgent)),
          _statusCountTile('Done', _countByStatus(TaskStatus.done)),
        ],
      ),
    );
  }

  Widget _statusCountTile(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Noto2',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontFamily: 'Noto2',
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final List<_FilterOption> filters = <_FilterOption>[
      _FilterOption(label: 'All', status: null),
      ...TaskStatus.values.map(
        (TaskStatus status) =>
            _FilterOption(label: status.label, status: status),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((_FilterOption option) {
        final bool selected = _selectedFilter == option.status;
        return ChoiceChip(
          label: Text(
            option.label,
            style: TextStyle(
              fontFamily: 'Noto2',
              color: selected
                  ? const Color.fromARGB(255, 70, 0, 52)
                  : Colors.white,
            ),
          ),
          selected: selected,
          selectedColor: const Color.fromARGB(255, 163, 214, 248),
          // ignore: deprecated_member_use
          backgroundColor: Colors.white.withOpacity(0.15),
          onSelected: (_) {
            setState(() {
              _selectedFilter = option.status;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTaskCard(TaskItem task) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 12,
            height: 62,
            decoration: BoxDecoration(
              color: _statusColor(task.status),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto2',
                    decoration: task.status == TaskStatus.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (task.description.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Noto2',
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(task.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.status.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto2',
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<TaskStatus>(
            iconColor: Colors.white,
            onSelected: (TaskStatus status) {
              _updateTaskStatus(task, status);
            },
            itemBuilder: (BuildContext context) {
              return TaskStatus.values
                  .map(
                    (TaskStatus status) => PopupMenuItem<TaskStatus>(
                      value: status,
                      child: Text(status.label),
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final String title = _tasks.isEmpty ? 'No tasks yet' : 'No matching tasks';
    final String subtitle = _tasks.isEmpty
        ? 'Tap Add Task to create your first task.'
        : 'Try another filter or search keyword.';

    return Center(
      child: Container(
        key: const ValueKey<String>('empty-state'),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.task_alt, color: Colors.white70, size: 48),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto2',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Noto2',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOption {
  _FilterOption({required this.label, required this.status});

  final String label;
  final TaskStatus? status;
}
