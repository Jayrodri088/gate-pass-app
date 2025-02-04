import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisitorPassScreen extends StatefulWidget {
  final String code;
  final String id;

  const VisitorPassScreen({super.key, required this.code, required this.id});

  @override
  State<VisitorPassScreen> createState() => _VisitorPassScreenState();
}

class _VisitorPassScreenState extends State<VisitorPassScreen> {
  Map<String, dynamic>? visitorData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchVisitorDetails();
  }

  Future<void> _fetchVisitorDetails() async {
    final url = Uri.parse(
        "http://10.10.2.34/gate-backend/vistor_pass.php?id=${widget.id}");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        setState(() {
          visitorData = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/frame.png',
              fit: BoxFit.cover,
              height: 220,
            ),
          ),
          // Content
          Column(
            children: [
              const SizedBox(height: 40),
              // AppBar with Back Arrow and Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    const Text(
                      "Visitor's Pass",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Floating Visitor Card
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : hasError
                          ? const Center(
                              child: Text("Failed to load visitor details."))
                          : Column(
                              children: [
                                // Top Blue Section
                                ClipPath(
                                  clipper: BlueTopCurveClipper(),
                                  child: Container(
                                    width: double.infinity,
                                    height: 190,
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 30),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: visitorData?[
                                                      'selfie_path'] !=
                                                  null
                                              ? NetworkImage(
                                                  "http://10.10.2.34/gate-backend/${visitorData?['selfie_path']}"
                                                      .replaceFirst('./', ''))
                                              : const AssetImage(
                                                      'assets/img_1.png')
                                                  as ImageProvider,
                                          radius: 35,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          visitorData?['full_name'] ?? "N/A",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          "Visitor",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Visitor Details Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow("ID NUMBER",
                                          visitorData?['id_number'] ?? "N/A"),
                                      _buildDetailRow("EMAIL",
                                          visitorData?['email'] ?? "N/A"),
                                      _buildDetailRow("ADDRESS",
                                          visitorData?['address'] ?? "N/A"),
                                      _buildDetailRow(
                                          "POV",
                                          visitorData?['visit_purpose'] ??
                                              "N/A"),
                                      _buildDetailRow("PHONE NUMBER",
                                          visitorData?['phone'] ?? "N/A"),
                                      _buildDetailRow(
                                          "Personal Effect",
                                          _formatPersonalEffects(visitorData?[
                                              'personal_effects'])),
                                      _buildDetailRow(
                                          "Who do you Intend to Visit?",
                                          visitorData?['intend_to_visit'] ??
                                              "N/A"),
                                      _buildDetailRow(
                                          "Any Prior Appointments",
                                          visitorData?['appointment_details'] ??
                                              "N/A"),
                                    ],
                                  ),
                                ),

                                // Check-In Button
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 20),
                                //   child: SizedBox(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.8,
                                //     child: ElevatedButton(
                                //       onPressed: () {
                                //         // Handle check-in action
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: Colors.blue,
                                //         padding: const EdgeInsets.symmetric(
                                //             vertical: 14),
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(30),
                                //         ),
                                //         textStyle:
                                //             const TextStyle(fontSize: 16),
                                //       ),
                                //       child: const Text(
                                //         "Check In",
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Formats the personal effects list
  String _formatPersonalEffects(dynamic effects) {
    if (effects is List) {
      return effects.join(", "); // Convert list to comma-separated string
    } else if (effects is String) {
      return effects
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll("\"", ""); // Cleanup string if received as JSON string
    }
    return "N/A"; // Default if the field is missing
  }

  // Helper method to build each detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the Curved Bottom Edge of the Blue Section
class BlueTopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
