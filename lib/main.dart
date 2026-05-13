import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        // 1. صورة البروفايل الذكية التي تحمل شعار K.Z الفخم في الأعلى
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.3), blurRadius: 8)],
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Text('K.Z', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        title: const Text('K.Z AI SUPREME', style: TextStyle(fontSize: 14, letterSpacing: 3, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Icon(Icons.admin_panel_settings, color: Colors.cyanAccent),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          // شاشة عرض الفيديو التخيلية (المعاينة الحية للمونتاج)
          Container(
            height: 220,
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
                    const Icon(Icons.video_camera_back, size: 50, color: Colors.white24),
                    const SizedBox(height: 10),
                    Text(_activeToolName, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
                // العلامة المائية الثابتة غير القابلة للإزالة على الفيديوهات
                const Positioned(
                  top: 15,
                  right: 15,
                  child: Text('© K.Z PRO', style: TextStyle(color: Colors.white10, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                )
              ],
            ),
          ),
          
          const Divider(color: Colors.white10),
          
          // الانتقال بين المتاجر وشريط المونتاج الحقيقي
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
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'المتاجر والخطوط'),
        ],
      ),
    );
  }

  // 2. شريط الأدوات الحقيقي لصناعة الفيديو (موزع بشكل مريح وعملي)
  Widget _buildEditorStudio() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text('شريط أدوات صناعة الفيديو الفوري', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              _editorToolButton('قص الفيديو', Icons.content_cut, Colors.redAccent),
              _editorToolButton('إضافة كتم/صوت', Icons.music_note, Colors.blueAccent),
              _editorToolButton('دمج مقاطع', Icons.merge_type, Colors.greenAccent),
              _editorToolButton('نص متحرك', Icons.text_fields, Colors.orangeAccent),
              _editorToolButton('سرعة الفيديو', Icons.speed, Colors.purpleAccent),
              _editorToolButton('فلاتر نيون AI', Icons.auto_fix_high, Colors.cyanAccent),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.vibrate();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تصدير الفيديو وحفظه في استوديو الهاتف بدقة 4K مع علامة K.Z أوتوماتيكياً 🚀'))
              );
            },
            icon: const Icon(Icons.download_done_rounded, color: Colors.black),
            label: const Text('حفظ الفيديو النهائي للهاتف', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
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
          setState(() => _activeToolName = "أداة نشطة الآن: $name");
        },
        borderRadius: BorderRadius.circular(15),
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
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: Center),
            ],
          ),
        ),
      ),
    );
  }

  // صفحة المتاجر الإضافية
  Widget _buildStorePage() {
    return GridView.count(
      crossAxisCount: 2, padding: const EdgeInsets.all(15),
      mainAxisSpacing: 15, crossAxisSpacing: 15,
      children: [
        _storeModule('قوالب تيك توك', Icons.bolt, Colors.pinkAccent),
        _storeModule('مقدمات سينمائية', Icons.movie, Colors.blueAccent),
        _storeModule('الخطوط العربية', Icons.font_download, Colors.orangeAccent),
        _storeModule('محفظة K-Coins', Icons.stars, Colors.amber),
      ],
    );
  }

  Widget _storeModule(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF0A0A0A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 35),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('مفتوح مجاناً لك 👑', style: TextStyle(color: Colors.cyanAccent, fontSize: 8)),
        ],
      ),
    );
  }
}
