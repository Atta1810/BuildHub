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

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentTheme;

  const HomeScreen({
    Key? key,
    required this.onThemeChanged,
    required this.currentTheme,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  late Timer _scrollTimer;
  final double _scrollSpeed = 1.0;

  final List<String> _brandImages = [
    'assets/images/compumarts.png',
    'assets/images/noor-tech.png',
    'assets/images/sigma.png',
    'assets/images/el-nekhely.png',
    'assets/images/elbadr.png',
    'assets/images/yamama.png',
    'assets/images/alfransia.png',
    'assets/images/hardware-market.png',
  ];

  final Set<int> _selectedBrands = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;

        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            currentScroll + _scrollSpeed,
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  Future<void> _openWebsite() async {
    final Uri url = Uri.parse('https://www.buildhub.studio/en');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch website');
    }
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  