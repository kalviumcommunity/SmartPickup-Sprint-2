import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/scrollable_views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SmartPickupApp());
}

class SmartPickupApp extends StatelessWidget {
  const SmartPickupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPickup',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),

      // 🔹 First screen
      home: const LoginScreen(),

      // 🔹 App routes (clean navigation)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/scroll': (context) => const ScrollableViews(),
      },
    );
  }
}