import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/widgets/monument_card.dart';
import '../home/screens/single_monument_screen.dart';

class AllMonumentsScreen extends StatefulWidget {
  const AllMonumentsScreen({super.key});

  @override
  State<AllMonumentsScreen> createState() => _AllMonumentsScreenState();
}

class _AllMonumentsScreenState extends State<AllMonumentsScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _allMonuments = [];
  List<Map<String, dynamic>> _filteredMonuments = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      final data =
          await _supabase.from('monuments').select('*').order('name');

      final imageData = await _supabase
          .from('item_images')
          .select('*')
          .eq('item_type', 'monument');

      if (userId != null) {
        final favs = await _supabase
            .from('favorites')
            .select('item_id')
            .eq('user_id', userId);

        _favoriteIds =
            favs.map((f) => f['item_id'].toString()).toSet();
      }

      final enriched = data.map((m) {
        final images =
            imageData.where((img) => img['item_id'] == m['id']).toList();

        return {
          ...m,
          'item_images': images,
          'isFavorite': _favoriteIds.contains(m['id'].toString()),
        };
      }).toList();

      setState(() {
        _allMonuments = List<Map<String, dynamic>>.from(enriched);
        _filteredMonuments = _allMonuments;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading monuments: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredMonuments = _allMonuments.where((m) {
        final q = query.toLowerCase();
        return m['name'].toLowerCase().contains(q) ||
            m['city'].toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<void> _toggleFavorite(String itemId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final isFav = _favoriteIds.contains(itemId);

    setState(() {
      if (isFav) {
        _favoriteIds.remove(itemId);
      } else {
        _favoriteIds.add(itemId);
      }

      for (final m in _allMonuments) {
        if (m['id'].toString() == itemId) {
          m['isFavorite'] = !isFav;
        }
      }
    });

    try {
      if (isFav) {
        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', userId)
            .eq('item_id', itemId);
      } else {
        await _supabase.from('favorites').insert({
          'user_id': userId,
          'item_id': itemId,
          'item_type': 'monument',
        });
      }
    } catch (_) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "All Monuments",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF006233)),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterSearch,
                    decoration: InputDecoration(
                      hintText: "Search by name or city...",
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF006233)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.98,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredMonuments.length,
                    itemBuilder: (context, index) {
                      final m = _filteredMonuments[index];

                      return Align(
                        alignment: Alignment.topCenter,
                        child: MonumentCard(
                          name: m['name'],
                          city: m['city'],
                          imageUrl: m['item_images'].isNotEmpty
                              ? m['item_images'][0]['image_url']
                              : 'https://tesfpidxjlrieadlyovx.supabase.co/storage/v1/object/public/monument_photos/koutoubia.jpg',
                          isFavorite: m['isFavorite'] ?? false,
                          onFavoriteTap: () =>
                              _toggleFavorite(m['id'].toString()),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SingleMonumentScreen(monumentData: m),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
