import 'package:shared_preferences/shared_preferences.dart';

class ClassificationPreferences {
  static const String _keyUseGemini = 'use_gemini';
  
  /// Get user preference for classification method
  /// Returns true for Gemini, false for Local Model
  static Future<bool> getUseGemini() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyUseGemini) ?? true; // Default to Gemini
  }
  
  /// Set user preference for classification method
  static Future<void> setUseGemini(bool useGemini) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseGemini, useGemini);
  }
}
