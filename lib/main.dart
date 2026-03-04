import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'auth/login_screen.dart';
import 'dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables for Supabase configuration
  await dotenv.load(fileName: ".env");

  final String url = dotenv.env['SUPABASE_URL']!.trim();
  final String anonKey = dotenv.env['SUPABASE_ANON_KEY']!.trim();

  // Initialize Supabase with the loaded credentials
  await Supabase.initialize(url: url, anonKey: anonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Mini TaskHub',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

/// A simple wrapper that listens to auth state changes.
/// If a user is logged in, it shows the Dashboard; otherwise, the Login screen.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          initialData: authService.currentUser,
          builder: (context, snapshot) {
            return snapshot.data != null
                ? const DashboardScreen()
                : const LoginScreen();
          },
        );
      },
    );
  }
}
