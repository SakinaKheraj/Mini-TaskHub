import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  User? _user;
  User? get currentUser => _user ?? supabase.auth.currentUser;

  AuthService() {
    _init();
  }

  void _init() {
    _user = supabase.auth.currentUser;
    supabase.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  Stream<User?> get authStateChanges =>
      supabase.auth.onAuthStateChange.map((data) => data.session?.user);

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

  Future<void> signOut() async {
    await supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }
}
