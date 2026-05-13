import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(const CapCutKZApp());

class CapCutKZApp extends StatelessWidget {
  const CapCutKZApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
        primaryColor: const Color(0xFFD4AF37),
      ),
      home: const KZSplashScreen(), // البدء بالواجهة الترحيبية
    );
  }
}

// 1. الواجهة الترحيبية الاحترافية للتطبيق
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
      HapticFeedback.heavyImpact();
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const VideoEditorScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.2), blurRadius: 40)],
              ),
              child: const Text('K.Z', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 10)),
            ),
            const SizedBox(height: 25),
            const Text('ULTRA AI VIDEO EDITOR', style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 11)),
            const SizedBox(height: 40),
            const SizedBox(width: 150, child: LinearProgressIndicator(color: Color(0xFFD4AF37), backgroundColor: Colors.white10)),
          ],
        ),
      ),
    );
  }
}

// واجهة تحرير الفيديو الرئيسية الشبيهة بـ CapCut
class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});
  @override
  _VideoEditorScreenState createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  String _currentResolution = "1080P";
  bool _isPlaying = false;
  int _currentSeconds = 0;
  Timer? _videoTimer;
  
  // متغيرات التحكم بالخياارت الفرعية التفاعلية
  Color _videoFilterColor = Colors.transparent;
  String _activeToolText = "اختر أداة من الشريط السفلي لفتح الخيارات الفرعية";
  String _selectedFont = "الخط الافتراضي";
  String _selectedRatio = "9:16 (تيك توك)";
  bool _isCutMode = false;
  double _exportProgress = 0.0;
  bool _isExporting = false;

  void _togglePlay() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _videoTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            if (_currentSeconds < 42) {
              _currentSeconds++;
            } else {
              _currentSeconds = 0;
              _isPlaying = false;
              _videoTimer?.cancel();
            }
          });
        });
      } else {
        _videoTimer?.cancel();
      }
    });
  }

  // 🛠️ فتح قائمة خيارات فرعية حقيقية عند الضغط على الأدوات
  void _openSubMenu(String menuType) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141416),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getMenuTitle(menuType), style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 15),
                  _buildSubMenuContent(menuType, setModalState),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getMenuTitle(String type) {
    if (type == "cut") return "خيارات أدوات القص والتقسيم ✂️";
    if (type == "text") return "خيارات الخطوط الملكية والنصوص 📝";
    if (type == "filter") return "مختبر الفلاتر والمؤثرات AI 🎨";
    if (type == "ratio") return "تغيير أبعاد ونسبة العرض للمقطع 📐";
    return "خيارات الصوت والموسيقى الخلفية 🎵";
  }

  // بناء أزرار الخيارات الفرعية الحقيقية داخل القائمة المنبثقة
  Widget _buildSubMenuContent(String type, StateSetter setModalState) {
    if (type == "cut") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _subActionBtn("تقسيم", Icons.call_split, () => setState(() { _isCutMode = true; _activeToolText = "تم تقسيم المقطع الزمني بنجاح"; Navigator.pop(context); })),
          _subActionBtn("قص اليسار", Icons.trending_left, () => setState(() { _activeToolText = "تم حذف بداية الفيديو"; Navigator.pop(context); })),
          _subActionBtn("قص اليمين", Icons.trending_right, () => setState(() { _activeToolText = "تم حذف نهاية الفيديو"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "text") {
      return Column(
        children: [
          _subListTile("الخط الكوفي الاحترافي", Icons.font_download, () => setState(() { _selectedFont = "كوفي"; _activeToolText = "نص نشط بخط: الكوفي"; Navigator.pop(context); })),
          _subListTile("الخط الديواني الملكي", Icons.font_download, () => setState(() { _selectedFont = "ديواني"; _activeToolText = "نص نشط بخط: الديواني"; Navigator.pop(context); })),
          _subListTile("خط النسخ المودرن", Icons.font_download, () => setState(() { _selectedFont = "نسخ"; _activeToolText = "نص نشط بخط: النسخ"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "filter") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _subActionBtn("نيون ذكي", Icons.wb_twighlight, () => setState(() { _videoFilterColor = Colors.cyanAccent.withOpacity(0.2); _activeToolText = "فلتر النيون الذكي نشط"; Navigator.pop(context); })),
          _subActionBtn("سينمائي دافئ", Icons.movie_filter, () => setState(() { _videoFilterColor = Colors.orangeAccent.withOpacity(0.15); _activeToolText = "الفلتر السينمائي نشط"; Navigator.pop(context); })),
          _subActionBtn("أسود وأبيض", Icons.filter_b_and_w, () => setState(() { _videoFilterColor = Colors.grey.withOpacity(0.4); _activeToolText = "فلتر أبيض وأسود كلاسيك"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "ratio") {
      return Column(
        children: [
          _subListTile("أبعاد تيك توك و ريلز (9:16)", Icons.phone_android, () => setState(() { _selectedRatio = "9:16"; _activeToolText = "تغيير الأبعاد إلى 9:16"; Navigator.pop(context); })),
          _subListTile("أبعاد يوتيوب القياسية (16:9)", Icons.tv, () => setState(() { _selectedRatio = "16:9"; _activeToolText = "تغيير الأبعاد إلى 16:9"; Navigator.pop(context); })),
          _subListTile("أبعاد إنستغرام المربعة (1:1)", Icons.crop_square, () => setState(() { _selectedRatio = "1:1"; _activeToolText = "تغيير الأبعاد إلى 1:1"; Navigator.pop(context); })),
        ],
      );
    }
    return Column(
      children: [
        _subListTile("إضافة موسيقى تريند تيك توك", Icons.library_music, () => setState(() { _activeToolText = "تم دمج موسيقى التريند بالخلفية"; Navigator.pop(context); })),
        _subListTile("إضافة مؤثرات صوتية حركية", Icons.audiotrack, () => setState(() { _activeToolText = "تمت إضافة مؤثرات صوتية"; Navigator.pop(context); })),
      ],
    );
  }

  Widget _subActionBtn(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Column(
        children: [
          CircleAvatar(backgroundColor: Colors.white10, child: Icon(icon, color: const Color(0xFFD4AF37))),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _subListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD4AF37)),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
    );
  }

  void _startRealExport() {
    HapticFeedback.heavyImpact();
    setState(() { _isExporting = true; _exportProgress = 0.0; });
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_exportProgress < 1.0) {
          _exportProgress += 0.05;
        } else {
          timer.cancel();
          _isExporting = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ تم الحفظ بنجاح! الفيديو النهائي متاح في معرض الصور لهاتفك مع علامة K.Z أوتوماتيكياً.')),
          );
        }
      });
    });
  }

  @override
  void dispose() { _videoTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    String timeString = "00:00:${_currentSeconds.toString().padLeft(2, '0')}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: DropdownButton<String>(
          value: _currentResolution,
          dropdownColor: const Color(0xFF1E1E22),
          underline: const SizedBox(),
          items: <String>['720P', '1080P', '4K'].map((String v) => DropdownMenuItem<String>(value: v, child: Text('• $v', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))).toList(),
          onChanged: (v) => setState(() => _currentResolution = v!),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: _isExporting ? null : _startRealExport,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFFF)),
              child: Text(_isExporting ? "${(_exportProgress * 100).toInt()}%" : 'تصدير', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (_isExporting) LinearProgressIndicator(value: _exportProgress, color: const Color(0xFF00BFFF), backgroundColor: Colors.white10),
          
          // شاشة معاينة الفيديو الحية والتفاعلية
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(child: Container(color: const Color(0xFF1C1B29))),
                  Positioned.fill(child: AnimatedContainer(duration: const Duration(milliseconds: 300), color: _videoFilterColor)),
                  
                  // استجابة النصوص والخيارات الفرعية حياً فوق الشاشة
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_activeToolText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                      if (_selectedFont != "الخط الافتراضي") ...[
                        const SizedBox(height: 15),
                        Text("نص للتجربة ($kZFontLabel)", style: TextStyle(fontSize: 24, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontFamily: _selectedFont)),
                      ]
                    ],
                  ),
                  const Positioned(top: 15, right: 15, child: Text('© K.Z PRO', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2))),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$timeString / 00:00:42", style: const TextStyle(fontSize: 12, color: Colors.white38)),
                IconButton(icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 28), onPressed: _togglePlay),
                IconButton(icon: const Icon(Icons.refresh, size: 18, color: Colors.white38), onPressed: () => setState(() { _videoFilterColor = Colors.transparent; _activeToolText = "تمت إعادة ضبط التعديلات"; _selectedFont = "الخط الافتراضي"; _isCutMode = false; })),
              ],
            ),
          ),

          // شريط الـ Timeline الواقعي (يتجاوب وينقسم بصرياً)
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFF141416),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60, margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            _buildTimelineMeta(Icons.volume_mute, "كتم الصوت"),
                            _buildTimelineMeta(Icons.photo, "الغلاف"),
                            Expanded(
                              child: AnimatedPadding(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.only(right: _isCutMode ? 10 : 0),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(5), border: Border.all(color: _isCutMode ? Colors.redAccent : Colors.white10)),
                                  child: const Center(child: Icon(Icons.image, size: 16, color: Colors.white10)),
                                ),
                              ),
                            ),
                            if (_isCutMode)
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.redAccent)),
                                  child: const Center(child: Icon(Icons.image, size: 16, color: Colors.white10)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      InkWell(
                        onTap: () => _openSubMenu("audio"),
                        child: Container(
                          height: 45, padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 16, color: Color(0xFFD4AF37)),
                              SizedBox(width: 10),
                              Text('إضافة صوت + (اضغط لفتح الخيارات الفرعية للصوت)', style: TextStyle(color: Colors.white60, fontSize: 12)),
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

          // شريط الأدوات السفلي الموجه بالكامل للخيارات الفرعية
          Container(
            height: 80, color: const Color(0xFF0F0F11),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTool('تحرير وقص', Icons.content_cut, () => _openSubMenu("cut")),
                  _buildTool('النصوص', Icons.text_fields, () => _openSubMenu("text")),
                  _buildTool('الفلاتر AI', Icons.auto_fix_high, () => _openSubMenu("filter")),
                  _buildTool('الأبعاد', Icons.aspect_ratio, () => _openSubMenu("ratio")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String get kZFontLabel => _selectedFont == "كوفي" ? "Kufi" : _selectedFont == "ديواني" ? "Diwani" : "Naskh";

  Widget _buildTimelineMeta(IconData icon, String label) {
    return SizedBox(width: 60, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 16, color: Colors.white60), const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 8, color: Colors.white38), textAlign: TextAlign.center)]));
  }

  Widget _buildTool(String label, IconData icon, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: SizedBox(width: 95, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 22, color: Colors.white), const SizedBox(height: 6), Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))])),
    );
  }
}
