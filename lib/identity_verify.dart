// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gate_pass/visitors_pass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class IdentityVerificationScreen extends StatefulWidget {
  final String code;
  final String id;
  const IdentityVerificationScreen({super.key, required this.code, required this.id});

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  String? _activeStep; // Stores the currently active step ("Step 1" or "Step 2")
  final ImagePicker _picker = ImagePicker();
  final Map<String, File?> _capturedPhotos = {"Step 1": null, "Step 2": null};
  bool _isUploading = false;

  // Toggle step activation and open the camera on the second tap
  void _toggleStep(String step) async {
    setState(() {
      if (_activeStep == step) {
        // If already active, trigger camera
        _openCamera(step);
        _activeStep = null; // Reset active step after capturing photo
      } else {
        // Set active step to show glow and shadow
        _activeStep = step;
      }
    });
  }

  // Open the device camera and update state based on photo action
  Future<void> _openCamera(String step) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // If photo was successfully taken, mark step as completed
      final file = File(photo.path);
      final fileSize = (await file.length()) / 1024; // Convert bytes to KB

      print("📷 Captured Image - $step");
      print("🗂️ Path: ${file.path}");
      print("📏 Size: ${fileSize.toStringAsFixed(2)} KB");
      setState(() {
        _capturedPhotos[step] = file; // Mark this step as completed with a checkmark
      });
    } else {
      // If the user canceled, leave the arrow icon unchanged
      setState(() {
        _capturedPhotos[step] = null;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_capturedPhotos["Step 1"] == null || _capturedPhotos["Step 2"] == null) {
      _showMessage("Please capture both ID Card and Selfie before proceeding.");
      return;
    }

    setState(() => _isUploading = true);

    var url = Uri.parse("http://10.10.2.34/gate-backend/verify_id.php");
    var request = http.MultipartRequest("POST", url)
      ..fields['check_in_id'] = widget.id
      ..files.add(await http.MultipartFile.fromPath('id_card', _capturedPhotos["Step 1"]!.path))
      ..files.add(await http.MultipartFile.fromPath('selfie', _capturedPhotos["Step 2"]!.path));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var decodedResponse = jsonDecode(responseData);

    setState(() => _isUploading = false);

    if (response.statusCode == 200 && decodedResponse['success']) {
      _showMessage("Verification successful!", success: true);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              VisitorPassScreen(code: widget.code, id: widget.id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      _showMessage(decodedResponse['message'] ?? "Verification failed.");
      _showMessage(decodedResponse['error'] ?? "Verification failed.");
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
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
              isCompleted: _capturedPhotos["Step 2"] != null,
              onTap: () => _toggleStep("Step 1"),
            ),
            const SizedBox(height: 10),

            // Step 2 - Take a Selfie
            _buildStepCard(
              stepNumber: "Step 2",
              stepTitle: "Take a Selfie",
              iconPath: 'assets/selfie.png',
              isActive: _activeStep == "Step 2",
              isCompleted: _capturedPhotos["Step 2"] != null,
              onTap: () => _toggleStep("Step 2"),
            ),
            const SizedBox(height: 50),

            // Scan Now Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _uploadImages,
                  icon: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.upload_file, color: Colors.white),
                  label: Text(_isUploading ? "Uploading..." : "Upload Now", style: const TextStyle(color: Colors.white),),
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
            const SizedBox(height: 300), // Adjusted spacing after button

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
  }

      // Widget to build each step card
  Widget _buildStepCard({
    required String stepNumber,
    required String stepTitle,
    required String iconPath,
    required bool isActive,
    required bool isCompleted,
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
            // Display checkmark icon if completed, else arrow icon
            isCompleted
                ? Image.asset('assets/checkmark.png', width: 24, height: 24, color: Colors.blue)
                : const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                    size: 18,
                  ),
          ],
        ),
      ),
    );
  }

