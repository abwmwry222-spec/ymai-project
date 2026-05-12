import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const UltraApp());

class UltraApp extends StatelessWidget {
  const UltraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const SplashScreen(),
    );
  }
}

// شاشة الترحيب الاحترافية بالشعار الذهبي
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainHomeScreen())
      );
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
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 30, spreadRadius: 5)
                ],
              ),
              child: const Text(
                'K.Z',
                style: TextStyle(
                  fontSize: 55, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.amber, 
                  letterSpacing: 8
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'ULTRA EDITING SUITE',
              style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 12),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.amber, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}

// الواجهة الرئيسية (المتجر والأدوات)
class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('K.Z DASHBOARD', style: TextStyle(fontSize: 16, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("أدوات التصميم والمونتاج", style: TextStyle(fontSize: 18, color: Colors.amber)),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _toolCard('المونتاج الذكي', Icons.movie_filter, Colors.blue),
                _toolCard('متجر القوالب', Icons.grid_view_rounded, Colors.purple),
                _toolCard('VIP محفظة', Icons.account_balance_wallet, Colors.orange),
                _toolCard('تصدير بدقة 4K', Icons.high_quality, Colors.green),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('PROUDLY BY K.Z', style: TextStyle(color: Colors.white10, letterSpacing: 5)),
          )
        ],
      ),
    );
  }

  Widget _toolCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
