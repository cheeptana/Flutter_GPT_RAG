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
        title: Text('หน้าหลัก'),
      ),
      body: Center(
        child: Text('เข้าสู่ระบบสำเร็จ'),
      ),
    );
  }
}

class CRUDscreen extends StatefulWidget {
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
          final _questionController = TextEditingController();
          final _answerController = TextEditingController();

          return AlertDialog(
            title: Text('เพิ่มคำถาม'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'คำถาม',
                  ),
                ),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'คำตอบ',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('เพิ่ม'),
                onPressed: () {
                  _firestore.collection('FAQ').add({
                    'คำถาม': _questionController.text,
                    'คำตอบ': _answerController.text,
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
          final _idController = TextEditingController();
          final _nameController = TextEditingController();
          final _descriptionController = TextEditingController();
          final _creditController = TextEditingController();
          final _prerequisitesController = TextEditingController();
          final _dayController = TextEditingController();
          final _startTimeController = TextEditingController();
          final _endTimeController = TextEditingController();

          return AlertDialog(
            title: Text('เพิ่มรายวิชา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'รหัสรายวิชา',
                  ),
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อรายวิชา',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียดรายวิชา',
                  ),
                ),
                TextField(
                  controller: _creditController,
                  decoration: InputDecoration(
                    labelText: 'หน่วยกิตรายวิชา',
                  ),
                ),
                TextField(
                  controller: _prerequisitesController,
                  decoration: InputDecoration(
                    labelText: 'รายวิชาที่จำเป็นต้องเรียนก่อน',
                  ),
                ),
                TextField(
                  controller: _dayController,
                  decoration: InputDecoration(
                    labelText: 'วันที่เปิดสอน',
                  ),
                ),
                TextField(
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: 'เวลาเริ่มคลาส',
                  ),
                ),
                TextField(
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: 'เวลาจบคลาส',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('เพิ่ม'),
                onPressed: () {
                  _firestore.collection('Course').add({
                    'id': _idController.text,
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'credit': _creditController.text,
                    'prerequisites': _prerequisitesController.text,
                    'schedule': {
                      'day': _dayController.text,
                      'startTime': _startTimeController.text,
                      'endTime': _endTimeController.text,
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
      final _questionController = TextEditingController(text: value['คำถาม']);
      final _answerController = TextEditingController(text: value['คำตอบ']);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไขคำถาม'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'คำถาม',
                  ),
                ),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'คำตอบ',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('แก้ไข'),
                onPressed: () {
                  _firestore.collection('FAQ').doc(id).update({
                    'คำถาม': _questionController.text,
                    'คำตอบ': _answerController.text,
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
      final _nameController = TextEditingController(text: value['name']);
      final _descriptionController = TextEditingController(text: value['description']);
      final _creditController = TextEditingController(text: value['credit']);
      final _prerequisitesController = TextEditingController(text: value['prerequisites']);
      final _dayController = TextEditingController(text: value['schedule']['day']);
      final _startTimeController = TextEditingController(text: value['schedule']['startTime']);
      final _endTimeController = TextEditingController(text: value['schedule']['endTime']);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('แก้ไขรายวิชา'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อรายวิชา',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'รายละเอียดรายวิชา',
                  ),
                ),
                TextField(
                  controller: _creditController,
                  decoration: InputDecoration(
                    labelText: 'หน่วยกิตรายวิชา',
                  ),
                ),
                TextField(
                  controller: _prerequisitesController,
                  decoration: InputDecoration(
                    labelText: 'รายวิชาที่จำเป็นต้องเรียนก่อน',
                  ),
                ),
                TextField(
                  controller: _dayController,
                  decoration: InputDecoration(
                    labelText: 'วันที่เปิดสอน',
                  ),
                ),
                TextField(
                  controller: _startTimeController,
                  decoration: InputDecoration(
                    labelText: 'เวลาเริ่มคลาส',
                  ),
                ),
                TextField(
                  controller: _endTimeController,
                  decoration: InputDecoration(
                    labelText: 'เวลาจบคลาส',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('ยกเลิก'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('แก้ไข'),
                onPressed: () {
                  _firestore.collection('Course').doc(id).update({
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'credit': _creditController.text,
                    'prerequisites': _prerequisitesController.text,
                    'schedule': {
                      'day': _dayController.text,
                      'startTime': _startTimeController.text,
                      'endTime': _endTimeController.text,
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
          title: Text('ลบข้อมูล'),
          content: Text('คุณแน่ใจว่าต้องการลบข้อมูลนี้?'),
          actions: [
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ลบ'),
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
        title: Text('จัดการข้อมูล'),
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
                child: Text(data),
                value: data,
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
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editData(snapshot.data!.docs[index].id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
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
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _editData(snapshot.data!.docs[index].id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
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
                  return Center(
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
        child: Icon(Icons.add),
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
    Homescreen(),
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
              MaterialPageRoute(builder: (context) => Loginscreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
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
