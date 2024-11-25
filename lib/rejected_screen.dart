import 'package:flutter/material.dart';
import 'package:gate_pass/all_entries.dart';
import 'package:gate_pass/pending_screens.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

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
          _buildTabBar(context, activeTab: "Cancelled"),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Visitor’s",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Delete All",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PendingScreen()),
              );
            },
          ),
          _buildTab(
            context,
            title: "Cancelled",
            isSelected: activeTab == "Cancelled",
            onTap: () {
              // Already on Cancelled screen, do nothing
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
          color: const Color(0xFFE3F2FD), // Light blue background for cancelled cards
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
                          color: Colors.black),
                    ),
                    Text(
                      "Interview",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black54),
                    ),
                    Text(
                      "COT Office",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle delete action
                },
                child: Image.asset(
                  'assets/cancel.png',
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


