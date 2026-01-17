import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SingleMonumentScreen extends StatefulWidget {
  final Map<String, dynamic> monumentData;

  const SingleMonumentScreen({super.key, required this.monumentData});

  @override
  State<SingleMonumentScreen> createState() => _SingleMonumentScreenState();
}

class _SingleMonumentScreenState extends State<SingleMonumentScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;
  
  bool _isFavorite = false;
  String? _favoriteId;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabase
        .from('favorites')
        .select('id')
        .eq('user_id', user.id)
        .eq('item_id', widget.monumentData['id'])
        .eq('item_type', 'monument')
        .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          _isFavorite = true;
          _favoriteId = data['id'];
        });
      }
    } catch (e) {
      debugPrint("Error checking favorite: $e");
    }
  }

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
          'item_id': widget.monumentData['id'],
          'item_type': 'monument',
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

  Future<void> _fetchReviews() async {
    try {
      final data = await _supabase
          .from('reviews')
          .select('*, profiles(full_name, avatar_url)')
          .eq('item_id', widget.monumentData['id'])
          .eq('item_type', 'monument')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _reviews = data;
          _isLoadingReviews = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      if (mounted) setState(() => _isLoadingReviews = false);
    }
  }

  void _showAddReviewSheet() {
    final TextEditingController commentController = TextEditingController();
    int selectedRating = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white, // Ensure white background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Share your experience",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setModalState(() => selectedRating = index + 1),
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: commentController,
                maxLines: 3,
                cursorColor: const Color(0xFF006233),
                decoration: InputDecoration(
                  hintText: "Tell us about your visit...",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF006233), width: 2),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006233),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    final userId = _supabase.auth.currentUser?.id;
                    if (userId == null) return;

                    await _supabase.from('reviews').insert({
                      'user_id': userId,
                      'item_id': widget.monumentData['id'],
                      'item_type': 'monument',
                      'rating': selectedRating,
                      'comment': commentController.text,
                    });

                    if (mounted) Navigator.pop(context);
                    _fetchReviews();
                  },
                  child: const Text("Post Review", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List images = widget.monumentData['item_images'] ?? [];
    final String mainImageUrl = images.isNotEmpty
        ? images[0]['image_url']
        : 'https://tesfpidxjlrieadlyovx.supabase.co/storage/v1/object/public/monument_photos/koutoubia.jpg';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            backgroundColor: const Color(0xFF006233),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      // Changed from red to your brand green or white for better aesthetics
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),
            ],
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
                        colors: [Colors.black45, Colors.transparent, Colors.black45],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.monumentData['name'] ?? "Monument",
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF006233), size: 18),
                      const SizedBox(width: 4),
                      Text("${widget.monumentData['city'] ?? 'Morocco'}, Morocco",
                          style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      _buildInfoChip(Icons.history_edu, widget.monumentData['era'] ?? "Ancient"),
                      const SizedBox(width: 12),
                      _buildInfoChip(Icons.account_balance, widget.monumentData['type'] ?? "Landmark"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(_reviews.length.toString(), "Reviews"),
                        _buildDivider(),
                        _buildStat(widget.monumentData['city'] ?? "Maroc", "Region"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text("Historical Context",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    widget.monumentData['description'] ?? "No description available.",
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  if (images.length > 1) ...[
                    const Text("Visitor Gallery", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) => Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(images[index]['image_url']), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  _buildReviewSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Community Insights",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: _showAddReviewSheet,
              icon: const Icon(Icons.add_comment, color: Color(0xFF006233)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isLoadingReviews)
          const Center(child: CircularProgressIndicator(color: Color(0xFF006233)))
        else if (_reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text("No reviews yet. Be the first to share your experience!",
                style: TextStyle(color: Colors.grey)),
          )
        else
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final profile = review['profiles'];
                return _buildHorizontalReviewCard(
                  review['comment'] ?? "",
                  profile['full_name'] ?? "Anonymous",
                  review['rating'] ?? 5,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontalReviewCard(String review, String user, int rating) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
                5,
                (i) => Icon(Icons.star,
                    size: 14, color: i < rating ? Colors.amber : Colors.grey.shade300)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              review,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.account_circle, size: 20, color: Color(0xFF006233)),
              const SizedBox(width: 8),
              Text(user, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF006233).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF006233)),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(color: Color(0xFF006233), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildDivider() => Container(height: 30, width: 1, color: Colors.grey.shade300);
}