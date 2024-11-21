import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_register_app/Screen/General_Modle_Screen.dart';
import 'package:flutter_register_app/ConnectAPI/api_keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Widget_UI/MassageWidget.dart';

class SpecificModelScreen extends StatefulWidget {
  const SpecificModelScreen({super.key});

  @override
  State<SpecificModelScreen> createState() => _SpecificModelScreenState();
}

class _SpecificModelScreenState extends State<SpecificModelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Specific modle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneralModleScreen()),
              );
            },
          ),
        ],
      ),
      body: const ChatWidget(apiKey: apiKey),
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
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  static const prompt = '''
งานของคุณคือการสนทนากับลูกค้าที่ต้องการความช่วยเหลือเกี่ยวกับมหาวิทยาลัยราชมงคลตะวันออกวิทยาเขตจักรพงษภูวนารถ 
หากลูกค้าถามคำถามที่ไม่เกี่ยวข้องกับมหาวิทยาลัย คุณต้องตอบกลับไปว่าคุณมีความรู้เฉพาะในเรื่องมหาวิทยาลัยราชมงคลตะวันออกวิทยาเขตจักรพงษภูวนารถเท่านั้น
คุณจะเป็นแชทบอท AI ชื่อ "ครูสมศรี" และคุณจะเรียกตัวเองด้วยชื่อนี้ คุณต้องตอบคำถามอย่างสมบูรณ์แบบ
หากมีคำถามใดที่คุณไม่สามารถตอบได้หรือไม่แน่ใจ คุณสามารถแนะนำให้ติดต่อศูนย์บริการทางโทรศัพท์ 02277-2985 หรือเพจเฟซบุ๊ก วิทยาเขตจักรพงษภูวนารถเพื่อขอรายละเอียดเพิ่มเติม
นี่คือ JSON format 
JSON:
[  
  {
   "คำถาม": "มหาวิทยาลัยมีสาขาอะไรบ้าง"
   "คำตอบ": "มหาวิทยาลัยมีสาขา การบัญชี การตลาด การจัดการ เศรษศาสตร์ เทคโนโลยีสารสนเทศ"
  },
  {
    "คำถาม": "เปิดเทอม ปีการศึกษา 2567 เมื่อไหร่"
    "คำตอบ": "วันที่ 3 กค 2567"
   },
   {
    "คำถาม": "เปิดรับสมัครชั้นอะไรบ้าง"
    "คำตอบ": "ปริญญาตรี โท และ เอก"
   }
]
หากผู้ใช้ถามคำถามที่ไม่เกี่ยวข้องกับมหาวิทยาลัยราชมงคลตะวันออกวิทยาเขตจักรพงษภูวนารถ 
คุณต้องตอบว่า คุณรู้เพียงแค่เรื่องของมหาวิทยาลัยราชมงคลตะวันออกวิทยาเขตจักรพงษภูวนารถเท่านั้น
''';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: widget.apiKey,
      systemInstruction: Content.system(prompt)
    );
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
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
            child: apiKey.isNotEmpty
                ? ListView.builder(
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
                      _sendChatMessage(recognizedText!);
                    },
                    icon: const Icon(Icons.keyboard_voice),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                if (!_loading)
                  IconButton(
                    onPressed: !_loading
                        ? () async {
                            _sendImagePrompt(_textController.text);
                          }
                        : null,
                    icon: Icon(
                      Icons.image,
                      color: _loading
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
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
  final SpeechToText speechToText = SpeechToText();

  final bool available = await speechToText.initialize();
  if (!available) {
    print('Speech recognition not available.');
    return null;
  }

  String? recognizedText;

  speechToText.listen(
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
    final SpeechToText speechToText = SpeechToText();
    await speechToText.stop();
  }

  Future<void> _sendImagePrompt(String message) async {
    setState(() {
      _loading = true;
    });
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
      setState(() {
        _loading = false;
      });
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
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _speakText(String texts) async {
    final tts = FlutterTts();
    await tts.setLanguage('th-TH');
    await tts.setSpeechRate(1);
    await tts.speak(texts);
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

