import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GoraCabsApp());
}

class GoraCabsApp extends StatelessWidget {
  const GoraCabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gora Cabs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Start with Welcome Screen
      home: const WelcomeScreen(),
    );
  }
}
