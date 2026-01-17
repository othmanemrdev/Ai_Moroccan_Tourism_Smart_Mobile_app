import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
import '../../services/trip_service.dart';
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  bool _isGenerating = false;
<<<<<<< HEAD
  bool _isSaving = false;
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
  bool _showResult = false;
  Map<String, dynamic>? _itineraryData;

  // Form Controllers
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  String _selectedBudget = "Moderate";
  int _days = 3;

  final Dio _dio = Dio();
<<<<<<< HEAD
  final TripService _tripService = TripService();
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
  final String _backendUrl = kIsWeb
      ? "http://localhost:8000"
      : "http://10.0.2.2:8000";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "AI Trip Planner",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _showResult ? _buildItineraryResult() : _buildPlannerForm(),
    );
  }

  // --- Step 1: The Input Form ---
  Widget _buildPlannerForm() {
    const primaryGreen = Color(0xFF006233);
    const accentRed = Color(0xFFC1272D);

    return SingleChildScrollView(
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
                    color: primaryGreen.withAlpha((0.1 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    size: 60,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Plan Your Perfect Trip",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "AI-powered itineraries tailored for Morocco",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),

          // Input Form
          _buildInputField(
            controller: _cityController,
            label: "Which cities?",
            hint: "e.g. Marrakech, Merzouga, Atlas Mountains",
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 20),

          // Duration Slider
          _buildInputLabel("Trip Duration"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Text(
                  "$_days Days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _days.toDouble(),
                  min: 1,
                  max: 14,
                  divisions: 13,
                  activeColor: primaryGreen,
                  onChanged: (val) => setState(() => _days = val.toInt()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Budget Selector
          _buildInputLabel("Budget Level"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Budget",
              "Moderate",
              "Luxury",
            ].map((b) => _budgetChip(b)).toList(),
          ),

          const SizedBox(height: 20),

          // Interests Input
          _buildInputField(
            controller: _interestsController,
            label: "Your Interests",
            hint: "e.g. culture, adventure, food, relaxation",
            icon: Icons.interests_outlined,
          ),

          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isGenerating ? null : _generateItinerary,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentRed,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isGenerating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Generate My Itinerary",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateItinerary() async {
    if (_cityController.text.isEmpty || _interestsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    final messenger = ScaffoldMessenger.of(context);

    try {
      final response = await _dio.post(
        '$_backendUrl/generate-itinerary',
        data: {
          'user_id': '', // Not used in backend anymore
          'city': _cityController.text,
          'duration': _days,
          'budget': _selectedBudget,
          'interests': _interestsController.text,
        },
      );

      setState(() {
        _itineraryData = response.data;
        _isGenerating = false;
        _showResult = true;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to generate itinerary: $e')),
      );
    }
  }

<<<<<<< HEAD
  Future<void> _saveTrip() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save trips')),
      );
      return;
    }

    if (_itineraryData == null) return;

    setState(() => _isSaving = true);

    try {
      print('Saving trip data: ${_itineraryData}');
      await _tripService.saveTrip(
        userId: userId,
        city: _cityController.text,
        duration: _days,
        itineraryJson: _itineraryData!,
      );

      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip saved successfully!'),
            backgroundColor: Color(0xFF006233),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save trip: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
  // --- Step 2: The Timeline Result ---
  Widget _buildItineraryResult() {
    const primaryGreen = Color(0xFF006233);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryGreen.withAlpha((0.1 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Your Custom Itinerary",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "AI-curated for an authentic Moroccan experience",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),

          // Itinerary Content
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F4),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: primaryGreen.withAlpha((0.3 * 255).toInt()),
              ),
            ),
            child: _itineraryData != null
                ? _buildDynamicItinerary()
                : const Text("No itinerary data available"),
          ),

          const SizedBox(height: 30),

<<<<<<< HEAD
          // Save Trip Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: _isSaving
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save, color: Colors.white),
              label: Text(
                _isSaving ? "Saving..." : "Save This Trip",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          // Back Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _showResult = false),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryGreen),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Plan Another Trip",
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper UI Components ---

  Widget _buildDaySection(String title, List<Map<String, String>> items) {
    const primaryGreen = Color(0xFF006233);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
        const SizedBox(height: 15),
        ...items.map((item) => _buildTimelineTile(item)),
      ],
    );
  }

  Widget _buildDynamicItinerary() {
    if (_itineraryData == null) return const SizedBox();

    List<Widget> daySections = [];

    // Assuming the AI returns something like {"Day 1": [...], "Day 2": [...]}
    // Or we can iterate through keys that start with "Day"
    _itineraryData!.forEach((key, value) {
      if (key.startsWith('Day') && value is List) {
        List<Map<String, String>> items = [];
        for (var item in value) {
          if (item is Map) {
            items.add({
              'time': item['time']?.toString() ?? 'TBD',
              'task':
                  item['activity']?.toString() ??
                  item['task']?.toString() ??
                  'Activity',
              'type': item['type']?.toString() ?? 'activity',
            });
          }
        }
        daySections.add(_buildDaySection(key, items));
      }
    });

    return Column(children: daySections);
  }

  Widget _buildTimelineTile(Map<String, String> item) {
    const accentRed = Color(0xFFC1272D);
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(radius: 6, backgroundColor: accentRed),
            Container(width: 2, height: 50, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['time']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  item['task']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _budgetChip(String label) {
    const primaryGreen = Color(0xFF006233);
    bool isSelected = _selectedBudget == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedBudget = label),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey[300]!,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primaryGreen),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryGreen),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}
