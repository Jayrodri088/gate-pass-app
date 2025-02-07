// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gate_pass/pending_screens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(), // No role provided (fetch all notifications)
    );
  }
}

class NotificationScreen extends StatefulWidget {
  final String? role; // Optional role parameter

  const NotificationScreen({super.key, this.role});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> todayNotifications = [];
  List<Map<String, dynamic>> yesterdayNotifications = [];
  List<Map<String, dynamic>> twoDaysAgoNotifications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchNotifications(widget.role);
  }

  Future<void> fetchNotifications(String? role) async {
    const String url = "http://10.10.2.34/gate-backend/get_notifications.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            role != null ? {"role": role} : {}), // Send role only if provided
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          classifyNotifications(data['data']);
        } else {
          setState(() {
            errorMessage = data['message'];
          });
        }
      } else {
        setState(() {
          errorMessage = "Server error. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to connect to server.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void classifyNotifications(List<dynamic> notifications) {
    List<Map<String, dynamic>> today = [];
    List<Map<String, dynamic>> yesterday = [];
    List<Map<String, dynamic>> older = [];

    for (var notification in notifications) {
      Map<String, dynamic> formattedNotification = {
        "id": notification["id"],
        "message": notification["message"],
        "time": notification["formatted_time"],
        "image":
            notification["selfie_path"] ?? "https://via.placeholder.com/150",
        "read": notification["read_status"] == 1,
      };

      if (notification["formatted_time"] == "Yesterday") {
        yesterday.add(formattedNotification);
      } else if (notification["formatted_time"].contains("mins") ||
          notification["formatted_time"].contains("hours") ||
          notification["formatted_time"].contains("seconds")) {
        today.add(formattedNotification);
      } else {
        older.add(formattedNotification);
      }
    }

    setState(() {
      todayNotifications = today;
      yesterdayNotifications = yesterday;
      twoDaysAgoNotifications = older;
    });
  }

  Future<void> markAllAsRead() async {
    const String url = "http://10.10.2.34/gate-backend/read_notifications.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mark_all": true}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            for (var notification in todayNotifications) {
              notification["read"] = true;
            }
          });
        }
      }
    } catch (e) {
      print("Error marking all as read: $e");
    }
  }

  Future<void> markAsRead(
      int index, List<Map<String, dynamic>> notifications) async {
    const String url = "http://10.10.2.34/gate-backend/read_notifications.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"notification_id": notifications[index]["id"]}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            notifications[index]["read"] = true;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PendingScreen(role: widget.role,), // Replace with your screen
            ),
          );
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  Future<void> deleteNotification(int index, List<Map<String, dynamic>> notifications) async {
    const String url = "http://10.10.2.34/gate-backend/delete_notifications.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"notification_id": notifications[index]["id"]}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            notifications.removeAt(index);
          });
        }
      }
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenPadding = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "All Notifications",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : ListView(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 10),
                    children: [
                      _buildSectionTitleWithMarkAll("Today"),
                      ..._buildNotifications(todayNotifications),
                      const Divider(),
                      _buildSectionTitle("Yesterday"),
                      ..._buildNotifications(yesterdayNotifications),
                      const Divider(),
                      _buildSectionTitle("Over 2 Days Ago"),
                      ..._buildNotifications(twoDaysAgoNotifications),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitleWithMarkAll(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: markAllAsRead,
            child: const Text(
              "Mark All as Read",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotifications(List<Map<String, dynamic>> notifications) {
    return notifications.isNotEmpty
        ? notifications.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> notification = entry.value;

            return Card(
              color: notification["read"] ? Colors.white : Colors.blue.shade50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(notification["image"]),
                          radius: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notification["message"],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          notification["time"],
                          style:
                              const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => markAsRead(index, notifications),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("View",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                deleteNotification(index, notifications),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: const Text("Delete",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList()
        : [
            const Center(
                child: Text("No notifications available",
                    style: TextStyle(color: Colors.grey)))
          ];
  }
}
