import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tally_task/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animateIn = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _animateIn = true;
      });
    });

    Timer(const Duration(milliseconds: 1900), () {
      if (!mounted) {
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 650),
            opacity: _animateIn ? 1 : 0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 650),
              scale: _animateIn ? 1 : 0.88,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/planning.png'),
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tally Task',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      color: Color.fromARGB(255, 163, 214, 248),
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Count What Matters',
                    style: TextStyle(
                      fontFamily: 'Noto2',
                      color: Color.fromARGB(255, 204, 55, 167),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
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
}
