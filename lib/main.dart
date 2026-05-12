import 'package:flutter/material.dart';

void main() => runApp(const UltraApp());

class UltraApp extends StatelessWidget {
  const UltraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.amber),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('K.Z ULTRA TOOLS', style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.workspace_premium, color: Colors.amber), onPressed: () => _vipAccess(context)),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(15),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildToolCard(context, 'إزالة الخلفية', Icons.auto_fix_high, Colors.blueAccent),
                _buildToolCard(context, 'مونتاج سريع', Icons.video_camera_back, Colors.redAccent),
                _buildToolCard(context, 'فلاتر نيون', Icons.palette, Colors.purpleAccent),
                _buildToolCard(context, 'قوالب جبارة', Icons.Layers, Colors.greenAccent),
              ],
            ),
          ),
          _buildWatermark(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text("ماذا سنصنع اليوم؟", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300)),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: () => _openTool(context, title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: color),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWatermark() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Opacity(
        opacity: 0.4,
        child: Text('PROUDLY DEVELOPED BY K.Z', style: TextStyle(fontSize: 10, letterSpacing: 3, color: Colors.amber[100])),
      ),
    );
  }

  void _openTool(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('جاري فتح أداة $name بسلاسة...'), behavior: SnackBarBehavior.floating),
    );
  }

  void _vipAccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.amber,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: const Text('مرحباً بك في عالم VIP K.Z - جميع الأدوات مفتوحة الآن!', 
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
