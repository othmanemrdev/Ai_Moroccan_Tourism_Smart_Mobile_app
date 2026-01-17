import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/widgets/monument_card.dart';
import '../home/widgets/popular_dish_card.dart';
import '../home/screens/single_monument_screen.dart';
import '../home/screens/single_food_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "My Favorites",
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFF006233),
            labelColor: Color(0xFF006233),
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(icon: Icon(Icons.fort_outlined), text: "Monuments"),
              Tab(icon: Icon(Icons.restaurant_menu), text: "Food"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoritesList(type: 'monument'),
            _FavoritesList(type: 'food'),
          ],
        ),
      ),
    );
  }
}

class _FavoritesList extends StatefulWidget {
  final String type;
  const _FavoritesList({required this.type});

  @override
  State<_FavoritesList> createState() => _FavoritesListState();
}

class _FavoritesListState extends State<_FavoritesList> {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // 1. Get favorite item IDs for this type
      final favData = await _supabase
          .from('favorites')
          .select('item_id')
          .eq('user_id', userId)
          .eq('item_type', widget.type);

      final List<String> itemIds = favData
          .map((f) => f['item_id'].toString())
          .toList();

      if (itemIds.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      // 2. Fetch items
      final String tableName = widget.type == 'food' ? 'food' : 'monuments';
      final String profileJoin = widget.type == 'food'
          ? ', profiles(full_name)'
          : '';
      final items = await _supabase
          .from(tableName)
          .select('*$profileJoin')
          .filter('id', 'in', '(${itemIds.join(',')})');

      // 3. Fetch images for these items
      final images = await _supabase
          .from('item_images')
          .select('*')
          .eq('item_type', widget.type)
          .filter('item_id', 'in', '(${itemIds.join(',')})');

      // 4. Enrich items with images
      final enrichedItems = items.map((item) {
        final itemImages = images
            .where((img) => img['item_id'] == item['id'])
            .toList();
        return {...item, 'item_images': itemImages};
      }).toList();

      setState(() {
        _items = List<Map<String, dynamic>>.from(enrichedItems);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Favorites Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFromFavorites(String itemId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('item_id', itemId)
        .eq('item_type', widget.type);

    _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF006233)),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No favorite ${widget.type}s yet",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (widget.type == 'monument') {
      return GridView.builder(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16
        ), // Match all monuments screen with top margin
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.98,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final List images = item['item_images'] ?? [];
          final String imageUrl = images.isNotEmpty
              ? images[0]['image_url']
              : 'https://tesfpidxjlrieadlyovx.supabase.co/storage/v1/object/public/monument_photos/koutoubia.jpg';

          return MonumentCard(
            name: item['name'] ?? 'Unknown Monument',
            city: item['city'] ?? 'Unknown City',
            imageUrl: imageUrl,
            isFavorite: true,
            onFavoriteTap: () => _removeFromFavorites(item['id'].toString()),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SingleMonumentScreen(monumentData: item),
              ),
            ),
            margin: EdgeInsets.zero,
            contentPadding: const EdgeInsets.all(8),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final List images = item['item_images'] ?? [];
        final String imageUrl = images.isNotEmpty
            ? images[0]['image_url']
            : 'https://tesfpidxjlrieadlyovx.supabase.co/storage/v1/object/public/monument_photos/koutoubia.jpg';

        final String authorName =
            item['profiles']?['full_name'] ?? "Contributor";

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PopularDishCard(
            name: item['name'] ?? 'Unknown Dish',
            type: item['type'] ?? 'Unknown Type',
            imageUrl: imageUrl,
            addedBy: authorName,
            isFavorite: true,
            onFavoriteTap: () => _removeFromFavorites(item['id'].toString()),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SingleFoodScreen(foodData: item),
              ),
            ),
          ),
        );
      },
    );
  }
}
