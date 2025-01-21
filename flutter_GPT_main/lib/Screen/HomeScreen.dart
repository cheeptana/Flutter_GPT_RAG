import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_register_app/Screen/General_Modle_Screen.dart';
import 'package:flutter_register_app/ConnectAPI/api_keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Widget_UI/MassageWidget.dart';

class SpecificModelScreen2 extends StatefulWidget {
  const SpecificModelScreen2({super.key});

  @override
  State<SpecificModelScreen2> createState() => _SpecificModelScreen2State();
}

class _SpecificModelScreen2State extends State<SpecificModelScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EducChat-test"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('General Modle'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GeneralModleScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Specific Modle'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const ChatWidget(apiKey: GeminiConfig.apiKey),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.apiKey,
    super.key,
  });

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _picker = ImagePicker();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];

  String FAQjson = '';
  String Coursejson = '';
  String Allprompt = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initializeChatModel();
  }

  Future<void> _initializeChatModel() async {
    const prompt = '''
คุณจะรับบทเป็น "พี่เจ้าหน้าที่" ของมหาวิทยาลัยเทคโนโลยีราชมงคลตะวันออก วิทยาเขตจักพงษภูวนารถ 
ทำหน้าที่ให้คำแนะนำหรือช่วยแก้ปัญหาเกี่ยวกับการลงทะเบียนของนักศึกษา คุณจะเรียกผู้ใช้ว่า "น้องนักศึกษา" หรือ "น้อง" เพื่อให้รู้สึกเป็นกันเอง 
และตอบคำถามอย่างตรงไปตรงมา หากคำถามไม่เกี่ยวข้องกับการลงทะเบียนของมหาวิทยาลัยดังกล่าว 
หรือคุณไม่สามารถตอบได้ ให้แนะนำให้นักศึกษาติดต่อฝ่ายทะเบียนที่เบอร์ 02-277-2985 หรือเพจเฟซบุ๊ก 'วิทยาเขตจักรพงษภูวนารถ' 
นี่คือ JSON format
''';
    if (FAQjson == '' || Coursejson == '') {
      FAQjson = await getFaqData();
      Coursejson = await getCourseData();
      Allprompt = '''$prompt{
  "FAQ": $FAQjson,
  คุณสามารถดูข้อมูลรายวิชาได้จาก jSON formatนี้
  "Course": $Coursejson
}
''';
      print(Allprompt);
    }
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: widget.apiKey,
        systemInstruction: Content.system(Allprompt));
    _chat = _model.startChat();
  }

  Future<String> getFaqData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference faqCollection = firestore.collection('FAQ');

    QuerySnapshot querySnapshot = await faqCollection.get();
    List<Map<String, dynamic>> faqList = [];
    for (var doc in querySnapshot.docs) {
      faqList.add(doc.data() as Map<String, dynamic>);
    }
    return jsonEncode(faqList);
  }

  Future<String> getCourseData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference faqCollection = firestore.collection('Course');

    QuerySnapshot querySnapshot = await faqCollection.get();
    List<Map<String, dynamic>> faqList = [];
    for (var doc in querySnapshot.docs) {
      faqList.add(doc.data() as Map<String, dynamic>);
    }
    return jsonEncode(faqList);
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldDecoration = InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: 'Enter a prompt...',
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.apiKey.isNotEmpty
                ? _generatedContent.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Images/EducChatLogo.png',
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'ยินดีต้อนรับสู่ EducChat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'คุณสามารถถามคำถามเกี่ยวกับมหาวิทยาลัยราชมงคลตะวันออกวิทยาเขตจักรพงษภูวนารถได้ที่นี่',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemBuilder: (context, idx) {
                          final content = _generatedContent[idx];
                          return MessageWidget(
                            text: content.text,
                            image: content.image,
                            isFromUser: content.fromUser,
                          );
                        },
                        itemCount: _generatedContent.length,
                      )
                : ListView(
                    children: const [
                      Text(
                        'No API key found. Please provide an API Key using '
                        "'--dart-define' to set the 'API_KEY' declaration.",
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: _textFieldFocus,
                    decoration: textFieldDecoration,
                    controller: _textController,
                    onSubmitted: _sendChatMessage,
                  ),
                ),
                const SizedBox.square(dimension: 15),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _stopSpeakText();
                      final recognizedText = await _listenForSpeech();
                      if (recognizedText != null) {
                        _sendChatMessage(recognizedText);
                      }
                    },
                    icon: const Icon(Icons.keyboard_voice),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendImagePrompt(_textController.text);
                    },
                    icon: Icon(
                      Icons.image,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (!_loading)
                  IconButton(
                    onPressed: () {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _listenForSpeech() async {
    final bool available = await _speechToText.initialize();
    if (!available) {
      print('Speech recognition not available.');
      return null;
    }

    String? recognizedText;

    _speechToText.listen(
      localeId: 'th-TH',
      onResult: (val) {
        if (val.recognizedWords.isNotEmpty) {
          recognizedText = val.recognizedWords;
          print('Recognized text: $recognizedText');
        } else {
          print('No recognized text.');
        }
        _stopListenForSpeech();
      },
    );

    await Future.delayed(const Duration(seconds: 5));
    _stopListenForSpeech();
    return recognizedText;
  }

  Future<void> _stopListenForSpeech() async {
    await _speechToText.stop();
  }

  Future<void> _sendImagePrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final content = [
          Content.multi([
            TextPart(message),
            DataPart('image/jpeg', bytes),
          ])
        ];
        _generatedContent.add((
          image: Image.file(File(image.path)),
          text: message,
          fromUser: true
        ));

        var response = await _model.generateContent(content);
        var text = response.text;
        _generatedContent.add((image: null, text: text, fromUser: false));

        if (text == null) {
          _showError('No response from API.');
          return;
        } else {
          setState(() {
            _loading = false;
            _scrollDown();
          });
        }
      } else {
        _showError('No image selected.');
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: message, fromUser: true));
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;
      _generatedContent.add((image: null, text: text, fromUser: false));
      _speakText(text!);

      setState(() {
        _loading = false;
        _scrollDown();
      });
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _speakText(String texts) async {
    await _tts.setLanguage('th-TH');
    await _tts.setSpeechRate(1);
    await _tts.speak(texts);
  }

  Future<void> _stopSpeakText() async {
    await _tts.stop();
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
