import 'package:flutter/material.dart';
import 'package:tally_task/screens/counter.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
                                "Task Pending: 10",
                                style: TextStyle(
                                  fontFamily: 'Noto2',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Task Completed: 8",
                                style: TextStyle(
                                  fontFamily: 'Noto2',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              Text(
                                "Weekly Progress: 80%",
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
                              width:
                                  80, // Increased slightly to give text more room
                              height: 80,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value: 0.80,
                                strokeWidth: 12,
                              ),
                            ),
                            Text(
                              "80%",
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
                      // Navigation logic here
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
