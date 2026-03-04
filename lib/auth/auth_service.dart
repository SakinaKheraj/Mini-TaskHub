import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles everything related to User management: Sign In, Sign Up, and Logout.
/// It acts as a wrapper around Supabase Auth to keep our UI simple.
class AuthService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  User? _user;

  /// Returns the currently logged in user, if any.
  User? get currentUser => _user ?? supabase.auth.currentUser;

  AuthService() {
    _init();
  }

  /// Sets up a listener to detect when a user logs in or out.
  void _init() {
    _user = supabase.auth.currentUser;
    supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  /// A stream that gives us the latest User state whenever it changes.
  Stream<User?> get authStateChanges =>
      supabase.auth.onAuthStateChange.map((data) => data.session?.user);

  /// Authenticates an existing user with email and password.
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _user = response.user;
      notifyListeners();
      return _user;
    } catch (e) {
      rethrow;
    }
  }

  /// Creates a new user account and saves their username to metadata.
  Future<User?> signUp(String email, String password, String username) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );
      _user = response.user;
      notifyListeners();
      return _user;
    } catch (e) {
      rethrow;
    }
  }

  /// Clears the session on both the server and the app.
  Future<void> signOut() async {
    await supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }
}
