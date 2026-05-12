import 'package:flutter/material.dart';

void main() => runApp(const UltraKZApp());

class UltraKZApp extends StatelessWidget {
  const UltraKZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF020202)),
      home: const KZMainDashboard(),
    );
  }
}

class KZMainDashboard extends StatefulWidget {
  const KZMainDashboard({super.key});

  @override
  State<KZMainDashboard> createState() => _KZMainDashboardState();
}

class _KZMainDashboardState extends State<KZMainDashboard> {
  // ميزة المبرمج: إذا كان هذا أنت، كل شيء مجاني!
  bool isDeveloper = true; 
  double myBalance = 999999; // رصيدك الخيالي كمطور

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('K.Z PRO STUDIO', style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: [
          if (isDeveloper) const Icon(Icons.admin_panel_settings, color: Colors.cyanAccent),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          _buildVIPCard(),
          _buildActionButtons(),
          const Divider(color: Colors.white10),
          Expanded(child: _buildUltimateStore()),
          _buildPersistentWatermark(), // العلامة التجارية التي تظهر دائماً
        ],
      ),
    );
  }

  Widget _buildVIPCard() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF8A6E2F)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DEVELOPER ACCESS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
              Text(isDeveloper ? 'UNLIMITED K-COINS' : '$myBalance K-Coins', 
                  style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900)),
            ],
          ),
          const Icon(Icons.verified, color: Colors.black, size: 40),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickAction(Icons.video_call, 'إنشاء فيديو'),
        _quickAction(Icons.photo_library, 'تصميم صورة'),
        _quickAction(Icons.download_for_offline, 'المحفوظات'),
      ],
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.white10, child: Icon(icon, color: Colors.amberAccent)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
      ],
    );
  }

  Widget _buildUltimateStore() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(15),
      children: [
        _storeModule('قوالب تيك توك', Icons.auto_videocam),
        _storeModule('مقدمات 4K', Icons.movie_creation),
        _storeModule('أدوات المونتاج', Icons.architecture),
        _storeModule('متجر الخطوط', Icons.text_fields),
      ],
    );
  }

  Widget _storeModule(String name, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.amberAccent),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 12)),
          if (isDeveloper) const Text('FREE FOR YOU', style: TextStyle(color: Colors.cyanAccent, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildPersistentWatermark() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Text('PROTECTED BY K.Z OFFICIAL MARK', 
        style: TextStyle(color: Colors.white10, fontSize: 9, letterSpacing: 4, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
