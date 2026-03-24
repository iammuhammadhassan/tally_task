import 'package:flutter/material.dart';
import 'package:tally_task/models/task_model.dart';
import 'package:tally_task/screens/counter.dart';
import 'package:tally_task/screens/tasks_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<TaskItem> _tasks = <TaskItem>[];

  int get _pendingCount {
    return _tasks
        .where((TaskItem task) => task.status != TaskStatus.done)
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Welcome to Tally Task",
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  color: const Color.fromARGB(255, 163, 214, 248),
                  fontSize: 35,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
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
                        Stack(
                          alignment:
                              Alignment.center, // Keeps the text in the middle
                          children: [
                            SizedBox(
                              width: _progressCircleSize,
                              height: _progressCircleSize,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value: _progressValue,
                                strokeWidth: 12,
                              ),
                            ),
                            Text(
                              '$_progressPercent%',
                              style: TextStyle(
                                fontFamily: 'Noto2',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openTasks();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 163, 214, 248),
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
                          "My Tasks",
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Counter(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 163, 214, 248),
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
                          "Counter",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
