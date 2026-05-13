import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const CapCutKZApp());

class CapCutKZApp extends StatelessWidget {
  const CapCutKZApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
      ),
      home: const VideoEditorScreen(),
    );
  }
}

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});
  @override
  _VideoEditorScreenState createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  String _currentResolution = "1080P";
  bool _isPlaying = false;
  String _currentTime = "00:00:02";
  String _activeToolTitle = "لوحة التحرير الرئيسية جاهزة";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () {}),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _currentResolution,
              dropdownColor: const Color(0xFF1E1E22),
              underline: const SizedBox(),
              items: <String>['720P', '1080P', '2K/4K'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('• $value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _currentResolution = newValue!),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.vibrate();
                _showSnackBar("جاري تصدير ومزامنة الفيديو بدقة $_currentResolution ومعالجة كافة التعديلات... 🚀");
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFFF)),
              child: const Text('تصدير', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // شاشة عرض المقطع الحية
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.movie_creation, size: 60, color: Colors.white10),
                  Positioned(
                    bottom: 20,
                    child: Text(_activeToolTitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  ),
                  const Positioned(
                    top: 15, right: 15,
                    child: Text('© K.Z PRO', style: TextStyle(color: Colors.white30, fontSize: 11, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),

          // شريط التحكم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$_currentTime / 00:00:42", style: const TextStyle(fontSize: 12, color: Colors.white38)),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 28),
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
                const Icon(Icons.fullscreen, size: 22, color: Colors.white60),
              ],
            ),
          ),

          // شريط الـ Timeline المتكامل (فيديو + صوت)
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF141416),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            _buildTimelineMeta(Icons.volume_mute, "كتم الصوت"),
                            _buildTimelineMeta(Icons.photo, "الغلاف"),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 8,
                                itemBuilder: (context, index) => Container(
                                  width: 60, margin: const EdgeInsets.symmetric(horizontal: 1),
                                  color: Colors.white.withOpacity(0.05),
                                  child: Icon(Icons.image, size: 16, color: Colors.white.withOpacity(0.1)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      InkWell(
                        onTap: () => _showSnackBar("تم تفعيل مسار الصوت حركياً: اختر ملف الموسيقى 🎵"),
                        child: Container(
                          height: 45, padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 16, color: Colors.white60),
                              SizedBox(width: 10),
                              Text('إضافة صوت + (مؤثرات وموسيقى الكابكوت)', style: TextStyle(color: Colors.white60, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(alignment: Alignment.topCenter, child: Container(width: 2, height: 120, color: Colors.white)),
                ],
              ),
            ),
          ),

          // شريط الأدوات الممتد الشامل (كافة ميزات وأزرار CapCut الحركية)
          Container(
            height: 80,
            color: const Color(0xFF0F0F11),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTool('تحرير وقص', Icons.content_cut, () => _openToolPanel("أداة القص والتقسيم الذكي نشطة")),
                  _buildTool('الصوتيات', Icons.music_note, () => _openToolPanel("مكتبة المؤثرات الصوتية مفتوحة")),
                  _buildTool('النصوص', Icons.text_fields, () => _openToolPanel("لوحة إضافة النصوص والخطوط الملكية")),
                  _buildTool('الملصقات', Icons.emoji_emotions, () => _openToolPanel("متجر الملصقات الحركية مفتوح")),
                  _buildTool('المؤثرات', Icons.auto_fix_high, () => _openToolPanel("معالج مؤثرات الفيديو AI نشط")),
                  _buildTool('الفلاتر', Icons.filter_b_and_w, () => _openToolPanel("تم تفعيل فلاتر التصحيح اللوني السينمائي")),
                  _buildTool('الضبط', Icons.tune, () => _openToolPanel("لوحة التحكم بالسطوع والتباين والـ Grading")),
                  _buildTool('الأبعاد', Icons.aspect_ratio, () => _openToolPanel("تغيير أبعاد العرض (9:16 تيك توك، 16:9 يوتيوب)")),
                  _buildTool('الخلفية', Icons.blur_on, () => _openToolPanel("تم تفعيل عزل وتعديل خلفية الفيديو")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineMeta(IconData icon, String label) {
    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white60),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white38), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTool(String label, IconData icon, VoidCallback action) {
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        action();
      },
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.white),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  void _openToolPanel(String title) {
    setState(() => _activeToolTitle = title);
    _showSnackBar("تم تنشيط: $title ✅");
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)),
    );
  }
}
