import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SmartSafetyApp());
}

class SmartSafetyApp extends StatelessWidget {
  const SmartSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alaw Tiluk's Dashboard",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: const Color(0xFFECFFF5),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFECFFF5),
          secondary: const Color(0xFF00D96F),
          surface: Colors.white,
          onPrimary: Colors.black,
          onSurface: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF66),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
