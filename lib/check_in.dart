import 'package:flutter/material.dart';
import 'package:gate_pass/identity_verify.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // Controllers for each input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController appointmentController = TextEditingController();

  // Dropdown selections
  String? visitIntent;
  String? personalEffect;
  String? visitPurpose;

  bool isFormComplete = false;

  @override
  void initState() {
    super.initState();
    // Adding listeners to track changes in input fields
    nameController.addListener(_updateFormState);
    emailController.addListener(_updateFormState);
    addressController.addListener(_updateFormState);
    phoneController.addListener(_updateFormState);
    appointmentController.addListener(_updateFormState);
  }

  @override
  void dispose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    appointmentController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {
      // Check if all fields have values
      isFormComplete = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          appointmentController.text.isNotEmpty &&
          visitIntent != null &&
          personalEffect != null &&
          visitPurpose != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Blue background for header
      body: Column(
        children: [
          // Blue header with logo
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Go back
                      },
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png', // Update to your actual logo path
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // White container with form content
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                children: [
                  const Text(
                    "Check In",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Input fields
                  _buildInputField("Enter your full name", nameController),
                  _buildInputField("Enter your Email", emailController),
                  _buildInputField("Enter your Address", addressController),
                  _buildInputField("Enter your Phone number", phoneController),
                  _buildDropdownField("Who do you Intend to Visit?", (value) {
                    setState(() {
                      visitIntent = value;
                      _updateFormState();
                    });
                  }),
                  _buildDropdownField("Personal Effect", (value) {
                    setState(() {
                      personalEffect = value;
                      _updateFormState();
                    });
                  }),
                  _buildDropdownField("Purpose Of Visit", (value) {
                    setState(() {
                      visitPurpose = value;
                      _updateFormState();
                    });
                  }),
                  _buildInputField("Any Prior Appointments", appointmentController),

                  const SizedBox(height: 30),

                  // Upload ID Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isFormComplete ? _onUploadPressed : null,
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text("Upload ID", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormComplete ? Colors.blue : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onUploadPressed() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration:  const Duration(milliseconds: 500),
        pageBuilder:(context, animation, secondaryAnimation) => const IdentityVerificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Start from the right side
          const end = Offset.zero; // End at the center
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // Widget for Input Fields
  Widget _buildInputField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      ),
    );
  }

  // Widget for Dropdown Fields
  Widget _buildDropdownField(String hint, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        items: <String>['Option 1', 'Option 2', 'Option 3']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
