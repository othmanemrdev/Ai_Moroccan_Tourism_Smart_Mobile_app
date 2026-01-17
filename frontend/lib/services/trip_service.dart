import 'package:dio/dio.dart';

class TripService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:8000';
  
  /// Save a trip itinerary
  Future<String> saveTrip({
    required String userId,
    required String city,
    required int duration,
    required Map<String, dynamic> itineraryJson,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/save-trip',
        data: {
          'user_id': userId,
          'city': city,
          'duration': duration,
          'itinerary_json': itineraryJson,
        },
      );
      
      return response.data['trip_id'];
    } catch (e) {
      throw Exception('Failed to save trip: $e');
    }
  }
  
  /// Get all saved trips for a user
  Future<List<Map<String, dynamic>>> getMyTrips(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/my-trips/$userId');
      return List<Map<String, dynamic>>.from(response.data['trips']);
    } catch (e) {
      throw Exception('Failed to load trips: $e');
    }
  }
  
  /// Delete a trip
  Future<void> deleteTrip(String tripId) async {
    try {
      await _dio.delete('$baseUrl/trip/$tripId');
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }
}
