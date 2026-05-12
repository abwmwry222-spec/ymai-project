import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const UltraKZApp());

class UltraKZApp extends StatelessWidget {
  const UltraKZApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020202),
        primaryColor: Colors.amber,
      ),
      home: const KZSplashScreen(),
    );
  }
}

// 1. شاشة الترحيب (LOGO)
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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KZMainHandler()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 2),
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 30)],
              ),
              child: const Text('K.Z', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 8)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.amber, strokeWidth: 1),
          ],
        ),
      ),
    );
  }
}

// 2. معالج الشاشات (الشريط السفلي المريح)
class KZMainHandler extends StatefulWidget {
  const KZMainHandler({super.key});
  @override
  _KZMainHandlerState createState() => _KZMainHandlerState();
}

class _KZMainHandlerState extends State<KZMainHandler> {
  int _selectedIndex = 0;
  
  // وضع المطور الملكي (كل شيء مجاني لك)
  final bool isDeveloper = true;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildStorePage(),    // المتاجر
      _buildWalletPage(),   // المحفظة
      _buildCreatorPage(),  // أدوات المونتاج والتصميم
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('K.Z SUPREME STUDIO', style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          pages[_selectedIndex],
          _buildPersistentWatermark(), // العلامة المائية الثابتة
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white24,
        backgroundColor: const Color(0xFF050505),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المتاجر'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet_membership), label: 'المحفظة'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'التصميم'),
        ],
      ),
    );
  }

  // صفحة المتاجر الشاملة
  Widget _buildStorePage() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 15, crossAxisSpacing: 15,
      children: [
        _storeCard('تيك توك تريند', Icons.bolt, Colors.pinkAccent),
        _storeCard('مقدمات فيديو', Icons.play_circle, Colors.blueAccent),
        _storeCard('خطوط عربية', Icons.text_fields, Colors.orangeAccent),
        _storeCard('قوالب VIP', Icons.stars, Colors.amber),
      ],
    );
  }

  // صفحة المحفظة الذهبية
  Widget _buildWalletPage() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF000000)]),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.amberAccent.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('K-COINS BALANCE', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(isDeveloper ? 'UNLIMITED' : '2,500', style: const TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w900)),
                ],
              ),
              const Icon(Icons.account_balance_wallet, color: Colors.black, size: 40),
            ],
          ),
        ),
        const Text('جميع الميزات مفتوحة لك كمطور 👑', style: TextStyle(color: Colors.amber, fontSize: 12)),
      ],
    );
  }

  // صفحة التصميم والمونتاج
  Widget _buildCreatorPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _actionBtn('بدء مونتاج فيديو', Icons.video_collection),
          const SizedBox(height: 20),
          _actionBtn('تصميم صورة احترافية', Icons.add_photo_alternate),
        ],
      ),
    );
  }

  Widget _storeCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 35), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 12))]),
    );
  }

  Widget _actionBtn(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
    );
  }

  Widget _buildPersistentWatermark() {
    return Positioned(
      bottom: 10, left: 0, right: 0,
      child: Center(child: Text('DESIGNED BY K.Z OFFICIAL', style: TextStyle(color: Colors.white.withOpacity(0.05), fontSize: 8, letterSpacing: 5))),
    );
  }
}
