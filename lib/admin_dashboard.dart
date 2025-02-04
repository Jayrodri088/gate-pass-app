import 'package:flutter/material.dart';
import 'package:gate_pass/all_entries.dart';
import 'package:gate_pass/check_in.dart';

class AdminDashboardScreen extends StatelessWidget {
  final String userId;
  const AdminDashboardScreen({super.key, required, required this.userId });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const SizedBox(height: 25),
              // Top section with welcome message and notification icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Welcome Admin",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Image.asset('assets/notification.png', width: 22),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Links section
              const Text(
                "Quick Links",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickLinkButton(
                    "Check In",
                    'assets/user-edit.png',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:  const Duration(milliseconds: 500),
                          pageBuilder:(context, animation, secondaryAnimation) => const CheckInScreen(),
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
                    },
                  ),
                  _quickLinkButton(
                    "All Entries",
                    'assets/entry.png',
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration:  const Duration(milliseconds: 500),
                          pageBuilder:(context, animation, secondaryAnimation) => const ApprovedScreen(),
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
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Horizontal scrollable Pending Requests section
              _sectionHeader("Pending Request"),
              const SizedBox(height: 10),
              SizedBox(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _pendingRequestCard(
                      name: "Mr James Godwin",
                      purpose: "Interview",
                      code: "PRC002",
                      profileImage: 'assets/img_1.png',
                      date: "Oct. 6, 2024",
                      time: "8:00 - 10:30am",
                      backgroundColor: Colors.blue[200],
                    ),
                    const SizedBox(width: 10),
                    _pendingRequestCard(
                      name: "Ms Sarah Green",
                      purpose: "Delivery",
                      code: "PRC003",
                      profileImage: 'assets/img_2.png',
                      date: "Oct. 7, 2024",
                      time: "9:00 - 11:00am",
                      backgroundColor: Colors.blue[200],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recent Visitors section with vertical scroll
              _sectionHeader("Recent Visitor's"),
              const SizedBox(height: 10),
              Column(
                children: [
                  _recentVisitorCard(
                    name: "Mr Emmanuel",
                    purpose: "Interview",
                    location: "COT Office",
                    code: "#002",
                    profileImage: 'assets/img_3.png',
                    date: "Oct. 6, 2024",
                    time: "8:00 - 10:30am",
                  ),
                  const SizedBox(height: 10),
                  _recentVisitorCard(
                    name: "Mrs Godwin",
                    purpose: "Interview",
                    location: "COT Office",
                    code: "#003",
                    profileImage: 'assets/img_2.png',
                    date: "Oct. 6, 2024",
                    time: "8:00 - 10:30am",
                  ),
                ],
              ),
              const SizedBox(height: 100), // Padding to prevent content overlap with nav bar
            ],
          ),
          // Floating Bottom Navigation Bar
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(child: _bottomNavigationBar()),
          ),
        ],
      ),
    );
  }

  // Widget for Quick Link button with onTap functionality
  Widget _quickLinkButton(String label, String iconPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section header widget
  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "See All",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  // Pending request card widget
  Widget _pendingRequestCard({
    required String name,
    required String purpose,
    required String code,
    required String profileImage,
    required String date,
    required String time,
    required Color? backgroundColor,
  }) {
    return Container(
      width: 318,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(profileImage),
            radius: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "$purpose\n$code",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/time.png',
                                width: 12,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Thursday, $date | $time",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: Image.asset('assets/accept.png'),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 28,
                height: 28,
                child: Image.asset('assets/cancel.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Recent visitor card widget
  Widget _recentVisitorCard({
    required String name,
    required String purpose,
    required String location,
    required String code,
    required String profileImage,
    required String date,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(profileImage),
            radius: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "$purpose\n$location",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/time.png',
                                width: 12,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$date | $time",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            code,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  // Bottom navigation bar widget
  Widget _bottomNavigationBar() {
    return Container(
      width: 220, // Smaller width to avoid full-screen width
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              // Handle Home button tap
            },
            child: Image.asset('assets/home_icon.png', width: 75, height: 29),
          ),
          GestureDetector(
            onTap: () {
              // Handle History button tap
            },
            child: Image.asset('assets/history.png', width: 29, height: 29),
          ),
          GestureDetector(
            onTap: () {
              // Handle Settings button tap
            },
            child: Image.asset('assets/setting.png', width: 29, height: 29),
          ),
        ],
      ),
    );
  }
}
