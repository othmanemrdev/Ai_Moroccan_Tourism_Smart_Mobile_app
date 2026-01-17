import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingleFoodScreen extends StatefulWidget {
  final Map<String, dynamic> foodData;

  const SingleFoodScreen({super.key, required this.foodData});

  @override
  State<SingleFoodScreen> createState() => _SingleFoodScreenState();
}

class _SingleFoodScreenState extends State<SingleFoodScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;
  
  // --- Favorite State ---
  bool _isFavorite = false;
  String? _favoriteId;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _checkIfFavorite();
  }

  // --- Logic: Check if Food is Favorited ---
  Future<void> _checkIfFavorite() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id)
          .eq('item_id', widget.foodData['id'])
          .eq('item_type', 'food') // Specifically check for food type
          .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          _isFavorite = true;
          _favoriteId = data['id'];
        });
      }
    } catch (e) {
      debugPrint("Error checking food favorite: $e");
    }
  }

  // --- Logic: Toggle Favorite ---
  Future<void> _toggleFavorite() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to save favorites")),
      );
      return;
    }

    setState(() => _isFavorite = !_isFavorite);

    try {
      if (_isFavorite) {
        final response = await _supabase.from('favorites').insert({
          'user_id': user.id,
          'item_id': widget.foodData['id'],
          'item_type': 'food',
        }).select().single();
        _favoriteId = response['id'];
      } else {
        if (_favoriteId != null) {
          await _supabase.from('favorites').delete().eq('id', _favoriteId!);
          _favoriteId = null;
        }
      }
    } catch (e) {
      setState(() => _isFavorite = !_isFavorite);
      debugPrint("Error toggling favorite: $e");
    }
  }

  // --- Logic: Fetch Food Reviews ---
  Future<void> _fetchReviews() async {
    try {
      final data = await _supabase
          .from('reviews')
          .select('*, profiles(full_name)')
          .eq('item_id', widget.foodData['id'])
          .eq('item_type', 'food')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _reviews = data;
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching food reviews: $e");
      if (mounted) setState(() => _isLoadingReviews = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List images = widget.foodData['item_images'] ?? [];
    final String mainImageUrl = images.isNotEmpty 
        ? images[0]['image_url'] 
        : 'https://images.immediate.co.uk/production/volatile/sites/2/2025/08/MoroccanCouscouspreview-92f8cd1.jpg?quality=90&webp=true&crop=4px,559px,2658px,2415px&resize=700,636';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            leading: const BackButton(color: Colors.white),
            backgroundColor: const Color(0xFF006233),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(mainImageUrl, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border, 
                    color: const Color(0xFFC1272D), // Kept it Red
                    size: 20
                  ),
                ),
                onPressed: _toggleFavorite,
              ),
              const SizedBox(width: 10),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodData['name'] ?? "Traditional Dish",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Category: ${widget.foodData['type'] ?? 'Moroccan Cuisine'}",
                    style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        _buildStatColumn("Origin", widget.foodData['origin_city'] ?? "Morocco"),
                        Container(width: 1, height: 40, color: Colors.grey.shade300),
                        _buildStatColumn("Popularity", "High"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  const Text("About this Dish", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    widget.foodData['description'] ?? "No description available for this delicious Moroccan specialty.",
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
                  ),

                  const SizedBox(height: 30),
                  if (images.length > 1) ...[
                    const Text("Visual Gallery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(images[index]['image_url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Community Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () => _showAddReviewSheet(context),
                        icon: const Icon(Icons.add_comment, color: Color(0xFF006233), size: 18),
                        label: const Text("Write", style: TextStyle(color: Color(0xFF006233))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  if (_isLoadingReviews)
                    const Center(child: CircularProgressIndicator(color: Color(0xFF006233)))
                  else if (_reviews.isEmpty)
                    const Center(child: Text("No reviews yet. Be the first!", style: TextStyle(color: Colors.grey)))
                  else
                    ..._reviews.map((review) => _buildReviewCard(
                      review['comment'] ?? "", 
                      review['profiles']?['full_name'] ?? "Guest"
                    )).toList(),
                    
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006233))),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String text, String author) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.account_circle, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddReviewSheet(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Share your Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "How was the taste? Where did you try it?",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006233),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final userId = _supabase.auth.currentUser?.id;
                  if (userId == null) return;

                  if (commentController.text.isNotEmpty) {
                    await _supabase.from('reviews').insert({
                      'user_id': userId,
                      'item_id': widget.foodData['id'],
                      'item_type': 'food',
                      'comment': commentController.text,
                      'rating': 5, // Default rating
                    });
                    
                    if (mounted) Navigator.pop(context);
                    _fetchReviews(); // Refresh the list
                  }
                },
                child: const Text("Post Review", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}