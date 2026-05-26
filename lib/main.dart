import 'package:flutter/material.dart';

void main() {
  runApp(const YMAIApp());
}

class YMAIApp extends StatelessWidget {
  const YMAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMAI Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
        primaryColor: const Color(0xFF2196F3),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // شاشات التطبيق الأساسية: التعديل، الصوت، النصوص، المؤثرات، الفلاتر، اللوحة، الإعدادات
  final List<Widget> _screens = [
    const CapCutEditorScreen(),
    const Center(child: Text('شاشة الهندسة الصوتية والتحكم بالصوت')),
    const Center(child: Text('شاشة إضافة وتعديل النصوص الاحترافية')),
    const Center(child: Text('متجر قوالب ومؤثرات VIP الذكية')),
    const Center(child: Text('شاشة الفلاتر السينمائية والألوان')),
    const Center(child: Text('شاشة الخلفيات واللوحة')),
    const Center(child: Text('إعدادات التطبيق والمشروع')),
  ];

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textDirection: TextDirection.rtl),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF2196F3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: const Color(0xFF18181C)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex >= 7 ? 0 : _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: Colors.white60,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            List<String> tabs = ['تعديل', 'صوت', 'نص', 'مؤثرات', 'فلاتر', 'لوحة', 'إعدادات'];
            _showSnackBar(context, 'تم الانتقال إلى قسم: ${tabs[index]}');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.content_cut), label: 'تعديل'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'صوت'),
            BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'نص'),
            BottomNavigationBarItem(icon: Icon(Icons.star_border_purple_annsub), label: 'مؤثرات'),
            BottomNavigationBarItem(icon: Icon(Icons.blur_on), label: 'فلاتر'),
            BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'لوحة'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'إعدادات'),
          ],
        ),
      ),
    );
  }
}

class CapCutEditorScreen extends StatefulWidget {
  const CapCutEditorScreen({Key? key}) : super(key: key);

  @override
  State<CapCutEditorScreen> createState() => _CapCutEditorScreenState();
}

class _CapCutEditorScreenState extends State<CapCutEditorScreen> {
  String _currentResolution = '1080P';
  bool _isMuted = false;
  bool _isPlaying = false;
  double _exportProgress = 0.10;

