import 'package:flutter/material.dart';
// Import your feature screens based on your file structure
import '../../translator/translator_screen.dart';
import '../../itinerary/itinerary_screen.dart';
import '../../classifier/food_classifier_screen.dart';
import '../../classifier/monument_classifier_screen.dart';
<<<<<<< HEAD
import '../../profile/profile_screen.dart';
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

class MoroccanHeader extends StatelessWidget {
  final String userName;
  final String? avatarUrl;

  const MoroccanHeader({super.key, required this.userName, this.avatarUrl});

  void _showVisionOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Vision AI Classifier",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // ListTile naturally has a cursor pointer on Web,
              // but we can wrap it if you need custom behavior
              ListTile(
                leading: const Icon(Icons.fastfood, color: Color(0xFF006233)),
                title: const Text("Identify Moroccan Food"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodClassifierScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.fort, color: Color(0xFF006233)),
                title: const Text("Identify Monuments"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonumentClassifierScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 25),
      decoration: const BoxDecoration(
        color: Color(0xFF006233), // Moroccan Green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notes,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    "Welcome to Morocco",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    "Hello, $userName",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Wrap Avatar if you plan to make it clickable
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
<<<<<<< HEAD
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
=======
                    /* Profile logic */
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white24,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Explore monuments, food...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF006233)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToolBtn(
                context,
                Icons.translate,
                "Translator",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TranslatorScreen(),
                  ),
                ),
              ),
              _buildToolBtn(
                context,
                Icons.camera_enhance,
                "Vision AI",
                () => _showVisionOptions(context),
              ),
              _buildToolBtn(
                context,
                Icons.auto_awesome,
                "Planner",
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ItineraryScreen(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolBtn(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
