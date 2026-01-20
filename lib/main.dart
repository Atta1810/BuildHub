import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(const BuildHubApp());
}

class BuildHubApp extends StatefulWidget {
  const BuildHubApp({Key? key}) : super(key: key);

  @override
  State<BuildHubApp> createState() => _BuildHubAppState();
}

class _BuildHubAppState extends State<BuildHubApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuildHub',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFDFCFB),
        primaryColor: const Color(0xFFE07856),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDFCFB),
          foregroundColor: Color(0xFF2D2D2D),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2D2D2D)),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141413),
        primaryColor: const Color(0xFFE07856),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF141413),
          foregroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: HomeScreen(onThemeChanged: _changeTheme, currentTheme: _themeMode),
    );
  }
}
}