  void _actionTriggered(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('الأداة نشطة الآن: $title', textDirection: TextDirection.rtl),
        duration: const Duration(milliseconds: 700),
        backgroundColor: const Color(0xFF1E1E24),
      ),
    );
  }

  void _showResolutionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF18181C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('دقة التصدير والتحكم بالجودة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('1080P (جودة عالية قياسية)'),
                  trailing: _currentResolution == '1080P' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () { setState(() => _currentResolution = '1080P'); Navigator.pop(context); },
                ),
                ListTile(
                  title: const Text('2K (دقة سينمائية مطورة)'),
                  trailing: _currentResolution == '2K' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () { setState(() => _currentResolution = '2K'); Navigator.pop(context); },
                ),
                ListTile(
                  title: const Text('4K Ultra HD (أعلى جودة فائقة)'),
                  trailing: _currentResolution == '4K' ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () { setState(() => _currentResolution = '4K'); Navigator.pop(context); },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. الشريط العلوي (الأزرار العلوية التفاعلية)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر تصدير التفاعلي
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _exportProgress = 1.0;
                      });
                      _actionTriggered('بدء تصدير الفيديو النهائي وحفظه بالمعرض');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: const Text('تصدير', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  
                  // قائمة الدقة والجودة
                  GestureDetector(
                    onTap: _showResolutionMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E24),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(_currentResolution, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // زر الدعم الفني والمساعدة
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    onPressed: () => _actionTriggered('الدعم الفني وإرشادات استخدام الذكاء الاصطناعي'),
                  ),
                  // زر الإغلاق والخروج
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => _actionTriggered('حفظ المشروع في المسودات والخروج'),
                  ),
                ],
              ),
            ),

            // 2. شاشة عرض الفيديو الرئيسية (شاشة المعاينة)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: const Color(0xFF000000),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // واجهة العرض التخيلية للمشروع
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'YMAI PROJECT EDITOR',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '© K.Z PRO \nAdvanced AI Tools',
                          textAlign: Center,
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                    // زر التشغيل والإيقاف المؤقت فوق شاشة العرض
                    Positioned(
                      bottom: 16,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay, color: Colors.white70),
                            onPressed: () => _actionTriggered('إعادة تشغيل المقطع من البداية'),
                          ),
                          const SizedBox(width: 20),
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: IconButton(
                              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                                _actionTriggered(_isPlaying ? 'تشغيل معاينة التايم لاين' : 'إيقاف المعاينة مؤقتاً');
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            // 3. شريط أدوات التايم لاين السريع (التراجع، التقسيم، إلخ)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF141418),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.undo, color: Colors.white60), onPressed: () => _actionTriggered('تراجع عن الخطوة السابقة')),
                  IconButton(icon: const Icon(Icons.redo, color: Colors.white60), onPressed: () => _actionTriggered('إعادة تطبيق الخطوة')),
                  IconButton(icon: const Icon(Icons.fullscreen, color: Colors.white60), onPressed: () => _actionTriggered('ملء الشاشة للمعاينة')),
                  const Text('00:00:02 / 00:00:42', style: TextStyle(color: Colors.white60, fontSize: 12)),
                  const Spacer(),
                  const Text('Total Clip Duration: 42s', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),

            // 4. التايم لاين الاحترافي المتكامل (ماتريكس المسارات والأزرار الجانبية)
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF141418),
                child: Row(
                  children: [
                    // الأزرار الجانبية الثابتة (كتم الصوت، الغلاف)
                    Container(
                      width: 75,
                      border: const Border(left: BorderSide(color: Colors.white10, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // كتم الصوت التفاعلي
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMuted = !_isMuted;
                              });
                              _actionTriggered(_isMuted ? 'تم كتم صوت المشروع بالكامل' : 'تم تفعيل الصوت');
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_isMuted ? Icons.volume_off : Icons.volume_up, color: _isMuted ? Colors.red : Colors.white70, size: 20),
                                const SizedBox(height: 4),
                                const Text('كتم صوت\nالمقطع', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.white60)),
                              ],
                            ),
                          ),
                          // زر الغلاف والبوستر
                          GestureDetector(
                            onTap: () => _actionTriggered('فتح معرض الصور لاختيار بوستر وغلاف للفيديو'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.portrait, color: Colors.white70, size: 20),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
                                  child: const Text('الغلاف', style: TextStyle(fontSize: 10, color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // مسارات التايم لاين المتحركة والأفقية (فيديو، صوت، نصوص، مؤثرات)
                    Expanded(
                      child: Stack(
                        children: [
                          ListView(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            children: [
                              // مسار الفيديو الرئيسي (الصور المصغرة للقصاصات)
                              Container(
                                height: 50,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: Colors.white12,
                                child: Row(
                                  children: [
                                    Container(width: 80, color: Colors.blueGrey, child: const Icon(Icons.image, size: 16)),
                                    const SizedBox(width: 2),
                                    Container(width: 120, color: Colors.grey, child: const Icon(Icons.video_file, size: 16)),
                                    const SizedBox(width: 2),
                                    Container(width: 90, color: Colors.blueGrey, child: const Icon(Icons.image, size: 16)),
                                    // زر إضافة وسائط جديد (+)
                                    IconButton(
                                      icon: const Icon(Icons.add_box, color: Colors.white),
                                      onPressed: () => _actionTriggered('إضافة مقطع فيديو أو صورة جديدة للتايم لاين'),
                                    )
                                  ],
                                ),
                              ),

                              // مسار الموجة الصوتية (Audio Waveform)
                              Container(
                                height: 35,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.2),
                                  border: Border.all(color: Colors.teal.withOpacity(0.5)),
                                ),
                                child: Row(
                                  children: List.generate(25, (index) => Container(
                                    width: 4,
                                    height: (index % 4 == 0) ? 25 : (index % 2 == 0) ? 15 : 8,
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    color: Colors.tealAccent,
                                  )),
                                ),
                              ),

                              // مسار شريط النصوص (Text Strip)
                              Container(
                                height: 30,
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Title Text', style: TextStyle(fontSize: 11, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                                ),
                              ),

                              // مسار شريط المؤثرات (Glitch Effect Strip)
                              Container(
                                height: 30,
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.purple),
                                ),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Glitch Effect (0:02-0:05)', style: TextStyle(fontSize: 11, color: Colors.purpleAccent)),
                                ),
                              ),
                            ],
                          ),

                          // خط المؤشر الزمني الأبيض المنصف للتايم لاين
                          const Align(
                            alignment: Alignment.center,
                            child: VerticalDivider(
                              color: Colors.white,
                              width: 2,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // الأزرار العمودية اليمنى (قص، سرعة، نص، فلاتر، انتقالات)
                    Container(
                      width: 65,
                      border: const Border(right: BorderSide(color: Colors.white10, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimelineActionIcon(Icons.content_cut, 'قص', () => _actionTriggered('تقسيم وقص القصاصة الحالية')),
                          _buildTimelineActionIcon(Icons.speed, 'سرعة', () => _actionTriggered('تسريع / تبطيء حركة الفيديو')),
                          _buildTimelineActionIcon(Icons.text_fields, 'نص', () => _actionTriggered('فتح لوحة المفاتيح لإضافة نص ذكي')),
                          _buildTimelineActionIcon(Icons.style, 'فلاتر', () => _actionTriggered('استعراض وتطبيق الفلاتر السينمائية')),
                          _buildTimelineActionIcon(Icons.transform, 'انتقالات', () => _actionTriggered('إضافة تأثير انتقال بين المقاطع')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. شريط حالة التصدير السفلي (Exporting Progress Bar)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF0F0F11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exporting Progress: ${(_exportProgress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _exportProgress,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // معرض وسائط سريع ومصغر في زاوية التصدير
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white12,
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=100'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineActionIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}
