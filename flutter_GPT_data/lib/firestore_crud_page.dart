import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreCRUDPage extends StatefulWidget {
  @override
  _FirestoreCRUDPageState createState() => _FirestoreCRUDPageState();
}

class _FirestoreCRUDPageState extends State<FirestoreCRUDPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  String? _selectedDocumentId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ CRUD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'คำถาม'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'คำตอบ'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _createFAQ,
                child: Text('Create'),
              ),
              ElevatedButton(
                onPressed: _updateFAQ,
                child: Text('Update'),
              ),
              ElevatedButton(
                onPressed: _deleteFAQ,
                child: Text('Delete'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('FAQ').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    return ListTile(
                      title: Text(document['คำถาม']),
                      subtitle: Text(document['คำตอบ']),
                      onTap: () {
                        setState(() {
                          _selectedDocumentId = document.id;
                          _questionController.text = document['คำถาม'];
                          _answerController.text = document['คำตอบ'];
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _createFAQ() async {
    await _firestore.collection('FAQ').add({
      'คำถาม': _questionController.text,
      'คำตอบ': _answerController.text,
    });
    _clearControllers();
  }

  void _updateFAQ() async {
    if (_selectedDocumentId != null) {
      await _firestore.collection('FAQ').doc(_selectedDocumentId).update({
        'คำถาม': _questionController.text,
        'คำตอบ': _answerController.text,
      });
      _clearControllers();
    }
  }

  void _deleteFAQ() async {
    if (_selectedDocumentId != null) {
      await _firestore.collection('FAQ').doc(_selectedDocumentId).delete();
      _clearControllers();
    }
  }

  void _clearControllers() {
    _questionController.clear();
    _answerController.clear();
    setState(() {
      _selectedDocumentId = null;
    });
  }
}