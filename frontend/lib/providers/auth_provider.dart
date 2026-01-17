import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Provides the AuthService instance
final authServiceProvider = Provider((ref) => AuthService());

// Manages the loading state during login/signup
final authLoadingProvider = StateProvider<bool>((ref) => false);

final authProvider = Provider((ref) {
  return ref.watch(authServiceProvider);
});