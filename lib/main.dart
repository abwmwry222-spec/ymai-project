import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const KZUltimateHome(),
    );
  }
}

class KZUltimateHome extends StatefulWidget {
  const KZUltimateHome({super.key});
  @override
  _KZUltimateHomeState createState() => _KZUltimateHomeState();
}

class _KZUltimateHomeState extends State<KZUltimateHome> {
  int _bottomIndex = 0;
  String _activeToolName = "اختر أداة لبدء المونتاج";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Text('K.Z', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        title: const Text('K.Z AI SUPREME', style: TextStyle(fontSize: 14, letterSpacing: 3, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.video_camera_back, size: 40, color: Colors.white24),
                    const SizedBox(height: 10),
                    Text(_activeToolName, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                const Positioned(
                  top: 15,
                  right: 15,
                  child: Text('© K.Z PRO', style: TextStyle(color: Colors.white10, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: _bottomIndex == 0 ? _buildEditorStudio() : _buildStorePage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (i) {
          HapticFeedback.lightImpact();
          setState(() => _bottomIndex = i);
        },
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.white24,
        backgroundColor: const Color(0xFF0A0A0A),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'استوديو المونتاج'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المتاجر'),
        ],
      ),
    );
  }

  Widget _buildEditorStudio() {
    return Column(
      children: [
        const Text('شريط أدوات صناعة الفيديو الفوري', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              _editorToolButton('قص الفيديو', Icons.content_cut, Colors.redAccent),
              _editorToolButton('إضافة صوت', Icons.music_note, Colors.blueAccent),
              _editorToolButton('نص متحرك', Icons.text_fields, Colors.orangeAccent),
              _editorToolButton('فلاتر AI', Icons.auto_fix_high, Colors.cyanAccent),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.vibrate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري حفظ الفيديو النهائي للهاتف بدقة 4K مع علامة K.Z 🚀'))
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
            child: const Text('حفظ الفيديو للهاتف', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  Widget _editorToolButton(String name, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          setState(() => _activeToolName = "أداة نشطة: $name");
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          width: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorePage() {
    return GridView.count(
      crossAxisCount: 2, padding: const EdgeInsets.all(15),
      mainAxisSpacing: 15, crossAxisSpacing: 15,
      children: [
        _storeModule('قوالب تيك توك', Icons.bolt, Colors.pinkAccent),
        _storeModule('الخطوط العربية', Icons.font_download, Colors.orangeAccent),
      ],
    );
  }

  Widget _storeModule(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0A0A0A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
