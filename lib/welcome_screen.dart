import 'package:flutter/material.dart';
import 'package:gate_pass/onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
          children: [
            const Spacer(flex: 2), // Pushes content down slightly

            // Welcome text
            const Text(
              "Welcome to LWPL Security Checkpoint",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            
            // Subtext
            const Text(
              "This app is designed to streamline the check-in and check-out process for visitors at our facility. It provides the admin with an efficient tool to manage and track visitor access securely.",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            
            const SizedBox(height: 80),

            // Centered image
            Center(
              child: Image.asset(
                'assets/welcome_img.png',
                width: 250,
                height: 250,
              ),
            ),

            const Spacer(flex: 3), // Pushes buttons towards the bottom
            
            // Sign Up button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OnboardingScreen(), ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Sign In button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Add Sign In action
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.blue),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ),
            
            const Spacer(flex: 1), // Adds space below buttons
          ],
        ),
      ),
    );
  }
}
