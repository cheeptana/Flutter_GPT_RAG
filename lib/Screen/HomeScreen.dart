import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // รายละเอียดการแจ้งเตือน
  final List<Map<String, String>> notifications = [
    {
      "title": "Registration Deadline Approaching",
      "department": "Department of Registration",
      "details": "The deadline for registration is next week. Please ensure you complete your registration."
    },
    {
      "title": "New Course Available",
      "department": "Student Development Department",
      "details": "A new course on Mobile App Development is now available for enrollment."
    },
    {
      "title": "Programming 1 Assignment Due",
      "department": "Programming 1 Class",
      "details": "Don't forget to submit your assignment by the end of the week."
    },
  ];

  void _showNotificationDetails(String title, String details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(details),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomeScreen"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card for student ID
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://example.com/profile.jpg'),
                      ),
                      SizedBox(width: 10),
                      // Student Information
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Doe",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("Student ID: 123456"),
                          Text("Email: johndoe@example.com"),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    "Department: Computer Science",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Enrollment Year: 2022",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Notifications Section
          const Text(
            "Notifications",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // List of notifications
          ...notifications.map((notification) {
            return ListTile(
              title: Text(notification["title"]!),
              subtitle: Text(notification["department"]!),
              onTap: () {
                _showNotificationDetails(notification["title"]!, notification["details"]!);
              },
            );
          }),
        ],
      ),
    );
  }
}