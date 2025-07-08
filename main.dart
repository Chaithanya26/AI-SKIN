import 'dart:async';

import 'package:api_skin/ImagePicker.dart';
import 'package:api_skin/speech_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

import 'component.dart';
 
 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const ChatBotRealApp(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF0050A0), // Your primary color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
 
class ChatBotRealApp extends StatefulWidget {
  const ChatBotRealApp({super.key});
  @override
  State<ChatBotRealApp> createState() => _ChatBotAppState();
}
 
class _ChatBotAppState extends State<ChatBotRealApp> {
final List<Map<String, dynamic>> chat = [];
final TextEditingController controller = TextEditingController();
final List<Widget> _messages = [];
final TextEditingController _controller = TextEditingController();
final ScrollController _scrollController = ScrollController();
final GlobalKey _plusKey = GlobalKey();
Map<String, dynamic> formValues = {};
 
bool _isTyping = false;
 
late stt.SpeechToText _speech;
bool _isListening = false;
late SpeechService _speechService;
 
@override
void initState() {
  super.initState();
    _speechService = SpeechService();
  _speechService.onResult = (value) {
    setState(() {
      _controller.text = value;
    });
  };
  _speechService.init();
 _controller.addListener(() {
  setState(() {
    _isTyping = _controller.text.trim().isNotEmpty;
  });
});
}



void _startListening() async {
  bool available = await _speech.initialize();
  if (available) {
    setState(() => _isListening = true);
    _speech.listen(onResult: (result) {
      setState(() {
        _controller.text = result.recognizedWords;
      });
    });
  }
}
void handleFilePick() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.single.path != null) {
    final fileName = result.files.single.name;
 
    setState(() {
      _messages.add(
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF0A84FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.insert_drive_file, size: 20),
                const SizedBox(width: 8),
                Flexible(child: Text(fileName, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      );
    });
 
    _scrollToBottom();
  }
}
void showCustomWebSheet(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Material(
          elevation: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical:4),
           decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.95),
    borderRadius: BorderRadius.circular(32),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: const Text('Attach File'),
                  onTap: () {
                    Navigator.pop(context);
                    handleFilePick();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Pick Image'),
                  onTap: () {
                    Navigator.pop(context);
                   ImageHelper.pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                     ImageHelper.takePhotoWithCamera();
                    // handleCamera();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
 

void showPickerPopup(BuildContext context, GlobalKey key) {
  final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);
 
  showMenu(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy - 160, // Position above the `+` icon
      offset.dx + 1,
      offset.dy,
    ),
    items: [
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: const Text('Attach File'),
          onTap: () {
            Navigator.pop(context);
            handleFilePick();
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Pick Image'),
          onTap: () {
            Navigator.pop(context);
            // TODO: handleImagePick();
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take Photo'),
          onTap: () {
            Navigator.pop(context);
            // TODO: handleCamera();
          },
        ),
      ),
    ],
  );
}
  

  void handleFormValueChanged(String key, dynamic value){
  setState((){
  formValues[key] = value;
  print("object {$formValues}");
  });
}
 
 
 void handleSend(String value) {
  if (value.trim().isEmpty) return;
 
  setState(() {
    _messages.add(
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value),
        ),
      ),
    );
  });
 
  _controller.clear();
  _isTyping = false;
  _scrollToBottom();
}
 
 void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  });
}
 
 
void _stopListening() {
  _speech.stop();
  setState(() => _isListening = false);
}
 

  Future<void> sendToBot(String userMessage) async {
    _controller.clear();
    _speechService.stopListening();
     _isListening = false;
    setState(() {
      chat.add({ "type": "text", "text": "🧑 $userMessage", "from": "user"});
    });
    final sessionId = Uuid().v4();
 
    final response = await http.post(
      // Uri.parse('http://localhost:8000/chat'),
      Uri.parse('http://127.0.0.1:8080/chat'),
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 
        "message": userMessage ,
        "sessionId": 78923
      }),
    );
 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fields = List<Map<String, dynamic>>.from(data['fields']);
      setState(() => chat.addAll(fields));
    } else {
      setState(() => chat.add({
        "type": "text",
        "text": "⚠️ Failed to get reply from server"
      }));
    }
    _controller.clear();
  }

  Widget buildChatInput() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        SizedBox(width: 5,),
       GestureDetector(
  key: _plusKey,
  onTap: () => showPickerPopup(context, _plusKey),
  child: Container(
    height: 40,
    width: 40,
    alignment: Alignment.center,
    child: const Icon(Icons.add, color: Color(0xFF0072CE),),
  ),
),
 SizedBox(width: 10,),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Type a message',
              border: InputBorder.none,
            ),
            onSubmitted: sendToBot,
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: _isTyping
              ? IconButton(
                  key: const ValueKey('send'),
                  icon: const Icon(Icons.send, color: Color(0xFF0072CE)),
                  onPressed: () => sendToBot(_controller.text),
                )
              : IconButton(
                  key: const ValueKey('mic'),
                  icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Color(0xFF0072CE),),
                  onPressed: () {
                    // late SpeechService _speechService;
                        if (_speechService.isListening) {
                          _speechService.stopListening();
                        } else {
                          _speechService.startListening();
                        }
                  }
                ),
        ),
      ],
    ),
  );
}
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 70, // default is 56
        toolbarOpacity: 0.5,
        backgroundColor: Color.fromARGB(255, 4, 32, 85),
        elevation: 5,
        shadowColor: Colors.orangeAccent,
        leading: Image.asset('assets/images/hdfc.png'),
        title: Text("AI SKIN", style: TextStyle(color: Colors.white))
        ),
        
      body: Container(
        decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF004C99), // Slightly lighter royal blue
        Color(0xFF003E7E), // Core royal blue
        Color(0xFF002C54), // Dark navy tone for depth
      ],
    ),
  ),
      child: 
  //     Stack(
  // children: [
  //   // Watermark background
  //   Positioned.fill(
  //     child: Opacity(
  //       opacity: 0.30, // adjust for watermark effect
  //       child: Image.asset(
  //         'assets/images/hdfc.png', // your logo or pattern
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   ),
       Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.length,
              itemBuilder: (context, index) {
                  return ComponentBuilder(onSend: sendToBot, isUser: true). 
                  buildComponent(
                    chat[index],
                  );
              },
            ),
            
          ),
      
    buildChatInput()
     
              ],
            ),
  // ])
        
      )
    );
  }
}