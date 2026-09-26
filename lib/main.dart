import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/user_details_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WT Winds',
      theme: ThemeData(useMaterial3: true),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/booking': (context) => BookingScreen(),
        '/userDetails': (context) => const UserDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}