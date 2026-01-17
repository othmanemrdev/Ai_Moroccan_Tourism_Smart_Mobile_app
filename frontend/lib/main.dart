import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// feature imports
import 'features/auth/login_screen.dart';
<<<<<<< HEAD
import 'features/home/navigation_wrapper.dart';
import 'features/trips/my_trips_screen.dart';
=======
import 'features/home/navigation_wrapper.dart'; // Pointing to the new Wrapper
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your credentials
  await Supabase.initialize(
    url: 'https://tesfpidxjlrieadlyovx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc2ZwaWR4amxyaWVhZGx5b3Z4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcyODQ5NzIsImV4cCI6MjA4Mjg2MDk3Mn0.P5D8RCkxcTiBcTQYiU-ktQTdSZK-bsmU1u1RgabIexE',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'Zorbladi.ma',
      theme: ThemeData(
=======
      title: 'MarocGuide AI',
      theme: ThemeData(
        // Using the Imperial Red as the seed for your theme
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
        primaryColor: const Color(0xFFC1272D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC1272D),
          primary: const Color(0xFFC1272D),
<<<<<<< HEAD
          secondary: const Color(0xFF006233),
        ),
        useMaterial3: true,
      ),
      // Named routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const NavigationWrapper(),
        '/my-trips': (context) => const MyTripsScreen(),
      },
=======
          secondary: const Color(0xFF006233), // Verdant Green
        ),
        useMaterial3: true,
      ),
      // Entry point remains AuthCheck
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Session? _session;

  @override
  void initState() {
    super.initState();
    // 1. Check current session on startup
    _session = Supabase.instance.client.auth.currentSession;

    // 2. Listen for real-time auth changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (mounted) {
        setState(() {
          _session = data.session;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED: Now points to NavigationWrapper instead of HomeScreen
    if (_session != null) {
      return const NavigationWrapper();
    } else {
      return const LoginScreen();
    }
  }
}