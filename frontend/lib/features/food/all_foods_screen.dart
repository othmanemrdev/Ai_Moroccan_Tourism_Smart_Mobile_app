import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/widgets/popular_dish_card.dart';

class AllFoodsScreen extends StatefulWidget {
  const AllFoodsScreen({super.key});

  @override
  State<AllFoodsScreen> createState() => _AllFoodsScreenState();
}

class _AllFoodsScreenState extends State<AllFoodsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _allFood = [];
  List<Map<String, dynamic>> _filteredFood = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      final data = await _supabase.from('food').select('*, profiles(full_name)');
      final imageData = await _supabase.from('item_images').select('*').eq('item_type', 'food');
      
      if (userId != null) {
        final favs = await _supabase.from('favorites').select('item_id').eq('user_id', userId);
        _favoriteIds = (favs as List).map((f) => f['item_id'].toString()).toSet();
      }

      final enriched = data.map((f) {
        final images = imageData.where((img) => img['item_id'] == f['id']).toList();
        return {
          ...f,
          'item_images': images,
          'isFavorite': _favoriteIds.contains(f['id'].toString()),
        };
      }).toList();

      setState(() {
        _allFood = List<Map<String, dynamic>>.from(enriched);
        _filteredFood = _allFood;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Moroccan Flavors", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF006233)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredFood.length,
            itemBuilder: (context, index) {
              final dish = _filteredFood[index];
              return PopularDishCard(
                name: dish['name'],
                type: dish['type'],
                imageUrl: dish['item_images'].isNotEmpty ? dish['item_images'][0]['image_url'] : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=880&auto=format&fit=crop',
                addedBy: dish['profiles']?['full_name'] ?? 'Guest',
                isFavorite: dish['isFavorite'] ?? false,
                onFavoriteTap: () => _toggleFavorite(dish['id'].toString()),
                onTap: () {},
              );
            },
          ),
    );
  }

  Future<void> _toggleFavorite(String itemId) async {
     // ... logic identical to Monuments toggle but item_type: 'food' ...
  }
}