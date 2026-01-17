import 'package:flutter/material.dart';
import '../../auth/login_screen.dart';
import '../../classifier/food_classifier_screen.dart';
import '../../classifier/monument_classifier_screen.dart';
import '../../costs/cost_estimator_screen.dart';
import '../../favorites/favorites_screen.dart';
import '../../food/all_foods_screen.dart';
import '../../itinerary/itinerary_screen.dart';
import '../../monuments/all_monuments_screen.dart';
import '../../profile/profile_screen.dart';
import '../../safety/safety_assistant_screen.dart';
import '../../translator/translator_screen.dart';

class MoroccanSidebar extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final VoidCallback onLogout;

  const MoroccanSidebar({
    super.key,
    required this.userName,
    this.avatarUrl,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // User Profile Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF006233), // Moroccan Green
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person, size: 40, color: Color(0xFF006233))
                  : null,
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text("Verified Traveler"),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.fastfood_outlined,
                  label: "Food Classifier",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodClassifierScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.fort_outlined,
                  label: "Monument Classifier",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonumentClassifierScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.security_outlined,
                  label: "Safety Assistant",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SafetyAssistantScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.map_outlined,
                  label: "AI Trip Planner",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItineraryScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.account_balance_wallet_outlined,
                  label: "Fair Price Finder",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CostEstimatorScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.translate,
                  label: "Darija Translator",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TranslatorScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.favorite_outlined,
                  label: "My Favorites",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.restaurant_menu,
                  label: "All Foods",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllFoodsScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.museum_outlined,
                  label: "All Monuments",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllMonumentsScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_outlined,
                  label: "My Profile",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  ),
                ),
<<<<<<< HEAD
                _buildDrawerItem(
                  context: context,
                  icon: Icons.map,
                  label: "My Trips",
                  onTap: () => Navigator.pushNamed(context, '/my-trips'),
                ),
                const Divider(),
                // Settings Section:
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                const Divider(
                  height: 40,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.logout_rounded,
                  label: "Log Out",
                  color: const Color(0xFFC1272D), // Moroccan Red
                  onTap: onLogout,
                ),
              ],
            ),
          ),

          // Version/Footer
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
<<<<<<< HEAD
              "Zorbladi.ma v1.0",
=======
              "MarocGuide AI v1.0",
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = const Color(0xFF1A1A1A),
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          onTap();
        },
        horizontalTitleGap: 15, // Added space between icon and text
      ),
    );
  }
}
