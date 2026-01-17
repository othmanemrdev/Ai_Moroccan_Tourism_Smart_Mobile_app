import 'dart:io';
import 'package:dio/dio.dart';
import 'connectivity_service.dart';

class HybridClassifierService {
  final ConnectivityService _connectivity = ConnectivityService();
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:8000';
  
  Future<Map<String, dynamic>> classify(File imageFile, String category) async {
    final isOnline = await _connectivity.isOnline();
    
    if (isOnline) {
      // Try online first (Gemini)
      try {
        return await classifyOnline(imageFile, category);
      } catch (e) {
        // Fallback to local if online fails
        print('Online classification failed, falling back to local: $e');
        return await classifyLocal(imageFile, category);
      }
    } else {
      // Offline: use local model
      return await classifyLocal(imageFile, category);
    }
  }
  
  Future<Map<String, dynamic>> classifyOnline(File imageFile, String category) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'category': category,
    });
    
    final response = await _dio.post(
      '$baseUrl/analyze-only',
      data: formData,
    );
    
    return {
      ...response.data,
      'mode': 'online',
      'source': 'gemini'
    };
  }
  
  Future<Map<String, dynamic>> classifyLocal(File imageFile, String category) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path),
      'category': category,
    });
    
    final response = await _dio.post(
      '$baseUrl/classify-local',
      data: formData,
    );
    
    return {
      ...response.data,
      'mode': 'offline'
    };
  }
  
  /// Upload photo to Supabase Storage
  Future<String> uploadPhoto({
    required File imageFile,
    required String itemName,
    required String itemType,
    required String userId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path),
        'item_name': itemName,
        'item_type': itemType,
        'user_id': userId,
      });
      
      final response = await _dio.post(
        '$baseUrl/upload-photo',
        data: formData,
      );
      
      return response.data['image_url'];
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }
}
