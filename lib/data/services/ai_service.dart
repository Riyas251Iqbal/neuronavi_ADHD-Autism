import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:neuronavi/core/constants.dart';

class AiService {
  // IMPORTANT: Replace with your actual Gemini API Key.
  // It's highly recommended to store this key securely (e.g., using environment variables)
  // and not hardcode it in your app.
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  final GenerativeModel _model;

  AiService()
      : _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);

  Future<List<String>> breakdownTask(String highLevelTask) async {
    if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        // Return mock data if API key is not set
        print("Warning: Gemini API Key not set. Returning mock data.");
        await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
        return [
          "First, make your bed.",
          "Second, put toys away in the toy box.",
          "Third, place books neatly on the shelf.",
          "Finally, put dirty clothes in the hamper."
        ];
    }
    
    try {
      final prompt = AppConstants.aiPrompt + highLevelTask;
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        // Split the response text by new lines and filter out any empty lines.
        // Also remove numbering like "1. ", "2. ", etc.
        return response.text!
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
            .toList();
      }
      return [];
    } catch (e) {
      print("Error calling Gemini API: $e");
      // Return an error message or an empty list on failure.
      return ["Failed to break down task."];
    }
  }
}