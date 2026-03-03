import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';
import 'providers/task_provider.dart';
import 'auth/login_screen.dart';
import 'dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  final String url = dotenv.env['SUPABASE_URL']!.trim();
  final String anonKey = dotenv.env['SUPABASE_ANON_KEY']!.trim();
  
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
  );
  
  // TEST CONNECTION
  try {
    final response = await Supabase.instance.client.from('tasks').select('count');
    debugPrint(" Supabase connected: $response");
  } catch (e) {
    debugPrint(" Supabase test failed: $e");
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Mini TaskHub',
        theme: AppTheme.themeData,
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return snapshot.data != null ? DashboardScreen() : LoginScreen();
          },
        );
      },
    );
  }
}
