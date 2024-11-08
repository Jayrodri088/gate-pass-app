import 'package:flutter/material.dart';

class CheckInScreen extends StatelessWidget {
  const CheckInScreen({super.key});

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
                  _buildInputField("Enter your full name"),
                  _buildInputField("Enter your Email"),
                  _buildInputField("Enter your Address"),
                  _buildInputField("Enter your Phone number"),
                  _buildDropdownField("Who do you Intend to Visit?"),
                  _buildDropdownField("Personal Effect"),
                  _buildDropdownField("Purpose Of Visit"),
                  _buildInputField("Any Prior Appointments"),

                  const SizedBox(height: 30),

                  // Upload ID Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Add upload functionality
                      },
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      label: const Text("Upload ID", style: TextStyle(color: Colors.white,),),
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
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Input Fields
  Widget _buildInputField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Increase vertical spacing
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjusted padding for alignment
        ),
      ),
    );
  }

  // Widget for Dropdown Fields
  Widget _buildDropdownField(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Increase vertical spacing
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15, height: 1,),
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjusted padding for alignment
        ),
        items: <String>['Option 1', 'Option 2', 'Option 3']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
            .toList(),
        onChanged: (value) {
          // Handle dropdown selection
        },
      ),
    );
  }
}
