import 'package:flutter/material.dart';
import 'package:tally_task/models/task_model.dart';
import 'package:tally_task/screens/counter.dart';
import 'package:tally_task/screens/login_screen.dart';
import 'package:tally_task/screens/tasks_screen.dart';
import 'package:tally_task/services/auth_storage.dart';
import 'package:tally_task/services/task_storage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<TaskItem> _tasks = <TaskItem>[];
  bool _isLoadingTasks = true;
  String _userName = 'there';

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final String? name = await AuthStorage.currentUserName();
    if (!mounted) {
      return;
    }
    setState(() {
      _userName = (name == null || name.trim().isEmpty) ? 'there' : name;
    });
  }

  Future<void> _loadTasks() async {
    final List<TaskItem> storedTasks = await TaskStorage.loadTasks();
    if (!mounted) {
      return;
    }
    setState(() {
      _tasks = storedTasks;
      _isLoadingTasks = false;
    });
  }

  Future<void> _saveTasks() async {
    await TaskStorage.saveTasks(_tasks);
  }

  int get _pendingCount {
    return _tasks
        .where((TaskItem task) => task.status == TaskStatus.pending)
        .length;
  }

  int get _urgentCount {
    return _tasks
        .where((TaskItem task) => task.status == TaskStatus.urgent)
        .length;
  }

  int get _completedCount {
    return _tasks
        .where((TaskItem task) => task.status == TaskStatus.done)
        .length;
  }

  double get _progressValue {
    if (_tasks.isEmpty) {
      return 0;
    }
    return _completedCount / _tasks.length;
  }

  int get _progressPercent {
    return (_progressValue * 100).round();
  }

  double get _progressCircleSize {
    return 70 + (_progressValue * 40);
  }

  Color get _progressColor {
    if (_progressValue < 0.4) {
      return const Color.fromARGB(255, 244, 67, 54);
    }
    if (_progressValue < 0.75) {
      return const Color.fromARGB(255, 255, 193, 7);
    }
    return const Color.fromARGB(255, 76, 175, 80);
  }

  Future<void> _openTasks() async {
    final List<TaskItem>? updatedTasks = await Navigator.push<List<TaskItem>>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TasksScreen(initialTasks: _tasks),
      ),
    );

    if (updatedTasks == null) {
      return;
    }

    setState(() {
      _tasks = updatedTasks;
    });
    await _saveTasks();
  }

  Future<void> _logout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout', style: TextStyle(fontFamily: 'Noto2')),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontFamily: 'Noto2'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await AuthStorage.logout();
    if (!mounted) {
      return;
    }

    await Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 141, 2, 196),

              const Color.fromARGB(255, 1, 40, 92),
              const Color.fromARGB(255, 10, 4, 65),
              const Color.fromARGB(255, 70, 0, 52),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: _isLoadingTasks
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 0),
                        child: ElevatedButton.icon(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              163,
                              214,
                              248,
                            ),
                            foregroundColor: const Color.fromARGB(
                              255,
                              70,
                              0,
                              52,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontFamily: 'Noto2',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 700),
                        builder:
                            (
                              BuildContext context,
                              double value,
                              Widget? child,
                            ) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                color: Color.fromARGB(255, 163, 214, 248),
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _userName,
                              style: const TextStyle(
                                fontFamily: 'Pacifico',
                                color: Color.fromARGB(255, 163, 214, 248),
                                fontSize: 32,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 450),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _urgentCount > 0
                              ? const Color.fromARGB(255, 255, 90, 90)
                              : Colors.white24,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tasks Added: ${_tasks.length}',
                                      style: TextStyle(
                                        fontFamily: 'Noto2',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Task Pending: $_pendingCount',
                                      style: TextStyle(
                                        fontFamily: 'Noto2',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Task Urgent: $_urgentCount',
                                      style: TextStyle(
                                        fontFamily: 'Noto2',
                                        color: _urgentCount > 0
                                            ? const Color.fromARGB(
                                                255,
                                                255,
                                                132,
                                                132,
                                              )
                                            : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Task Completed: $_completedCount',
                                      style: TextStyle(
                                        fontFamily: 'Noto2',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Weekly Progress: $_progressPercent%',
                                      style: TextStyle(
                                        fontFamily: 'Noto2',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 0,
                                  end: _progressValue,
                                ),
                                duration: const Duration(milliseconds: 550),
                                builder:
                                    (
                                      BuildContext context,
                                      double animatedValue,
                                      _,
                                    ) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 450,
                                            ),
                                            width: _progressCircleSize,
                                            height: _progressCircleSize,
                                            child: CircularProgressIndicator(
                                              color: _progressColor,
                                              value: animatedValue,
                                              strokeWidth: 12,
                                              backgroundColor: Colors.white24,
                                            ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 250,
                                            ),
                                            child: Text(
                                              '$_progressPercent%',
                                              key: ValueKey<int>(
                                                _progressPercent,
                                              ),
                                              style: TextStyle(
                                                fontFamily: 'Noto2',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.92, end: 1),
                          duration: const Duration(milliseconds: 420),
                          builder:
                              (
                                BuildContext context,
                                double value,
                                Widget? child,
                              ) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                          child: ElevatedButton(
                            onPressed: () {
                              _openTasks();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                163,
                                214,
                                248,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage('assets/task.png'),
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'My Tasks',
                                  style: TextStyle(
                                    fontFamily: 'Noto2',
                                    color: const Color.fromARGB(255, 70, 0, 52),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.92, end: 1),
                          duration: const Duration(milliseconds: 520),
                          builder:
                              (
                                BuildContext context,
                                double value,
                                Widget? child,
                              ) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Counter(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                163,
                                214,
                                248,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(
                                  image: AssetImage('assets/counter.png'),
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Counter',
                                  style: TextStyle(
                                    fontFamily: 'Noto2',
                                    color: const Color.fromARGB(255, 70, 0, 52),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
