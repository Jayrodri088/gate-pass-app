import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gate_pass/all_entries.dart';
import 'package:gate_pass/rejected_screen.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  List<dynamic> pendingRequests = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    final url = Uri.parse("http://10.10.2.34/gate-backend/pending.php");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        setState(() {
          pendingRequests = data['data'];
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

  Future<void> _updateStatus(String idNumber, String status) async {
    final url = Uri.parse("http://10.10.2.34/gate-backend/status_update.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_number": idNumber,
          "status": status,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        _showMessage("Status updated to $status successfully!", success: true);
        _fetchPendingRequests(); // Refresh list
      } else {
        _showMessage(responseData['message'] ?? "Failed to update status.");
      }
    } catch (e) {
      _showMessage("Error updating status.");
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "All Entries",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(context, activeTab: "Pending"),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Pending Request",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(child: Text("Failed to load requests"))
                    : pendingRequests.isEmpty
                        ? const Center(child: Text("No pending requests"))
                        : ListView.builder(
                            itemCount: pendingRequests.length,
                            itemBuilder: (context, index) {
                              return _buildVisitorCard(pendingRequests[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, {required String activeTab}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(
            context,
            title: "Approved",
            isSelected: activeTab == "Approved",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ApprovedScreen()),
              );
            },
          ),
          _buildTab(
            context,
            title: "Pending",
            isSelected: activeTab == "Pending",
            onTap: () {},
          ),
          _buildTab(
            context,
            title: "Rejected",
            isSelected: activeTab == "Rejected",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RejectedScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildVisitorCard(Map<String, dynamic> visitor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: visitor['selfie_path'] != null
                        ? NetworkImage("http://10.10.2.34/gate-backend/${visitor['selfie_path']}".replaceFirst('./', ''))
                        : const AssetImage('assets/img_1.png') as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor['full_name'] ?? "N/A",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          visitor['visit_purpose'] ?? "N/A",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          visitor['id_number'] ?? "N/A",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _updateStatus(visitor['id_number'], "approved"),
                        child: Image.asset('assets/accept.png', width: 30, height: 30),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () => _updateStatus(visitor['id_number'], "rejected"),
                        child: Image.asset('assets/cancel.png', width: 30, height: 30),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDateAndTimeRow(visitor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeRow(Map<String, dynamic> visitor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(visitor['day'] ?? "N/A", style: const TextStyle(color: Colors.blue, fontSize: 12)),
          Text(visitor['date'] ?? "N/A", style: const TextStyle(color: Colors.blue, fontSize: 12)),
          Text(visitor['time'] ?? "N/A", style: const TextStyle(color: Colors.blue, fontSize: 12)),
        ],
      ),
    );
  }
}
