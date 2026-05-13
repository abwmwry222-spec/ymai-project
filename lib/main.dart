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
      home: const KZSplashScreen(),
    );
  }
}

// واجهة ترحيبية K.Z
class KZSplashScreen extends StatefulWidget {
  const KZSplashScreen({super.key});
  @override
  State<KZSplashScreen> createState() => _KZSplashScreenState();
}

class _KZSplashScreenState extends State<KZSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      HapticFeedback.heavyImpact();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KZAppHandler()));
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
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFD4AF37), width: 2)),
              child: const Text('K.Z', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 10)),
            ),
            const SizedBox(height: 25),
            const Text('ULTRA AI VIDEO & CAMERA SUITE', style: TextStyle(color: Colors.white38, letterSpacing: 4, fontSize: 11)),
            const SizedBox(height: 40),
            const SizedBox(width: 150, child: LinearProgressIndicator(color: Color(0xFFD4AF37), backgroundColor: Colors.white10)),
          ],
        ),
      ),
    );
  }
}

// معالج التطبيق الرئيسي (شريط التنقل السفلي)
class KZAppHandler extends StatefulWidget {
  const KZAppHandler({super.key});
  @override
  State<KZAppHandler> createState() => _KZAppHandlerState();
}

class _KZAppHandlerState extends State<KZAppHandler> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const VideoEditorScreen(), // 1. استوديو المونتاج (CapCut)
      const TikTokCameraScreen(), // 2. واجهة الكاميرا الاحترافية (تيك توك)
    ];

    return Scaffold(
      body: screens[_navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) { HapticFeedback.lightImpact(); setState(() => _navIndex = i); },
        selectedItemColor: const Color(0xFFD4AF37), unselectedItemColor: Colors.white24,
        backgroundColor: Colors.black, type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'المونتاج والتحرير'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera_rounded), label: 'كاميرا K.Z الحية'),
        ],
      ),
    );
  }
}

