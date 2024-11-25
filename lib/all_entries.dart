import 'package:flutter/material.dart';
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

class ApprovedScreen extends StatelessWidget {
  const ApprovedScreen({super.key});

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
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildVisitorCard();
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
              if (activeTab != "Approved") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ApprovedScreen()),
                );
              }
            },
          ),
          _buildTab(
            context,
            title: "Pending",
            isSelected: activeTab == "Pending",
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PendingScreen()),
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

  Widget _buildVisitorCard() {
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
              const Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/img_1.png'),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mr James Godwin",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Interview",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "#002",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDateAndTimeRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateAndTimeRow() {
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
          Row(
            children: [
              Image.asset(
                'assets/time.png',
                width: 16,
                height: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              const Text(
                "Thursday",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
          const Text(
            "Oct. 6, 2024",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          const Text(
            "8:00 -10:30am",
            style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
