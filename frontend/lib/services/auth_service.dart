import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to access the AuthService
final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream to listen to auth state changes (used in main.dart)
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  /// Updated Register logic to include Profile Metadata
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? avatarUrl,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'avatar_url': avatarUrl ?? 'https://ui-avatars.com/api/?name=$fullName',
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}