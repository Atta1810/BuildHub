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


  PopupMenuItem<String> _buildAiMenuItem(IconData icon, String title, bool isDark) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFE07856).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: const Color(0xFFE07856), size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF2D2D2D),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Theme Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                context,
                icon: Icons.light_mode,
                title: 'Light',
                value: ThemeMode.light,
                isDark: isDark,
              ),
              _buildThemeOption(
                context,
                icon: Icons.dark_mode,
                title: 'Dark',
                value: ThemeMode.dark,
                isDark: isDark,
              ),
              _buildThemeOption(
                context,
                icon: Icons.brightness_auto,
                title: 'System',
                value: ThemeMode.system,
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      BuildContext context, {
        required IconData icon,
        required String title,
        required ThemeMode value,
        required bool isDark,
      }) {
    final isSelected = widget.currentTheme == value;
    return InkWell(
      onTap: () {
        widget.onThemeChanged(value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        color: isSelected
            ? const Color(0xFFE07856).withOpacity(0.08)
            : Colors.transparent,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE07856)
                    : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFFE07856) : (isDark ? Colors.white : Colors.black87),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFE07856),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 35,
              fit: BoxFit.contain,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : const Color(0xFF2D2D2D),
            ),
            onPressed: () {},
          ),

          PopupMenuButton<String>(
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: isDark ? const Color(0xFF1C1C1B) : Colors.white,
            tooltip: 'AI Tools',
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE07856).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFFE07856),
                size: 20,
              ),
            ),
            itemBuilder: (BuildContext context) => [
              _buildAiMenuItem(Icons.auto_awesome, 'Ai Builder', isDark),
              _buildAiMenuItem(Icons.chat_bubble_rounded, 'Ai Assistant', isDark),
              _buildAiMenuItem(Icons.show_chart_rounded, 'Benchmark Prediction', isDark),
            ],
          ),

          const SizedBox(width: 12),

          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFE07856).withOpacity(0.15)
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.currentTheme == ThemeMode.dark
                    ? Icons.dark_mode
                    : widget.currentTheme == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.brightness_auto,
                color: isDark ? const Color(0xFFE07856) : Colors.black54,
                size: 20,
              ),
            ),
            onPressed: _showThemeMenu,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                    const Color(0xFF1C1C1B),
                    const Color(0xFF141413),
                    const Color(0xFF141413),
                  ]
                      : [
                    const Color(0xFFFFF5F0),
                    const Color(0xFFFDFCFB),
                    const Color(0xFFF5F7FF),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF2D2D2D),
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'PC building, simplified',
                            speed: const Duration(milliseconds: 100),
                            textAlign: TextAlign.center,
                          ),
                          TypewriterAnimatedText(
                            'From parts to performance',
                            speed: const Duration(milliseconds: 100),
                            textAlign: TextAlign.center,
                          ),
                          TypewriterAnimatedText(
                            'Next-level PC building',
                            speed: const Duration(milliseconds: 100),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Build smarter, BuildHub',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Featuring part compatibility, price comparison, and real-world performance insights.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.build_rounded, size: 20),
                        label: const Text('Start Building'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE07856),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _openWebsite,
                        icon: const Icon(Icons.language_rounded),
                        label: const Text('Visit Website'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                          foregroundColor: isDark ? Colors.white : const Color(0xFF2D2D2D),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              height: 100,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _brandImages.length * 100,
                itemBuilder: (context, index) {
                  final brandIndex = index % _brandImages.length;
                  final isColored = _selectedBrands.contains(brandIndex);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isColored) {
                          _selectedBrands.remove(brandIndex);
                        } else {
                          _selectedBrands.add(brandIndex);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      padding: const EdgeInsets.all(15),
                      width: 160,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1C1C1B) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: isColored
                            ? [BoxShadow(color: const Color(0xFFE07856).withOpacity(0.2), blurRadius: 10, spreadRadius: 1)]
                            : [],
                        border: Border.all(
                            color: isColored
                                ? const Color(0xFFE07856).withOpacity(0.5)
                                : (isDark ? Colors.grey[900]! : Colors.black.withOpacity(0.05))
                        ),
                      ),
                      child: ColorFiltered(
                        colorFilter: isColored
                            ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                            : const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0,      0,      0,      1, 0,
                        ]),
                        child: Image.asset(
                          _brandImages[brandIndex],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BundlesScreen(
                          onThemeChanged: widget.onThemeChanged,
                          currentTheme: widget.currentTheme,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE07856), Color(0xFFFF9A7A)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.inventory_2_rounded, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Explore Bundles',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

