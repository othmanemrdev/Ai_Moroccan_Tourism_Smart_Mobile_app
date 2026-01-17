import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import '../favorites/favorites_screen.dart';
import '../itinerary/itinerary_screen.dart';
import '../profile/profile_screen.dart';
import '../costs/cost_estimator_screen.dart'; 
import 'widgets/moroccan_sidebar.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;

  // The order here MUST match the order of BottomNavigationBarItem below
  final List<Widget> _screens = [
    const HomeScreen(),            // Index 0
    const FavoritesScreen(),       // Index 1
    const ItineraryScreen(),       // Index 2
    const CostEstimatorScreen(),   // Index 3 (Now pointing to the right file)
    const ProfileScreen(),         // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
<<<<<<< HEAD
    final String displayName = user?.userMetadata?['display_name'] ??
                                user?.email?.split('@')[0] ?? 
                                "Explorer";
=======
    final String displayName = user?.email?.split('@')[0] ?? "Explorer";
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

    return Scaffold(
      drawer: MoroccanSidebar(
        userName: displayName,
        onLogout: () async {
          try {
            await Supabase.instance.client.auth.signOut();
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error signing out")),
              );
            }
          }
        },
      ),
      
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), 
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF006233), 
          unselectedItemColor: Colors.grey[400],
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Trip',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'Costs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}