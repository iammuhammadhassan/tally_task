// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:tally_task/screens/home_page.dart';
import 'package:tally_task/screens/signup_screen.dart';
import 'package:tally_task/services/auth_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoggingIn = false;

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    final bool isValidUser = await AuthStorage.loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (!isValidUser) {
      setState(() {
        _isLoggingIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password. Please sign up first.',
            style: TextStyle(fontFamily: 'Noto2'),
          ),
          backgroundColor: Color.fromARGB(255, 170, 35, 35),
        ),
      );
      return;
    }

    // Wait for the drop animation to complete (1500ms total)
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) {
      return;
    }

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoggingIn = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              builder: (BuildContext context, double value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 26 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage('assets/planning.png'),
                            height: 100,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tally Task",
                                  style: TextStyle(
                                    fontFamily: 'Pacifico',
                                    color: const Color.fromARGB(
                                      255,
                                      163,
                                      214,
                                      248,
                                    ),
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Count What Matters",
                                  style: TextStyle(
                                    fontFamily: "Noto2",
                                    color: const Color.fromARGB(
                                      255,
                                      204,
                                      55,
                                      167,
                                    ),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),
                      Text(
                        'E-MAIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Noto2',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Noto2',
                          fontSize: 18,
                        ),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Enter your email',
                          labelStyle: TextStyle(fontFamily: 'Noto2'),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Noto2',
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Noto2',
                          fontSize: 18,
                        ),
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter your password',
                          labelStyle: const TextStyle(fontFamily: 'Noto2'),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Noto2',
                        ),
                      ),

                      const SizedBox(height: 40),
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: _isLoggingIn ? 1 : 0,
                          ),
                          duration: const Duration(milliseconds: 1500),
                          builder:
                              (
                                BuildContext context,
                                double value,
                                Widget? child,
                              ) {
                                // Phase 1: Shrink (0 to 0.3)
                                final double shrinkPhase = (value * 3).clamp(
                                  0,
                                  1,
                                );
                                final double scale = 1 - (shrinkPhase * 0.7);

                                // Phase 2: Drop (0.2 to 1) - starts after slight delay
                                final double dropPhase = ((value - 0.2) * 1.25)
                                    .clamp(0, 1);
                                final double dropOffset = dropPhase * 300;
                                final double opacity = 1 - dropPhase;

                                return Transform.scale(
                                  scale: scale,
                                  child: Transform.translate(
                                    offset: Offset(0, dropOffset),
                                    child: Opacity(
                                      opacity: opacity.clamp(0, 1),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _isLoggingIn ? null : _handleLogin,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isLoggingIn
                                  ? const SizedBox(
                                      key: ValueKey<String>('login-loading'),
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      key: ValueKey<String>('login-text'),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Noto2',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Noto2',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder<void>(
                                  transitionDuration: const Duration(
                                    milliseconds: 420,
                                  ),
                                  reverseTransitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  pageBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                      ) {
                                        return const SignupScreen();
                                      },
                                  transitionsBuilder:
                                      (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOut,
                                          ),
                                          child: SlideTransition(
                                            position:
                                                Tween<Offset>(
                                                  begin: const Offset(0.12, 0),
                                                  end: Offset.zero,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOutCubic,
                                                  ),
                                                ),
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Noto',
                                color: const Color.fromARGB(255, 238, 15, 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
