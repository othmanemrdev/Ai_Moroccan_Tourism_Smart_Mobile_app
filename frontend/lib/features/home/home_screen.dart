import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/moroccan_header.dart';
import 'widgets/monument_card.dart';
import 'widgets/popular_dish_card.dart';
import 'widgets/moroccan_sidebar.dart';
import './screens/single_food_screen.dart';
import './screens/single_monument_screen.dart';
import '../food/all_foods_screen.dart';
import '../monuments/all_monuments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _monuments = [];
  List<Map<String, dynamic>> _food = [];
  Map<String, String?> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      // 1. Fetch Base Data
      final monumentData = await _supabase.from('monuments').select('*');
      final foodData = await _supabase
          .from('food')
          .select('*, profiles(full_name)');
      final imageData = await _supabase.from('item_images').select('*');

      // 2. Fetch User Favorites SAFELY
      Map<String, String?> favIds = {};
      if (userId != null) {
        final List<dynamic> favData = await _supabase
            .from('favorites')
            .select('item_id, id')
            .eq('user_id', userId);

        // Create map of item_id to favorite id
        favIds = {
          for (var f in favData) f['item_id'].toString(): f['id'] as String,
        };
      }

      // 3. Enrich Monuments
      final List<Map<String, dynamic>> enrichedMonuments =
          List<Map<String, dynamic>>.from(monumentData).map((monument) {
            final itemImages = imageData
                .where(
                  (img) =>
                      img['item_id'] == monument['id'] &&
                      img['item_type'] == 'monument',
                )
                .toList();
            return {
              ...monument,
              'item_images': itemImages,
              'isFavorite': favIds.containsKey(monument['id'].toString()),
            };
          }).toList();

      // 4. Enrich Food
      final List<Map<String, dynamic>> enrichedFood =
          List<Map<String, dynamic>>.from(foodData).map((dish) {
            final itemImages = imageData
                .where(
                  (img) =>
                      img['item_id'] == dish['id'] &&
                      img['item_type'] == 'food',
                )
                .toList();
            return {
              ...dish,
              'item_images': itemImages,
              'isFavorite': favIds.containsKey(dish['id'].toString()),
            };
          }).toList();

      if (mounted) {
        setState(() {
          _favoriteIds = favIds;
          _monuments = enrichedMonuments;
          _food = enrichedFood;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Data Fetch Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorite(String itemId, String type) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _showSnackBar("Please login to save favorites");
      return;
    }

    final bool isCurrentlyFav = _favoriteIds.containsKey(itemId);
    String? oldFavId = isCurrentlyFav ? _favoriteIds[itemId] : null;

    // Optimistic UI Update
    setState(() {
      if (isCurrentlyFav) {
        _favoriteIds.remove(itemId);
      } else {
        _favoriteIds[itemId] = null; // placeholder
      }
      _updateLocalLists();
    });

    try {
      if (isCurrentlyFav) {
        await _supabase.from('favorites').delete().eq('id', oldFavId!);
      } else {
        final response = await _supabase
            .from('favorites')
            .insert({'user_id': userId, 'item_id': itemId, 'item_type': type})
            .select()
            .single();
        _favoriteIds[itemId] = response['id'];
      }
    } catch (e) {
      debugPrint("Favorite Sync Error: $e");
      // Revert on error
      setState(() {
        if (isCurrentlyFav) {
          _favoriteIds[itemId] = oldFavId;
        } else {
          _favoriteIds.remove(itemId);
        }
        _updateLocalLists();
      });
    }
  }

  void _updateLocalLists() {
    setState(() {
      for (var item in _monuments) {
        item['isFavorite'] = _favoriteIds.containsKey(item['id'].toString());
      }
      for (var item in _food) {
        item['isFavorite'] = _favoriteIds.containsKey(item['id'].toString());
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userDisplayName =
<<<<<<< HEAD
        _supabase.auth.currentUser?.userMetadata?['display_name'] ??
        _supabase.auth.currentUser?.email?.split('@')[0] ??
        "Explorer";
=======
        _supabase.auth.currentUser?.email?.split('@')[0] ?? "Explorer";
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: MoroccanSidebar(
        userName: userDisplayName,
        onLogout: () async {
          await _supabase.auth.signOut();
          if (mounted) Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF006233)),
            )
          : RefreshIndicator(
              onRefresh: _fetchData,
              color: const Color(0xFF006233),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MoroccanHeader(userName: userDisplayName),
                    const SizedBox(height: 25),
                    _buildIntroText(),
                    const SizedBox(height: 30),
                    _buildSectionHeader("Explore Monuments", "History"),
                    const SizedBox(height: 15),
                    _buildMonumentSlider(),
                    const SizedBox(height: 35),
                    _buildSectionHeader(
                      "Popular Dishes",
                      "Flavors",
                      showSeeAll: true,
                    ),
                    const SizedBox(height: 15),
                    _buildFoodList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildIntroText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Discover the Soul of Morocco",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Explore thousands of years of history and traditional flavors.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMonumentSlider() {
    return SizedBox(
      height: 235, // Adjusted to fit card + new shadow padding
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _monuments.length + 1,
        itemBuilder: (context, index) {
          if (index == _monuments.length) {
            return _buildSeeAllCard(
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllMonumentsScreen()),
              ),
            );
          }

          final monument = _monuments[index];
          final List images = monument['item_images'] ?? [];
          final String imageUrl = images.isNotEmpty
              ? images[0]['image_url']
              : 'https://tesfpidxjlrieadlyovx.supabase.co/storage/v1/object/public/monument_photos/koutoubia.jpg';

          return MonumentCard(
            name: monument['name'] ?? 'Monument',
            city: monument['city'] ?? 'Morocco',
            imageUrl: imageUrl,
            isFavorite: monument['isFavorite'] ?? false, // Pass favorite state
            onFavoriteTap: () =>
                _toggleFavorite(monument['id'].toString(), 'monument'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SingleMonumentScreen(monumentData: monument),
              ),
            ),
            width: 220, // Fixed width for horizontal list
            imageHeight: 140, // Fixed image height for horizontal list
          );
        },
      ),
    );
  }

  Widget _buildSeeAllCard(VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        top: 5,
      ), // Align with MonumentCard top/bottom
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF006233).withOpacity(0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF006233).withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF006233),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "See All",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006233),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _food.length,
      itemBuilder: (context, index) {
        final item = _food[index];
        final List images = item['item_images'] ?? [];
        final String authorName =
            item['profiles']?['full_name'] ?? "Contributor";

        return PopularDishCard(
          name: item['name'] ?? 'Dish',
          type: item['type'] ?? "Traditional",
          imageUrl: images.isNotEmpty
              ? images[0]['image_url']
              : 'https://images.immediate.co.uk/production/volatile/sites/2/2025/08/MoroccanCouscouspreview-92f8cd1.jpg?quality=90&webp=true&crop=4px,559px,2658px,2415px&resize=700,636',
          addedBy: authorName,
          isFavorite:
              item['isFavorite'] ??
              false, // Ensure PopularDishCard also accepts this
          onFavoriteTap: () => _toggleFavorite(item['id'].toString(), 'food'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleFoodScreen(foodData: item),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle, {
    bool showSeeAll = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFC1272D),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (showSeeAll)
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllFoodsScreen()),
              ),
              child: const Text(
                "See All",
                style: TextStyle(
                  color: Color(0xFF006233),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
