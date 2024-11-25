import 'package:flutter/material.dart';

class VisitorPassScreen extends StatelessWidget {
  const VisitorPassScreen({super.key});

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
              'assets/frame.png', // Background image path
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
                    const SizedBox(width: 48), // Placeholder for alignment
                  ],
                ),
              ),
              const SizedBox(height: 60), // Adjusted spacing for the card placement

              // Floating Visitor Card with Rounded Top Corners
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30), // Rounded corners on top
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top Blue Section with Curved Bottom Edge
                      ClipPath(
                        clipper: BlueTopCurveClipper(),
                        child: Container(
                          width: double.infinity,
                          height: 190,
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ), // Rounded top corners for the blue section
                          ),
                          child: const Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/img_1.png'), // Visitor's image path
                                radius: 35,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "MR JAMES",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
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

                      // Visitor Details Section in White
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow("ID NUMBER", "Prc1112"),
                            _buildDetailRow("EMAIL", "jamiee230@gmail.com"),
                            _buildDetailRow("ADDRESS", "Billing Way Oregun"),
                            _buildDetailRow("POV", "Interview"),
                            _buildDetailRow("PHONE NUMBER", "090123467"),
                            _buildDetailRow("Personal Effect", "Laptop"),
                            _buildDetailRow("Who do you Intend to Visit?", "090123467"),
                            _buildDetailRow("Any Prior Appointments", "Yes"),
                          ],
                        ),
                      ),

                      // Check-In Button at Bottom
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle check-in action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            child: const Text(
                              "Check In",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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

  // Helper method to build each detail row with vertical divider
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
