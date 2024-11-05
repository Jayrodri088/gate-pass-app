import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gate_pass/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0; // Initial opacity
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Create an AnimationController for a 4-second animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {
          _opacity = _controller.value; // Update opacity with controller's value
        });
      });

    // Start the animation
    _controller.forward();

    // Set a timer to navigate to the next screen after the animation completes
    Timer(const Duration(seconds: 6), () {
      // Navigate to the next screen after fade-out animation
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()), // Replace with your actual next screen
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity, // Set opacity based on the controller
          duration: const Duration(seconds: 4), // Duration for the fade effect
          child: Image.asset(
            'assets/full_logo.png', // Path to the logo image file
            width: 150, // Adjust width as needed
            height: 150, // Adjust height as needed
          ),
        ),
      ),
    );
  }
}

// class NextScreen extends StatelessWidget {
//   const NextScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Next Screen'), // Replace with your actual next screen content
//       ),
//     );
//   }
// }
