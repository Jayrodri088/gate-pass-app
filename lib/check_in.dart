// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gate_pass/identity_verify.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController appointmentController = TextEditingController();
  final TextEditingController intendToVisitController = TextEditingController();

  // Dropdown selections
  String? visitPurpose;
  String? reception;
  List<String> personalEffects = [];
  bool isLoading = false;

  // Options
  final List<String> purposeOptions = [
    'Interview',
    'Appointment',
    'Consultation',
    'Meeting',
    'Others'
  ];

  final List<String> effectOptions = [
    'Phone',
    'Laptop',
    'Purse',
    'Car',
    'Equipment',
    'Others'
  ];

  final List<String> receptionOptions = ['GOSS', 'Admin Block'];

  bool isFormComplete = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    final controllers = [
      nameController,
      emailController,
      addressController,
      phoneController,
      appointmentController,
      intendToVisitController
    ];

    for (var controller in controllers) {
      controller.addListener(_updateFormState);
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    appointmentController.dispose();
    intendToVisitController.dispose();
    super.dispose();
  }

  void _updateFormState() {
    setState(() {
      isFormComplete = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          addressController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          appointmentController.text.isNotEmpty &&
          intendToVisitController.text.isNotEmpty &&
          visitPurpose != null &&
          personalEffects.isNotEmpty &&
          reception != null;
    });
  }

  Future<void> _onUploadPressed() async {
    if (!isFormComplete) return;

    setState(() => isLoading = true);

    const String apiUrl =
        "http://10.10.2.34/gate-backend/checkin.php"; // Replace with actual URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": nameController.text,
        "email": emailController.text,
        "address": addressController.text,
        "phone": phoneController.text,
        "intend_to_visit": intendToVisitController.text,
        "visit_purpose": visitPurpose,
        "personal_effects": personalEffects, // List of items
        "appointment_details": appointmentController.text,
        "reception": reception,
      }),
    );

    setState(() => isLoading = false);

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success']) {

      _showMessage(responseData['message'], success: true);

      // Navigate to Identity Verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              IdentityVerificationScreen(code: responseData['code']),
        ),
      );
    } else {
      _showMessage(responseData['message'] ?? "Check-in failed.");
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          // Header (unchanged)
          Container(
            padding: const EdgeInsets.only(top: 30, bottom: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Center(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/logo.png'),
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Form Content
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

                  // Input Fields
                  _buildInputField("Enter your full name", nameController),
                  _buildInputField("Enter your Email", emailController),
                  _buildInputField("Enter your Address", addressController),
                  _buildInputField("Enter your Phone number", phoneController),

                  // Changed to TextField
                  _buildInputField(
                      "Who do you intend to visit?", intendToVisitController),

                  // Purpose of Visit Dropdown
                  _buildDropdownField(
                    "Purpose Of Visit",
                    purposeOptions,
                    (value) {
                      setState(() {
                        visitPurpose = value;
                        _updateFormState();
                      });
                    },
                  ),

                  // Personal Effects Multi-Select
                  _buildMultiSelectField(),

                  // Reception Dropdown
                  _buildDropdownField(
                    "Reception",
                    receptionOptions,
                    (value) {
                      setState(() {
                        reception = value;
                        _updateFormState();
                      });
                    },
                  ),

                  _buildInputField(
                      "Any Prior Appointments", appointmentController),

                  const SizedBox(height: 30),

                  // Upload ID Button (unchanged)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isFormComplete ? _onUploadPressed : null,
                      icon: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Icon(Icons.upload_file, color: Colors.white),
                      label: Text(
                        isLoading ? "Processing..." : "Upload ID",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFormComplete ? Colors.blue : Colors.grey,
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

  Widget _buildInputField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String hint, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        items: options
            .map((value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMultiSelectField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _showMultiSelectDialog(),
        child: InputDecorator(
          decoration: const InputDecoration(
            hintText: "Personal Effects",
            hintStyle: TextStyle(fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 4,
                children: personalEffects
                    .map((effect) => Chip(
                          label: Text(effect),
                          backgroundColor: Colors.blue.withOpacity(0.1),
                        ))
                    .toList(),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showMultiSelectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Personal Effects"),
        content: MultiSelectDialog(
          items: effectOptions,
          selectedItems: personalEffects,
          onConfirm: (selected) {
            setState(() {
              personalEffects = selected;
              _updateFormState();
            });
          },
        ),
      ),
    );
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onConfirm;

  const MultiSelectDialog({
    required this.items,
    required this.selectedItems,
    required this.onConfirm,
    super.key,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) => CheckboxListTile(
                title: Text(widget.items[index]),
                value: _tempSelected.contains(widget.items[index]),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _tempSelected.add(widget.items[index]);
                    } else {
                      _tempSelected.remove(widget.items[index]);
                    }
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.onConfirm(_tempSelected);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
