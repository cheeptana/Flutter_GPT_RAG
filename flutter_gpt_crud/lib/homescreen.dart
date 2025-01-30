import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_gpt_crud/loginscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
      ),
      body: const Center(
        child: Text('เข้าสู่ระบบสำเร็จ'),
      ),
    );
  }
}

class CRUDscreen extends StatefulWidget {
  const CRUDscreen({super.key});

  @override
  _CRUDscreenState createState() => _CRUDscreenState();
}

class _CRUDscreenState extends State<CRUDscreen> {
  String _selectedData = 'FAQ';

  final List<String> _dataList = ['FAQ', 'Course'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addData() {
    if (_selectedData == 'FAQ') {
      showDialog(
        context: context,
        builder: (context) {
          final questionController = TextEditingController();
          final answerController = TextEditingController();

          return AlertDialog(
            title: const Text('เพิ่มคำถาม'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'คำถาม',
                  ),
                ),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'คำตอบ',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('เพิ่ม'),
                onPressed: () {
                  _firestore.collection('FAQ').add({
                    'คำถาม': questionController.text,
                    'คำตอบ': answerController.text,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          final idController = TextEditingController();
          final nameController = TextEditingController();
          final descriptionController = TextEditingController();
          final creditController = TextEditingController();
          final prerequisitesController = TextEditingController();
          final dayController = TextEditingController();
          final startTimeController = TextEditingController();
          final endTimeController = TextEditingController();

          return AlertDialog(
            title: const Text('เพิ่มรายวิชา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'รหัสรายวิชา',
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อรายวิชา',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียดรายวิชา',
                  ),
                ),
                TextField(
                  controller: creditController,
                  decoration: const InputDecoration(
                    labelText: 'หน่วยกิตรายวิชา',
                  ),
                ),
                TextField(
                  controller: prerequisitesController,
                  decoration: const InputDecoration(
                    labelText: 'รายวิชาที่จำเป็นต้องเรียนก่อน',
                  ),
                ),
                TextField(
                  controller: dayController,
                  decoration: const InputDecoration(
                    labelText: 'วันที่เปิดสอน',
                  ),
                ),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(
                    labelText: 'เวลาเริ่มคลาส',
                  ),
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(
                    labelText: 'เวลาจบคลาส',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('เพิ่ม'),
                onPressed: () {
                  _firestore.collection('Course').add({
                    'id': idController.text,
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'credit': creditController.text,
                    'prerequisites': prerequisitesController.text,
                    'schedule': {
                      'day': dayController.text,
                      'startTime': startTimeController.text,
                      'endTime': endTimeController.text,
                    },
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _editData(String id) {
  if (_selectedData == 'FAQ') {
    _firestore.collection('FAQ').doc(id).get().then((value) {
      final questionController = TextEditingController(text: value['คำถาม']);
      final answerController = TextEditingController(text: value['คำตอบ']);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('แก้ไขคำถาม'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    labelText: 'คำถาม',
                  ),
                ),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'คำตอบ',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('แก้ไข'),
                onPressed: () {
                  _firestore.collection('FAQ').doc(id).update({
                    'คำถาม': questionController.text,
                    'คำตอบ': answerController.text,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  } else {
    _firestore.collection('Course').doc(id).get().then((value) {
      final nameController = TextEditingController(text: value['name']);
      final descriptionController = TextEditingController(text: value['description']);
      final creditController = TextEditingController(text: value['credit']);
      final prerequisitesController = TextEditingController(text: value['prerequisites']);
      final dayController = TextEditingController(text: value['schedule']['day']);
      final startTimeController = TextEditingController(text: value['schedule']['startTime']);
      final endTimeController = TextEditingController(text: value['schedule']['endTime']);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('แก้ไขรายวิชา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อรายวิชา',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'รายละเอียดรายวิชา',
                  ),
                ),
                TextField(
                  controller: creditController,
                  decoration: const InputDecoration(
                    labelText: 'หน่วยกิตรายวิชา',
                  ),
                ),
                TextField(
                  controller: prerequisitesController,
                  decoration: const InputDecoration(
                    labelText: 'รายวิชาที่จำเป็นต้องเรียนก่อน',
                  ),
                ),
                TextField(
                  controller: dayController,
                  decoration: const InputDecoration(
                    labelText: 'วันที่เปิดสอน',
                  ),
                ),
                TextField(
                  controller: startTimeController,
                  decoration: const InputDecoration(
                    labelText: 'เวลาเริ่มคลาส',
                  ),
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(
                    labelText: 'เวลาจบคลาส',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('แก้ไข'),
                onPressed: () {
                  _firestore.collection('Course').doc(id).update({
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'credit': creditController.text,
                    'prerequisites': prerequisitesController.text,
                    'schedule': {
                      'day': dayController.text,
                      'startTime': startTimeController.text,
                      'endTime': endTimeController.text,
                    },
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }
}

  void _deleteData(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ลบข้อมูล'),
          content: const Text('คุณแน่ใจว่าต้องการลบข้อมูลนี้?'),
          actions: [
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                if (_selectedData == 'FAQ') {
                  _firestore.collection('FAQ').doc(id).delete();
                } else {
                  _firestore.collection('Course').doc(id).delete();
                }
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
        title: const Text('จัดการข้อมูล'),
      ),
      body: Column(
        children: [
          DropdownButton(
            value: _selectedData,
            onChanged: (value) {
              setState(() {
                _selectedData = value as String;
              });
            },
            items: _dataList.map((data) {
              return DropdownMenuItem(
                value: data,
                child: Text(data),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection(_selectedData).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (_selectedData == 'FAQ') {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['คำถาม']),
                          subtitle: Text(snapshot.data!.docs[index]['คำตอบ']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editData(snapshot.data!.docs[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteData(snapshot.data!.docs[index].id);
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListTile(
                          title: Text(snapshot.data!.docs[index]['name']),
                          subtitle:
                              Text(snapshot.data!.docs[index]['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editData(snapshot.data!.docs[index].id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteData(snapshot.data!.docs[index].id);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addData();
        },
        tooltip: 'เพิ่มข้อมูล',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Homescreen(),
    CRUDscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            // ออกจากระบบทันที
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Loginscreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'CRUD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'ออกจากระบบ',
          ),
        ],
      ),
    );
  }
}
