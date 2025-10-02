import 'package:neuronavi/data/services/tts_service.dart';

class TtsHelper {
  final TtsService _ttsService = TtsService();

  Future<void> speak(String text) async {
    await _ttsService.speak(text);
  }

  Future<void> stop() async {
    await _ttsService.stop();
  }
}