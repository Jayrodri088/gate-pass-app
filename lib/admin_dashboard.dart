import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gate_pass/notification.dart';
import 'package:http/http.dart' as http;
import 'package:gate_pass/all_entries.dart';
import 'package:gate_pass/check_in.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String userId;

  const AdminDashboardScreen({super.key, required this.userId});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

ValueNotifier<bool> refreshDashboard = ValueNotifier(false);

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String fullName = "";
  String role = "";
  bool canSeeCheckIn = false;
  bool isLoading = true;
  int unreadNotifications = 0;
  List<dynamic> pendingRequests = [];
  List<dynamic> recentVisitors = [];

  @override
  void initState() {
  super.initState();
  _fetchDashboardData();

  // Listen for refresh trigger from Identity Verification Screen
  refreshDashboard.addListener(() {
    if (refreshDashboard.value) {
      _fetchDashboardData();
      refreshDashboard.value = false; // Reset trigger after refresh
    }
  });
}

  Future<void> _fetchDashboardData() async {
    const String apiUrl = "http://10.10.2.34/gate-backend/dashboard.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": widget.userId}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        setState(() {
          fullName = responseData['full_name'];
          role = responseData['role'];
          canSeeCheckIn = role == "gate";
          pendingRequests = responseData['pending_entries'];
          recentVisitors = responseData['recent_visitors'];
        });
        // Fetch unread notifications after successfully fetching dashboard data
        _fetchUnreadNotifications();
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUnreadNotifications() async {
    String apiUrl = "http://10.10.2.34/gate-backend/count_notifications.php";

    // Append role if available
    if (role.isNotEmpty) {
      apiUrl += "?role=$role";
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        setState(() {
          unreadNotifications = responseData['unread_count'];
        });
      }
    } catch (e) {
      print("Error fetching unread notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome $fullName",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: Image.asset('assets/notification.png',
                                  width: 22),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationScreen(
                                              role: role,
                                            ))).then((_) {
                                  _fetchUnreadNotifications(); // Refresh count when returning
                                });
                              },
                            ),
                            if (unreadNotifications > 0)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadNotifications.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Quick Links
                    const Text("Quick Links",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (canSeeCheckIn)
                          _quickLinkButton("Check In", 'assets/user-edit.png',
                              onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckInScreen()));
                          }),
                        _quickLinkButton("All Entries", 'assets/entry.png',
                            onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ApprovedScreen(
                                        role: role,
                                      )));
                        }),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Pending Requests
                    _sectionHeader("Pending Requests"),
                    _buildEntryList(pendingRequests),

                    const SizedBox(height: 30),

                    // Recent Visitors
                    _sectionHeader("Recent Visitors"),
                    _buildEntryList(recentVisitors),

                    const SizedBox(height: 100),
                  ],
                ),

          // Floating Bottom Navigation Bar
          // Positioned(
          //   bottom: 20,
          //   left: 0,
          //   right: 0,
          //   child: Center(child: _bottomNavigationBar()),
          // ),
        ],
      ),
    );
  }

  Widget _quickLinkButton(String label, String iconPath,
      {required VoidCallback onTap}) {
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

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: const Text("See All", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildEntryList(List<dynamic> entries) {
    return entries.isEmpty
        ? const Center(child: Text("No entries"))
        : Column(
            children: entries.map((entry) {
              return _recentVisitorCard(
                name: entry['full_name'],
                purpose: entry['visit_purpose'],
                location: entry['location'], // Reception as location
                code: entry['combined_code'], // id + code
                profileImage: entry['profile'],
                date: entry['formatted_date'], // "Oct. 6, 2024"
                time: entry['formatted_time'], // "8:00 AM"
              );
            }).toList(),
          );
  }

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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: profileImage != " "
                ? NetworkImage("http://10.10.2.34/gate-backend/$profileImage"
                    .replaceFirst('./', ''))
                : const AssetImage('assets/img_1.png') as ImageProvider,
            radius: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("$purpose\n$location",
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Image.asset('assets/time.png',
                                  width: 12, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text("$date | $time",
                                  style: const TextStyle(fontSize: 12)),
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
          Text(code,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue)),
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
