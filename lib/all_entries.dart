import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gate_pass/check_out.dart';
import 'package:http/http.dart' as http;
import 'package:gate_pass/pending_screens.dart';
import 'package:gate_pass/rejected_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ApprovedScreen(),
    );
  }
}

class ApprovedScreen extends StatefulWidget {
  final String? role; // Role is optional
  const ApprovedScreen({super.key, this.role});

  @override
  State<ApprovedScreen> createState() => _ApprovedScreenState();
}

class _ApprovedScreenState extends State<ApprovedScreen> {
  List<dynamic> approvedRequests = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchApprovedRequests();
  }

  Future<void> _fetchApprovedRequests() async {
    final baseUrl = "http://10.10.2.34/gate-backend/approved.php";
    final url = widget.role != null ? Uri.parse("$baseUrl?role=${widget.role}") : Uri.parse(baseUrl);

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        setState(() {
          approvedRequests = data['data'];
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
          _buildTabBar(context, activeTab: "Approved"),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Recent Visitor’s",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(child: Text("Failed to load requests"))
                    : approvedRequests.isEmpty
                        ? const Center(child: Text("No approved requests"))
                        : ListView.builder(
                            itemCount: approvedRequests.length,
                            itemBuilder: (context, index) {
                              return _buildVisitorCard(approvedRequests[index]);
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
            onTap: () {},
          ),
          _buildTab(
            context,
            title: "Pending",
            isSelected: activeTab == "Pending",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PendingScreen(role: widget.role)),
              );
            },
          ),
          _buildTab(
            context,
            title: "Rejected",
            isSelected: activeTab == "Rejected",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RejectedScreen(role: widget.role)),
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
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to a new screen with visitor details
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckOutScreen(idnumber: visitor['id_number']),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: visitor['selfie_path'] != null
                          ? NetworkImage("http://10.10.2.34/gate-backend/${visitor['selfie_path']}".replaceFirst('./', ''))
                          : const AssetImage('assets/img_1.png') as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          visitor['full_name'] ?? "N/A",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          visitor['visit_purpose'] ?? "N/A",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    visitor['id_number'] ?? "N/A",
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
        color: const Color.fromARGB(255, 193, 214, 235),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(visitor['day'] ?? "N/A", style: const TextStyle(color: Colors.black, fontSize: 12)),
          Text(visitor['date'] ?? "N/A", style: const TextStyle(color: Colors.black, fontSize: 12)),
          Text(visitor['time'] ?? "N/A", style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
