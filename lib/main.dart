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
  String _totalTime = "00:00:42";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الشريط العلوي (التصدير والدقة)
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
              onChanged: (newValue) {
                setState(() => _currentResolution = newValue!);
              },
            ),
            const SizedBox(width: 5),
            const Icon(Icons.help_outline, size: 18, color: Colors.white60),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.vibrate();
                _showSnackBar("جاري تصدير الفيديو بدقة $_currentResolution وعلامة K.Z الأبدية... 🚀");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFFF),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text('تصدير', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. شاشة عرض المقطع الحية
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // محاكاة للفيديو المرفوع في الصورة
                  Image.network(
                    'unsplash.com', // صورة مؤقتة ذكية تحاكي المقطع
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (c, o, s) => const Icon(Icons.videocam, size: 80, color: Colors.white10),
                  ),
                  // بصمة K.Z المخفية لحماية الحقوق
                  const Positioned(
                    top: 15, right: 15,
                    child: Text('© K.Z PRO', style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  )
                ],
              ),
            ),
          ),

          // شريط التحكم بالتشغيل والتوقيت
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$_currentTime / $_totalTime", style: const TextStyle(fontSize: 12, color: Colors.white38)),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 28),
                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                ),
                const Icon(Icons.fullscreen, size: 22, color: Colors.white60),
              ],
            ),
          ),

          // 2. شريط الـ Timeline الذكي الاحترافي
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF141416),
              child: Stack(
                children: [
                  Column(
                    children: [
                      // مسار لقطات الفيديو (Video Track)
                      Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            _buildTimelineMeta(Icons.volume_mute, "كتم صوت\nالمقطع"),
                            _buildTimelineMeta(Icons.photo, "الغلاف"),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 6,
                                itemBuilder: (context, index) => Container(
                                  width: 70,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  color: Colors.grey.shade800,
                                  child: const Icon(Icons.image, size: 20, color: Colors.white10),
                                ),
                              ),
                            ),
                            _buildAddMediaButton(),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      // مسار الصوت (Audio Track)
                      InkWell(
                        onTap: () => _showSnackBar("تم فتح مكتبة الأصوات لإضافة مقطع صوتي 🎵"),
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: Colors.white.withOpacity(0.02),
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 16, color: Colors.white60),
                              SizedBox(width: 10),
                              Text('إضافة صوت +', style: TextStyle(color: Colors.white60, fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // خط المؤشر الزمني الأبيض في المنتصف
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(width: 2, height: 120, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // 3. شريط الأدوات السفلي الشامل المتوفر والمفعّل بالكامل
          Container(
            height: 75,
            color: const Color(0xFF0F0F11),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBottomToolItem('الخلفية', Icons.wallpaper, () => _showSnackBar("تم تفعيل أداة تعديل الخلفية الذكية")),
                  _buildBottomToolItem('ملصقات', Icons.emoji_emotions_outlined, () => _showSnackBar("تم فتح متجر ملصقات K.Z الحصرية")),
                  _buildBottomToolItem('ضبط', Icons.tune, () => _showSnackBar("تم فتح خيارات ضبط الألوان والإضاءة")),
                  _buildBottomToolItem('الفلاتر', Icons.auto_awesome_mosaic, () => _showSnackBar("تم تفعيل فلاتر النيون السينمائية")),
                  _buildBottomToolItem('نسبة العرض', Icons.aspect_ratio, () => _showSnackBar("تم فتح إعدادات أبعاد الفيديو (9:16 أو 16:9)")),
                  _buildBottomToolItem('الشروحات', Icons.closed_caption_off, () => _showSnackBar("تم تشغيل محرك تحويل الصوت إلى نصوص تلقائياً")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimelineMeta(IconData icon, String label) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.white60),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 9, color: Colors.white38), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAddMediaButton() {
    return Container(
      width: 50, height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildBottomToolItem(String label, IconData icon, VoidCallback action) {
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

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }
}
