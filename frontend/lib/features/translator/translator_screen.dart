import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = "English";
  String _targetLanguage = "Darija";
  final TextEditingController _controller = TextEditingController();
  bool _isTranslating = false;
  Map<String, dynamic>? _translationResult;

  final Dio _dio = Dio();
  final String _backendUrl = kIsWeb
      ? "http://localhost:8000"
      : "http://10.0.2.2:8000";

  void _swapLanguages() {
    setState(() {
      String temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;
      _controller.clear();
      _translationResult = null;
    });
  }

  Future<void> _translate() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final response = await _dio.post(
        '$_backendUrl/translate-darija',
        data: {'text': _controller.text, 'target': _targetLanguage},
      );

      setState(() {
        _translationResult = response.data;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() => _isTranslating = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF006233);
    const accentRed = Color(0xFFC1272D);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Darija Bridge AI",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.translate,
                      size: 60,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Break Language Barriers",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Translate between English and Moroccan Darija",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Language Selector
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLanguageLabel(_sourceLanguage),
                  GestureDetector(
                    onTap: _swapLanguages,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  _buildLanguageLabel(_targetLanguage),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Section
            _buildInputField(
              label: "Enter text to translate",
              hint: "Type your message here...",
              controller: _controller,
            ),
            const SizedBox(height: 25),

            // Translate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTranslating ? null : _translate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isTranslating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Translate Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            // Result Section
            if (_translationResult != null) ...[
              const SizedBox(height: 30),
              _buildResultCard(),
            ],

            const SizedBox(height: 40),

            // Common Phrases
            const Text(
              "Common Phrases",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPhraseChip("How much is this?", "Bch-hal hada?"),
            _buildPhraseChip("Thank you very much", "Shokran bzeff"),
            _buildPhraseChip("Where is the bathroom?", "Fin bitu?"),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageLabel(String lang) {
    return Text(
      lang,
      style: const TextStyle(
        color: Color(0xFF006233),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    const primaryGreen = Color(0xFF006233);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    const primaryGreen = Color(0xFF006233);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.translate, color: primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                "Translation Result",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          if (_targetLanguage == "Darija") ...[
            const Text(
              "Latin Script",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              _translationResult?['latin'] ?? "Translation not available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Arabic Script",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              _translationResult?['arabic'] ?? "Translation not available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arabic',
                color: primaryGreen,
              ),
            ),
          ] else ...[
            const Text(
              "English Translation",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              _translationResult?['english'] ?? "Translation not available",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPhraseChip(String english, String darija) {
    const primaryGreen = Color(0xFF006233);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  english,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  darija,
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}