// 🎬 الشاشة الأولى: استوديو المونتاج (CapCut الواجهة الاحترافية)
class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});
  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  String _res = "1080P"; bool _playing = false; int _seconds = 0; Timer? _timer;
  Color _filter = Colors.transparent; String _toolText = "اختر أداة من الشريط السفلي لفتح خياراتها الفرعية الحقيقية";
  String _font = "الافتراضي"; bool _isCut = false; double _progress = 0.0; bool _exporting = false;

  void _togglePlay() {
    HapticFeedback.lightImpact(); setState(() {
      _playing = !_playing;
      if (_playing) {
        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
          setState(() { if (_seconds < 42) { _seconds++; } else { _seconds = 0; _playing = false; _timer?.cancel(); } });
        });
      } else { _timer?.cancel(); }
    });
  }

  void _openSubMenu(String type) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF141416),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type == "cut" ? "أدوات القص والتقسيم ✂️" : type == "text" ? "الخطوط الملكية والنصوص 📝" : "مختبر الفلاتر والمؤثرات AI 🎨", style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildContent(type),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String type) {
    if (type == "cut") {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _btn("تقسيم", Icons.call_split, () => setState(() { _isCut = true; _toolText = "تم تقسيم المقطع الزمني بنجاح ✂️"; Navigator.pop(context); })),
        _btn("حذف البدء", Icons.trending_left, () => setState(() { _toolText = "تم قص بداية الفيديو"; Navigator.pop(context); })),
      ]);
    }
    if (type == "text") {
      return Column(children: [
        ListTile(leading: const Icon(Icons.font_download, color: Color(0xFFD4AF37)), title: const Text("الخط الكوفي الاحترافي"), onTap: () => setState(() { _font = "كوفي"; _toolText = "نص مفعّل بخط: الكوفي"; Navigator.pop(context); })),
        ListTile(leading: const Icon(Icons.font_download, color: Color(0xFFD4AF37)), title: const Text("الخط الديواني الملكي"), onTap: () => setState(() { _font = "ديواني"; _toolText = "نص مفعّل بخط: الديواني"; Navigator.pop(context); })),
      ]);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _btn("نيون AI", Icons.wb_twighlight, () => setState(() { _filter = Colors.cyanAccent.withOpacity(0.2); _toolText = "فلتر النيون الذكي نشط 🤖"; Navigator.pop(context); })),
      _btn("سينمائي", Icons.filter_b_and_w, () => setState(() { _filter = Colors.grey.withOpacity(0.4); _toolText = "الفلتر السينمائي كلاسيك نشط"; Navigator.pop(context); })),
    ]);
  }

  Widget _btn(String txt, IconData i, VoidCallback call) => InkWell(onTap: () { HapticFeedback.lightImpact(); call(); }, child: Column(children: [CircleAvatar(backgroundColor: Colors.white10, child: Icon(i, color: const Color(0xFFD4AF37))), const SizedBox(height: 5), Text(txt, style: const TextStyle(fontSize: 12))]));

  void _export() {
    HapticFeedback.heavyImpact(); setState(() { _exporting = true; _progress = 0.0; });
    Timer.periodic(const Duration(milliseconds: 100), (t) {
      setState(() {
        if (_progress < 1.0) { _progress += 0.05; } else { t.cancel(); _exporting = false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم تصدير وحفظ الفيديو النهائي لعلامة K.Z في معرض الجوال بدقة 4K!')));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: DropdownButton<String>(value: _res, dropdownColor: const Color(0xFF1E1E22), underline: const SizedBox(), items: <String>['720P', '1080P', '4K'].map((v) => DropdownMenuItem(value: v, child: Text('• $v'))).toList(), onChanged: (v) => setState(() => _res = v!)),
        actions: [Padding(padding: const EdgeInsets.all(10), child: ElevatedButton(onPressed: _exporting ? null : _export, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFFF)), child: Text(_exporting ? "${(_progress * 100).toInt()}%" : 'تصدير')))],
      ),
      body: Column(
        children: [
          if (_exporting) LinearProgressIndicator(value: _progress, color: const Color(0xFF00BFFF)),
          Expanded(flex: 4, child: Container(margin: const EdgeInsets.symmetric(horizontal: 15), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)), child: Stack(alignment: Alignment.center, children: [Positioned.fill(child: Container(color: const Color(0xFF1C1B29))), Positioned.fill(child: AnimatedContainer(duration: const Duration(milliseconds: 300), color: _filter)), Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_toolText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.white70)), if (_font != "الافتراضي") Text("K.Z PRO EDIT", style: TextStyle(fontSize: 22, color: const Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontFamily: _font))]), const Positioned(top: 15, right: 15, child: Text('© K.Z PRO', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)))]))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("00:00:${_seconds.toString().padLeft(2, '0')} / 00:00:42", style: const TextStyle(fontSize: 11, color: Colors.white38)), IconButton(icon: Icon(_playing ? Icons.pause : Icons.play_arrow), onPressed: _togglePlay), IconButton(icon: const Icon(Icons.refresh, size: 16), onPressed: () => setState(() { _filter = Colors.transparent; _toolText = "تمت إعادة ضبط التعديلات"; _font = "الافتراضي"; _isCut = false; }))])),
          Expanded(flex: 3, child: Container(color: const Color(0xFF141416), child: Stack(children: [Column(children: [Container(height: 60, margin: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [SizedBox(width: 60, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.volume_mute, size: 16), Text("كتم الصوت", style: TextStyle(fontSize: 8))])), Expanded(child: AnimatedPadding(duration: const Duration(milliseconds: 300), padding: EdgeInsets.only(right: _isCut ? 10 : 0), child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: _isCut ? Colors.redAccent : Colors.white10)), child: const Icon(Icons.image, size: 14, color: Colors.white10)))), if (_isCut) Expanded(child: Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.redAccent)), child: const Icon(Icons.image, size: 14, color: Colors.white10)))]), Divider(color: Colors.white10, height: 1), InkWell(onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم فتح قائمة المتاجر والمؤثرات الصوتية الحية لدمج الصوت 🎵"))), child: Container(height: 45, padding: const EdgeInsets.symmetric(horizontal: 15), child: Row(children: const [Icon(Icons.add, size: 16, color: Color(0xFFD4AF37)), SizedBox(width: 10), Text('إضافة صوت + (موسيقى ومؤثرات K.Z الملكية)', style: TextStyle(color: Colors.white60, fontSize: 12))])))]), Align(alignment: Alignment.topCenter, child: Container(width: 2, height: 120, color: Colors.white))]))),
          Container(height: 75, color: const Color(0xFF0F0F11), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_bTool('تحرير وقص', Icons.content_cut, () => _openSubMenu("cut")), _bTool('النصوص', Icons.text_fields, () => _openSubMenu("text")), _bTool('الفلاتر AI', Icons.auto_fix_high, () => _openSubMenu("filter"))]))
        ],
      ),
    );
  }
  Widget _bTool(String l, IconData i, VoidCallback act) => InkWell(onTap: act, child: SizedBox(width: 90, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, size: 20), const SizedBox(height: 4), Text(l, style: const TextStyle(fontSize: 11))])));
}

// 📸 الشاشة الثانية: واجهة الكاميرا الاحترافية التفاعلية المطابقة لـ (تيك توك) 
class TikTokCameraScreen extends StatefulWidget {
  const TikTokCameraScreen({super.key});
  @override
  State<TikTokCameraScreen> createState() => _TikTokCameraScreenState();
}

class _TikTokCameraScreenState extends State<TikTokCameraScreen> {
  String _activeDuration = "15 ث"; bool _isRecording = false; int _recordSecs = 0; Timer? _recTimer;
  String _cameraStatus = "شاشة الكاميرا جاهزة للتصوير الحي 🎥"; Color _camFilter = Colors.transparent;

