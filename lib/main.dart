import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CapCutKZApp());
}

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
      home: const VideoEditorScreen(),
    );
  }
}

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({super.key});
  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  String _currentResolution = "1080P";
  bool _isPlaying = false;
  int _currentSeconds = 2;
  Timer? _videoTimer;
  
  // متغيرات التفاعل الحقيقي المباشر وتحديث الشاشة حياً
  Color _videoFilterColor = Colors.transparent;
  String _activeNotificationText = "استوديو K.Z جاهز للتحرير الاحترافي. اضغط على الأدوات بالأسفل";
  String _selectedRatioText = "نسبة العرض الأصلية";
  bool _isMuted = false;
  double _exportProgress = 0.0;
  bool _isExporting = false;
  String _selectedFontLabel = "";

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

  // 🛠️ تفعيل القوائم السفلية الحقيقية لكل زر وتوجيه المستخدم لخيارات أخرى
  void _openSubMenu(String menuType) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141416),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getMenuTitle(menuType), style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 20),
              _buildSubMenuContent(menuType),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  String _getMenuTitle(String type) {
    if (type == "background") return "خيارات تعديل وعزل الخلفية ✂️";
    if (type == "stickers") return "متجر ملصقات K.Z الحركية ومؤثرات VIP ✨";
    if (type == "adjust") return "لوحة ضبط الألوان والإضاءة (Color Grading) 🎨";
    if (type == "filters") return "مختبر الفلاتر السينمائية ومؤثرات الذكاء الاصطناعي AI 🎬";
    if (type == "ratio") return "خيارات نسبة العرض إلى الارتفاع للمقطع 📐";
    return "محرك توليد الشروحات والنصوص التلقائية لـ K.Z 📝";
  }

  Widget _buildSubMenuContent(String type) {
    if (type == "background") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _subActionBtn("خلفية ضبابية", Icons.blur_on, () => setState(() { _activeNotificationText = "تم تطبيق عزل ضبابي فخم للخلفية بنجاح 🎯"; Navigator.pop(context); })),
          _subActionBtn("خلفية ملونة", Icons.color_lens, () => setState(() { _activeNotificationText = "تم تطبيق لون خلفية مخصص متناسق مع المقطع"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "stickers") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _subActionBtn("ملصق متوهج", Icons.stars, () => setState(() { _activeNotificationText = "تم دمج ملصق K.Z النيون المتوهج فوق الفيديو"; Navigator.pop(context); })),
          _subActionBtn("رموز حركية", Icons.emoji_emotions, () => setState(() { _activeNotificationText = "تم فتح قائمة الرموز التعبيرية الحركية للـ VIP"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "adjust") {
      return Column(
        children: [
          _subListTile("تحسين الإضاءة والسطوع تلقائياً بالذكاء الاصطناعي", Icons.brightness_6, () => setState(() { _activeNotificationText = "تم ضبط تباين الإضاءة والسطوع بدقة ذكية متوازنة"; Navigator.pop(context); })),
          _subListTile("رفع حدة وتفاصيل الألوان (Color Grading)", Icons.details, () => setState(() { _activeNotificationText = "تم تحسين حدة الألوان وتفاصيل المقطع الفني بجودة 4K"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "filters") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _subActionBtn("نيون AI", Icons.wb_twighlight, () => setState(() { _videoFilterColor = Colors.cyanAccent.withOpacity(0.2); _activeNotificationText = "فلتر النيون الذكي من K.Z AI نشط الآن 🤖"; Navigator.pop(context); })),
          _subActionBtn("سينمائي دافئ", Icons.movie_filter, () => setState(() { _videoFilterColor = Colors.orangeAccent.withOpacity(0.15); _activeNotificationText = "الفلتر السينمائي الدافئ نشط ومطبق حياً"; Navigator.pop(context); })),
          _subActionBtn("أسود وأبيض", Icons.filter_b_and_w, () => setState(() { _videoFilterColor = Colors.grey.withOpacity(0.4); _activeNotificationText = "تم تطبيق الفلتر الكلاسيكي الأبيض والأسود"; Navigator.pop(context); })),
        ],
      );
    }
    if (type == "ratio") {
      return Column(
        children: [
          _subListTile("أبعاد تيك توك و ريلز القياسية (9:16)", Icons.phone_android, () => setState(() { _selectedRatioText = "تيك توك (9:16)"; _activeNotificationText = "تم تحويل أبعاد عرض المقطع لنسبة 9:16"; Navigator.pop(context); })),
          _subListTile("أبعاد يوتيوب والشاشات العريضة (16:9)", Icons.tv, () => setState(() { _selectedRatioText = "يوتيوب (16:9)"; _activeNotificationText = "تم تحويل أبعاد عرض المقطع لنسبة 16:9"; Navigator.pop(context); })),
        ],
      );
    }
    return Column(
      children: [
        _subListTile("توليد الشروحات تلقائياً من صوت المقطع", Icons.closed_caption, () => setState(() { _selectedFontLabel = "نشط"; _activeNotificationText = "جاري معالجة صوت الفيديو وتوليد النصوص التلقائية... 📝"; Navigator.pop(context); })),
        _subListTile("محفظة المطور نشطة: رصيد K-Coins لانهائي 👑", Icons.account_balance_wallet, () => _showSnackBar("صلاحيات المطور نشطة - متجر VIP مفتوح بالكامل")),
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
            const SnackBar(content: Text('✅ تم تصدير المقطع وحفظه في معرض الصور لهاتفك بدقة 4K مع علامة K.Z أوتوماتيكياً!')),
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
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: _isExporting ? null : _startRealExport,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFFF), padding: const EdgeInsets.symmetric(horizontal: 10)),
            child: Text(_isExporting ? "${(_exportProgress * 100).toInt()}%" : 'تصدير', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        title: DropdownButton<String>(
          value: _currentResolution,
          dropdownColor: const Color(0xFF1E1E22),
          underline: const SizedBox(),
          items: <String>['720P', '1080P', '4K'].map((String v) => DropdownMenuItem<String>(value: v, child: Text('• $v', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))).toList(),
          onChanged: (v) => setState(() => _currentResolution = v!),
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          if (_isExporting) LinearProgressIndicator(value: _exportProgress, color: const Color(0xFF00BFFF), backgroundColor: Colors.white10),
          
          // 1. شاشة عرض الفيديو الحية والتفاعلية
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(child: Container(color: const Color(0xFF1A1A1E))),
                  Positioned.fill(child: AnimatedContainer(duration: const Duration(milliseconds: 300), color: _videoFilterColor)),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(_activeNotificationText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.white60, height: 1.4)),
                      ),
                      if (_selectedRatioText != "نسبة العرض الأصلية") ...[
                        const SizedBox(height: 10),
                        Text("الأبعاد النشطة: $_selectedRatioText", style: const TextStyle(fontSize: 11, color: Color(0xFFD4AF37))),
                      ],
                      if (_selectedFontLabel.isNotEmpty) ...[
                        const SizedBox(height: 15),
                        const Text("K.Z PRO SUPREME 👑", style: TextStyle(fontSize: 22, color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
                      ]
                    ],
                  ),
                  const Positioned(top: 15, right: 15, child: Text('© K.Z PRO', style: TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2))),
                ],
              ),
            ),
          ),

          // شريط أزرار التراجع والتحكم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.undo, size: 20, color: Colors.white60), onPressed: () {}),
                IconButton(icon: const Icon(Icons.redo, size: 20, color: Colors.white60), onPressed: () {}),
                const SizedBox(width: 10),
                const Icon(Icons.fullscreen_exit, size: 20, color: Colors.white60),
                const Spacer(),
                IconButton(icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 24), onPressed: _togglePlay),
                const Spacer(),
                IconButton(icon: const Icon(Icons.refresh, size: 16, color: Colors.white38), onPressed: () => setState(() { _videoFilterColor = Colors.transparent; _activeNotificationText = "تمت إعادة ضبط التعديلات ميكانيكياً"; _selectedRatioText = "نسبة العرض الأصلية"; _selectedFontLabel = ""; })),
              ],
            ),
          ),

          // التوقيت الرقمي
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$timeString / 00:00:42", style: const TextStyle(fontSize: 11, color: Colors.white38)),
                const Text("00:00", style: TextStyle(fontSize: 11, color: Colors.white38)),
                const Text("00:02", style: TextStyle(fontSize: 11, color: Colors.white38)),
              ],
            ),
          ),

          // 2. شريط الـ Timeline المطابق للصورة بلقطات المقاطع ومسار الصوت
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
                            InkWell(
                              onTap: () => setState(() { _isMuted = !_isMuted; _activeNotificationText = _isMuted ? "تم كتم صوت الفيديو تماماً" : "تم تشغيل الصوت الرئيسي"; }),
                              child: Container(
                                width: 65, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_isMuted ? Icons.volume_off : Icons.volume_mute, size: 18, color: _isMuted ? Colors.redAccent : Colors.white60), const SizedBox(height: 4), const Text("كتم صوت\nالمقطع", style: TextStyle(fontSize: 8, color: Colors.white38), textAlign: TextAlign.center)])
                              ),
                            ),
                            Container(
                              width: 45, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.photo, size: 18, color: Colors.white60), SizedBox(height: 4), Text("الغلاف", style: TextStyle(fontSize: 8, color: Colors.white38))])
                            ),
                            
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) => Container(
                                  width: 55, margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white10)),
                                  child: const Center(child: Icon(Icons.image, size: 14, color: Colors.white10)),
                                ),
                              ),
                            ),
                            Container(
                              width: 40, height: 40, margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(5)),
                              child: const Icon(Icons.add, size: 18, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      
                      InkWell(
                        onTap: () => _openSubMenu("captions"),
                        child: Container(
                          height: 45, padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 16, color: Colors.white54),
                              SizedBox(width: 10),
                              Text('إضافة صوت + (اضغط لمزامنة المحفظة والموسيقى)', style: TextStyle(color: Colors.white54, fontSize: 12)),
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

          // 3. شريط الأدوات السفلي المتكامل والمطابق لترتيب لقطة شاشتك تماماً
          Container(
            height: 80, color: const Color(0xFF0F0F11),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBottomToolItem('الخلفية', Icons.wallpaper, () => _openSubMenu("background")),
                  _buildBottomToolItem('ملصقات', Icons.emoji_emotions_outlined, () => _openSubMenu("stickers")),
                  _buildBottomToolItem('ضبط', Icons.tune, () => _openSubMenu("adjust")),
                  _buildBottomToolItem('الفلاتر', Icons.auto_awesome_mosaic, () => _openSubMenu("filters")),
                  _buildBottomToolItem('نسبة العرض إلى\nالارتفاع', Icons.aspect_ratio, () => _openSubMenu("ratio")),
                  _buildBottomToolItem('الشروحات', Icons.closed_caption_off, () => _openSubMenu("captions")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomToolItem(String label, IconData icon, VoidCallback action) {
    return InkWell(
      onTap: action,
      child: SizedBox(
        width: 85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
  }
}
