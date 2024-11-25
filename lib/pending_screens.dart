import 'package:flutter/material.dart';
import 'package:gate_pass/all_entries.dart';
import 'package:gate_pass/rejected_screen.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

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
            onTap: () {
              // Already on Pending screen, do nothing
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
          color: Colors.blue, // Blue background for pending cards
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20, // Smaller profile picture
                    backgroundImage: AssetImage('assets/img_1.png'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mr James Godwin",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "Interview",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white70),
                        ),
                        Text(
                          "PRC002",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle approve action
                        },
                        child: Image.asset(
                          'assets/accept.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          // Handle reject action
                        },
                        child: Image.asset(
                          'assets/cancel.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
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
        color: const Color(0xFFEFF7FF), // Light blue background
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
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ],
          ),
          const Text(
            "Oct. 6, 2024",
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
          const Text(
            "8:00 -10:30am",
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ],
      ),
    );
  }
}


