import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CRUDScreen extends StatefulWidget {
  const CRUDScreen({super.key});

  @override
  State<CRUDScreen> createState() => _CRUDScreenState();
}

class _CRUDScreenState extends State<CRUDScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addData() {
    FirebaseFirestore.instance.collection('academic_years').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'year': DateTime.now().year,
    });
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'หัวข้อ'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'รายละเอียด'),
            ),
            ElevatedButton(
              onPressed: _addData,
              child: const Text('เพิ่มข้อมูล'),
            ),
            // แสดงข้อมูลที่มีอยู่
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('academic_years').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index]['title']),
                        subtitle: Text(data[index]['description']),
                        // เพิ่มปุ่มสำหรับแก้ไขและลบข้อมูล
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}