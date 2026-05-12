import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضروري للاهتزاز الفيزيائي
import 'dart:async';

void main() => runApp(const UltraKZApp());

class UltraKZApp extends StatelessWidget {
  const UltraKZApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000), // أسود OLED فخم
      ),
      home: const KZSplashScreen(),
    );
  }
}

class KZSplashScreen extends StatefulWidget {
  const KZSplashScreen({super.key});
  @override
  _KZSplashScreenState createState() => _KZSplashScreenState();
}

class _KZSplashScreenState extends State<KZSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      HapticFeedback.heavyImpact(); // اهتزاز عند الدخول
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KZUltimateHome()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('K.Z', style: TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: Color(0xFFD4AF37), letterSpacing: 15)),
      ),
    );
  }
}

class KZUltimateHome extends StatefulWidget {
  const KZUltimateHome({super.key});
  @override
  _KZUltimateHomeState createState() => _KZUltimateHomeState();
}

class _KZUltimateHomeState extends State<KZUltimateHome> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('K.Z SUPREME STUDIO', style: TextStyle(fontSize: 14, letterSpacing: 3, color: Color(0xFFD4AF37))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildLegendaryNav(),
    );
  }

  Widget _buildBody() {
    if (_index == 0) return _buildStore();
    if (_index == 1) return _buildWallet();
    return const Center(child: Text('إعدادات المطور K.Z'));
  }

  Widget _buildStore() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 20, crossAxisSpacing: 20,
      children: [
        _legendaryCard('تيك توك تريند', Icons.flash_on, Colors.pinkAccent),
        _legendaryCard('مقدمات 4K', Icons.movie_filter, Colors.blueAccent),
        _legendaryCard('خطوط ملكية', Icons.text_format, Colors.orangeAccent),
        _legendaryCard('VIP قوالب', Icons.workspace_premium, Colors.amber),
      ],
    );
  }

  Widget _legendaryCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact(); // اهتزاز عند الضغط
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWallet() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF000000)]),
      ),
      child: const Center(
        child: Text('K-COINS: UNLIMITED 👑', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildLegendaryNav() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (i) {
        HapticFeedback.lightImpact();
        setState(() => _index = i);
      },
      selectedItemColor: const Color(0xFFD4AF37),
      backgroundColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المتجر'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'المحفظة'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_suggest), label: 'المطور'),
      ],
    );
  }
}
