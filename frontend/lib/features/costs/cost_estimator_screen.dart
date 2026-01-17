import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CostEstimatorScreen extends StatefulWidget {
  const CostEstimatorScreen({super.key});

  @override
  State<CostEstimatorScreen> createState() => _CostEstimatorScreenState();
}

class _CostEstimatorScreenState extends State<CostEstimatorScreen> {
  final _itemController = TextEditingController();
  final _locationController = TextEditingController(text: "Marrakech");
  String _result = "";
  bool _isLoading = false;
  final Dio _dio = Dio();

  // Handle localhost for Web vs Mobile automatically
  final String _baseUrl = kIsWeb
      ? "http://localhost:8000"
      : "http://10.0.2.2:8000";

  Future<void> _getEstimate() async {
    if (_itemController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final response = await _dio.post(
        "$_baseUrl/estimate-cost",
        data: {
          "item": _itemController.text,
          "location": _locationController.text,
        },
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final min = data['min'] ?? 'N/A';
        final max = data['max'] ?? 'N/A';
        final tip = data['haggling_tip'] ?? '';
        setState(
          () => _result = 'Price Range: $min - $max MAD\n\nHaggling Tip: $tip',
        );
      } else {
        setState(() => _result = data.toString());
      }
    } catch (e) {
      setState(
        () => _result =
            "⚠️ Could not fetch prices. Ensure your backend is running at $_baseUrl",
      );
    } finally {
      setState(() => _isLoading = false);
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
          "Fair Price Finder",
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
                      Icons.account_balance_wallet,
                      size: 60,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Avoid Tourist Traps",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Get real-time fair market prices in Morocco",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Input Form
            _buildInputField(
              controller: _itemController,
              label: "What are you buying/booking?",
              hint: "e.g., Leather bag, Argan Oil, Camel Trek",
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(height: 15),
            _buildInputField(
              controller: _locationController,
              label: "City / Market Location",
              hint: "e.g., Marrakech Medina, Casablanca",
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 25),

            // Quick Suggestions
            const Text(
              "Quick Search:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ["Taxi", "Souvenir bag", "Dinner", "Guide"].map((item) {
                return ActionChip(
                  label: Text(item),
                  onPressed: () => _itemController.text = item,
                  backgroundColor: Colors.grey[100],
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _getEstimate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Check Fair Price",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            // Result Display
            if (_result.isNotEmpty) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7F4),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryGreen.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.gavel, color: primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Expert Price Advice",
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 25),
                    SelectableText(
                      _result,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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
            prefixIcon: Icon(icon, color: const Color(0xFF006233)),
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
              borderSide: const BorderSide(color: Color(0xFF006233)),
            ),
          ),
        ),
      ],
    );
  }
}
