import 'dart:convert';
<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/classification_preferences.dart';
=======
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/widgets/popular_dish_card.dart';
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

class FoodClassifierScreen extends StatefulWidget {
  const FoodClassifierScreen({super.key});

  @override
  State<FoodClassifierScreen> createState() => _FoodClassifierScreenState();
}

class _FoodClassifierScreenState extends State<FoodClassifierScreen> {
<<<<<<< HEAD
  Uint8List? _webImage;
  XFile? _pickedFile;
  bool _isAnalyzing = false;
  bool _isUploading = false;
  Map<String, dynamic>? _analysisResult;
  bool _useGemini = true;
  String? _classificationMode;
  
  final dio.Dio _dio = dio.Dio();
  final String _backendUrl = kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final useGemini = await ClassificationPreferences.getUseGemini();
    setState(() => _useGemini = useGemini);
  }

  Future<void> _toggleClassificationMode(bool value) async {
    setState(() => _useGemini = value);
    await ClassificationPreferences.setUseGemini(value);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    
    if (kIsWeb && source == ImageSource.camera) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera not available on web. Please use gallery.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
=======
  Uint8List? _webImage; // For previewing on Web
  XFile? _pickedFile; // For holding the file data
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  // Since you are using localhost on Port 8000
  final String _backendUrl = kIsWeb
      ? "http://localhost:8000"
      : "http://10.0.2.2:8000";

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        _webImage = f;
        _pickedFile = image;
        _analysisResult = null;
<<<<<<< HEAD
        _classificationMode = null;
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
      });
    }
  }

  Future<void> _analyzeDish() async {
<<<<<<< HEAD
    if (_pickedFile == null || _webImage == null) return;
=======
    if (_pickedFile == null) return;
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

    setState(() => _isAnalyzing = true);

    try {
<<<<<<< HEAD
      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          _webImage!,
          filename: _pickedFile!.name,
        ),
        'category': 'food',
      });

      final endpoint = _useGemini ? '/analyze-only' : '/classify-local';
      final response = await _dio.post('$_backendUrl$endpoint', data: formData);

      setState(() {
        _analysisResult = response.data['item_details'];
        _classificationMode = _useGemini ? 'online' : 'offline';
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _uploadPhoto() async {
    if (_pickedFile == null || _analysisResult == null || _webImage == null) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to upload photos")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final formData = dio.FormData.fromMap({
        'file': dio.MultipartFile.fromBytes(
          _webImage!,
          filename: _pickedFile!.name,
        ),
        'item_name': _analysisResult!['name'],
        'item_type': 'food',
        'user_id': userId,
      });

      await _dio.post('$_backendUrl/upload-photo', data: formData);

      setState(() => _isUploading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Photo uploaded successfully!"),
            backgroundColor: Color(0xFF006233),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Upload failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
=======
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_backendUrl/analyze-only'),
      );

      request.fields['category'] = 'food';

      // Use fromBytes to ensure it works on Web and Mobile
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _webImage!,
          filename: _pickedFile!.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            _analysisResult = result['item_details'];
            _isAnalyzing = false;
          });
        } else {
          throw Exception(result['detail'] ?? 'Analysis failed');
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Food Classifier",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
<<<<<<< HEAD
            _buildModeToggle(),
            const SizedBox(height: 20),
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
            _buildImagePreview(),
            const SizedBox(height: 25),
            _buildActionButtons(),
            const SizedBox(height: 30),
            if (_webImage != null && _analysisResult == null)
              _buildAnalyzeButton(),
<<<<<<< HEAD
            if (_analysisResult != null) ...[
              _buildResultCard(),
              const SizedBox(height: 15),
              _buildUploadButton(),
            ],
=======
            if (_analysisResult != null) _buildResultCard(),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildModeToggle() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF006233).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Color(0xFF006233)),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classification Mode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Choose your preferred AI',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _buildToggleButton('Gemini AI', _useGemini, () => _toggleClassificationMode(true)),
                _buildToggleButton('Local Model', !_useGemini, () => _toggleClassificationMode(false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF006233) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
  Widget _buildImagePreview() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: _webImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.memory(_webImage!, fit: BoxFit.cover),
<<<<<<< HEAD
            )
=======
            ) // Memory image for Web support
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload_outlined, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  "Capture or upload a Moroccan dish",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006233),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
<<<<<<< HEAD
            onPressed: kIsWeb ? null : () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: Text(
              kIsWeb ? "Camera (N/A)" : "Camera",
              style: const TextStyle(color: Colors.white),
            ),
=======
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text("Camera", style: TextStyle(color: Colors.white)),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: OutlinedButton.icon(
<<<<<<< HEAD
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF006233)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
=======
            style:
                OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF006233)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ).copyWith(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.transparent; // No hover color
                    }
                    return null;
                  }),
                ),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.image, color: Color(0xFF006233)),
            label: const Text(
              "Gallery",
              style: TextStyle(color: Color(0xFF006233)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC1272D),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isAnalyzing ? null : _analyzeDish,
        child: _isAnalyzing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
<<<<<<< HEAD
            : Text(
                _useGemini ? "Analyze with Gemini AI" : "Analyze with Local Model",
                style: const TextStyle(
=======
            : const Text(
                "Analyze Dish",
                style: TextStyle(
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildResultCard() {
<<<<<<< HEAD
    final confidence = _analysisResult?['confidence'];
    final source = _analysisResult?['source'] ?? _classificationMode;
    
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF006233).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< HEAD
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Analysis Result",
                style: TextStyle(
                  color: Color(0xFF006233),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (source != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: source == 'local_model' || source == 'offline'
                        ? Colors.orange
                        : const Color(0xFF006233),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    source == 'local_model' || source == 'offline' ? 'Local Model' : 'Gemini AI',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
=======
          const Text(
            "Analysis Result",
            style: TextStyle(
              color: Color(0xFF006233),
              fontWeight: FontWeight.bold,
            ),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          ),
          const SizedBox(height: 10),
          Text(
            "Dish: ${_analysisResult?['name'] ?? 'Unknown'}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Type: ${_analysisResult?['type'] ?? 'Unknown'}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
<<<<<<< HEAD
          if (confidence != null)
            Text(
              "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          const SizedBox(height: 10),
          Text(_analysisResult?['description'] ?? "No description available."),
        ],
      ),
    );
  }
<<<<<<< HEAD

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF006233)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isUploading ? null : _uploadPhoto,
        icon: _isUploading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: Color(0xFF006233),
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.cloud_upload, color: Color(0xFF006233)),
        label: Text(
          _isUploading ? "Uploading..." : "Add to Database",
          style: const TextStyle(
            color: Color(0xFF006233),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
}
