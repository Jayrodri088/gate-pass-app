import 'package:flutter/material.dart';
import 'package:gate_pass/onboarding_screen.dart';
import 'package:gate_pass/sign_up.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ), // Space at the top

            // Title text
            const Text(
              "Streamlined Security Process",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),

            // Description text with light blue background
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 245, 246, 247), // Light blue background color
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Enjoy smooth, real-time verification at the entrance. Visitor's details are securely managed for a quick, efficient entry experience at Loveworld Publishing.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 100),

            // Centered illustration image
            Center(
              child: Image.asset(
                'assets/onboarding_img 2.png', // Replace with your actual image path
                width: 200,
                height: 200,
              ),
            ),

            const Spacer(flex: 3), // Pushes buttons towards the bottom

            // Row for Skip and Next buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/back_icon.png', // Replace with your actual icon path
                    width: 16,
                    height: 16,
                  ),
                  label: const Text(
                    "Back",
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                // Next button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                      );
                  },
                  icon: Image.asset(
                    'assets/next_icon.png', // Replace with your actual icon path
                    width: 16,
                    height: 16,
                  ),
                  label: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 1), // Space below the buttons
          ],
        ),
      ),
    );
  }
}
