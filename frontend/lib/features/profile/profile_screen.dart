import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
import '../auth/login_screen.dart';
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
<<<<<<< HEAD
    final String displayName = user?.userMetadata?['display_name'] ??
                                user?.email?.split('@')[0] ??
                                "Traveler";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF006233)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF006233),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
=======

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            color: Colors.white,
            child: Row(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Color(0xFF006233), child: Icon(Icons.person, size: 40, color: Colors.white)),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
<<<<<<< HEAD
                    Text(
                      displayName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Level 1: Explorer",
                      style: TextStyle(color: Color(0xFF006233), fontWeight: FontWeight.w600),
                    ),
=======
                    Text(user?.email?.split('@')[0] ?? "Traveler", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text("Level 1: Explorer", style: TextStyle(color: Color(0xFF006233), fontWeight: FontWeight.w600)),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileTile(Icons.history, "Travel History"),
          _buildProfileTile(Icons.settings, "App Settings"),
          _buildProfileTile(Icons.help_outline, "Help & Support"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFFC1272D)),
                foregroundColor: const Color(0xFFC1272D),
              ),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
<<<<<<< HEAD
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
              },
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}