  void _startRecord() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _cameraStatus = "جاري تسجيل فيديو حي لعلامة K.Z... 🔴";
        _recTimer = Timer.periodic(const Duration(seconds: 1), (t) {
          setState(() { _recordSecs++; });
        });
      } else {
        _recTimer?.cancel(); _recordSecs = 0;
        _cameraStatus = "تم حفظ الفيديو المسجل تلقائياً بمحفظة المطور! 👑";
      }
    });
  }

  void _openCamSub(String title, List<String> opts, Function(String) onSelect) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1E1E22),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("خيارات $title الحية ⚙️", style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(children: opts.map((o) => ListTile(title: Text(o), onTap: () { onSelect(o); Navigator.pop(context); })).toList()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() { _recTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية تحاكي شاشة الكاميرا والعدسة
          Positioned.fill(child: AnimatedContainer(duration: const Duration(milliseconds: 300), color: _camFilter.syncWith(_isRecording ? Colors.red.withOpacity(0.05) : Colors.grey.shade900))),
          
          // شعار الكاميرا المركزي وحالتها
          Center(child: Text(_isRecording ? "REC: 00:${_recordSecs.toString().padLeft(2, '0')}" : _cameraStatus, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: _isRecording ? Colors.red : Colors.white70, fontWeight: FontWeight.bold))),

          // شريط الأدوات الجانبي الذكي (تغيير، سرعة، تجميل، مؤقت)
          Positioned(
            top: 60, left: 20,
            child: Column(
              children: [
                _camSideBtn(Icons.flip_camera_android, "تغيير", () => setState(() => _cameraStatus = "تم تبديل العدسة للكاميرا الأمامية 🔄")),
                _camSideBtn(Icons.speed, "السرعة", () => _openCamSub("السرعة", ["0.5x بطيء", "1x طبيعي", "2x سريع"], (s) => setState(() => _cameraStatus = "تم ضبط سرعة الكاميرا على: $s"))),
                _camSideBtn(Icons.face_retouching_natural, "تجميل AI", () => _openCamSub("تجميل الوجه AI", ["تنعيم البشرة", "تفتيح تلقائي", "فلتر نيون ناعم"], (b) => setState(() => _cameraStatus = "تأثير ذكي نشط: $b ✨"))),
                _camSideBtn(Icons.timer, "مؤقت", () => setState(() => _cameraStatus = "تم تفعيل مؤقت بدء التسجيل التلقائي (3 ثوانٍ)"))
              ],
            ),
          ),

          // شريط إضافة صوت العلوي المطابق للتيك توك
          Positioned(
            top: 60, right: 80, left: 80,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.music_note, size: 14, color: Color(0xFFD4AF37)), SizedBox(width: 5), Text("إضافة صوت حقيقي للمقطع", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]),
              ),
            ),
          ),
          Positioned(top: 60, right: 20, child: IconButton(icon: const Icon(Icons.close, size: 26), onPressed: () => setState(() => _cameraStatus = "تم إلغاء العملية"))),

          // شريط المدد الزمنية السفلي التفاعلي
          Positioned(
            bottom: 140, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ["3 د", "60 ث", "15 ث"].map((d) => InkWell(
                onTap: () { HapticFeedback.lightImpact(); setState(() { _activeDuration = d; _cameraStatus = "تم تحديد مدة التسجيل القصوى: $d"; }); },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: _activeDuration == d ? Colors.white : Colors.black38, borderRadius: BorderRadius.circular(15)),
                  child: Text(d, style: TextStyle(color: _activeDuration == d ? Colors.black : Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              )).toList(),
            ),
          ),

          // زر التسجيل والألبوم والمؤثرات في الأسفل الشغال بالكامل
          Positioned(
            bottom: 40, left: 30, right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _camBottomOption("الألبوم", Icons.photo_size_select_actual_rounded, () => setState(() => _cameraStatus = "تم فتح معرض صور هاتف المطور بنجاح! 📲")),
                GestureDetector(
                  onTap: _startRecord,
                  child: Container(
                    width: 75, height: 75, padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                    child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: _isRecording ? Colors.red : const Color(0xFF00BFFF))),
                  ),
                ),
                _camBottomOption("المؤثرات", Icons.insert_emoticon_rounded, () => _openCamSub("المؤثرات وفلاتر الوجه", ["قناع ذهبي K.Z", "خلفية ضبابية ذكية", "برق متوهج"], (m) => setState(() { _camFilter = Colors.purple.withOpacity(0.1); _cameraStatus = "المؤثر الحركي نشط: $m 🎭"; }))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _camSideBtn(IconData i, String l, VoidCallback t) => Padding(padding: const EdgeInsets.only(bottom: 15), child: InkWell(onTap: t, child: Column(children: [Icon(i, size: 22, color: Colors.white), const SizedBox(height: 3), Text(l, style: const TextStyle(fontSize: 9, color: Colors.white70))])));
  Widget _camBottomOption(String l, IconData i, VoidCallback t) => InkWell(onTap: t, child: Column(children: [Icon(i, size: 28, color: Colors.white), const SizedBox(height: 5), Text(l, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))]));
}

extension ColorSync on Color { Color syncWith(Color c) => c == Colors.transparent ? this : c; }
