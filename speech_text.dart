import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:universal_platform/universal_platform.dart';
 
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool isListening = false;
 
  Function(String)? onResult;
 
  Future<void> init() async {
    // if (UniversalPlatform.isWeb) {
    //   print("Web speech initialized (via flutter_web_speech)");
    //   return;
    // }
 
    _isInitialized = await _speech.initialize(
      onStatus: (status) => debugPrint("Speech status: $status"),
      onError: (error) => debugPrint("Speech error: $error"),
    );
 
    if (!_isInitialized) {
      debugPrint("Speech not available on this platform.");
    }
  }
 
  void startListening() {
    // if (UniversalPlatform.isWeb) {
    //   WebSpeech.listen((value) {
    //     if (onResult != null) onResult!(value);
    //   });
    // } else {
      if (!_isInitialized) return;
 
      _speech.listen(
        onResult: (val) {
          if (onResult != null) onResult!(val.recognizedWords);
        },
      );
    // }
 
    isListening = true;
  }
 
  void stopListening() {
    // if (UniversalPlatform.isWeb) {
    //   WebSpeech.stop();
    // } else {
      _speech.stop();
    // }
 
    isListening = false;
  }
}
 