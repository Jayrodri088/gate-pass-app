import 'package:flutter/material.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  String? _activeStep; // Stores the currently active step ("Step 1" or "Step 2")

  void _toggleStep(String step) {
    setState(() {
      if (_activeStep == step) {
        // Double-tap action: navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NextScreen(), // Replace with actual next screen
          ),
        );
      } else {
        // Set active step to glow and shadow
        _activeStep = step;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        centerTitle: true,
        title: const Text(
          "Identity Verification",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // Spacing under AppBar

            // Instructions text
            const Text(
              "For your security, please confirm your identity. "
              "Follow the steps below:",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),

            // Step 1 - Identity Card
            _buildStepCard(
              stepNumber: "Step 1",
              stepTitle: "Identity Card",
              iconPath: 'assets/id.png',
              isActive: _activeStep == "Step 1",
              onTap: () => _toggleStep("Step 1"),
            ),
            const SizedBox(height: 10),

            // Step 2 - Take a Selfie
            _buildStepCard(
              stepNumber: "Step 2",
              stepTitle: "Take a Selfie",
              iconPath: 'assets/selfie.png',
              isActive: _activeStep == "Step 2",
              onTap: () => _toggleStep("Step 2"),
            ),
            const SizedBox(),

            // Scan Now Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle scan action
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text("Scan Now", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Reduced spacing after button

            // Note Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Note ***",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "You can only upload your Driver’s License, NIN, "
                "Passport, or Voter’s Card.",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each step card
  Widget _buildStepCard({
    required String stepNumber,
    required String stepTitle,
    required String iconPath,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: isActive ? Colors.blue : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 40, height: 40), // Icon
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stepTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for the next screen
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Screen")),
      body: const Center(child: Text("This is the next screen")),
    );
  }
}
