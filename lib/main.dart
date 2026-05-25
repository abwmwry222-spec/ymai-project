import 'package:flutter/material.dart';

void main() {
  runApp(const YMAIApp());
}

class YMAIApp extends StatelessWidget {
  const YMAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMAI Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFDEFF9A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDEFF9A),
          secondary: Color(0xFF007AFF),
          surface: Color(0xFF161616),
        ),
      ),
      home: const YMAIMainLayout(),
    );
  }
}

class YMAIMainLayout extends StatefulWidget {
  const YMAIMainLayout({super.key});

  @override
  State<YMAIMainLayout> createState() => _YMAIMainLayoutState();
}

class _YMAIMainLayoutState extends State<YMAIMainLayout> {
  int _currentTab = 0;
  bool _hasSelectedVideo = false;
  String _videoName = "";

  // دالة تفاعلية لمحاكاة فتح معرض الهاتف واختيار فيديو للمونتاج
  void _simulateVideoSelection() {
    setState(() {
      _hasSelectedVideo = true;
      _videoName = "YMAI_PRO_VIDEO_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.mp4";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم استيراد مقطع الفيديو بنجاح: $_videoName'),
        backgroundColor: const Color(0xFF007AFF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildEditScreen(),
      _buildTemplatesScreen(),
      _buildProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: _screens[_currentTab]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: const Color(0xFFDEFF9A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'تحرير'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'قوالب VIP'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }

  // 1️⃣ شاشة التحرير والتايم لاين الأساسية (كاب كات)
  Widget _buildEditScreen() {
    return Column(
      children: [
        // الشريط العلوي للبريميوم والأزرار
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'YMAI EDITOR',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.black, letterSpacing: 1.0),
              ),
              ElevatedButton.icon(
                onPressed: () => _openVIPModal(context),
                icon: const Icon(Icons.workspace_premium, color: Colors.black, size: 18),
                label: const Text('ميزات VIP', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDEFF9A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),

        // منطقة عرض شاشة الفيديو المركزية أو زر الإضافة
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: !_hasSelectedVideo
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _simulateVideoSelection,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xFF222222),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF333333)),
                            ),
                            child: const Icon(Icons.add, size: 45, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('مشروع جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('اضغط هنا لمحاكاة فتح استوديو الصور واختيار فيديو', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.video_camera_back, size: 70, color: Color(0xFFDEFF9A)),
                      const SizedBox(height: 16),
                      Text(_videoName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('الملف نشط وجاهز الآن داخل التايم لاين للقص والمعالجة', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _hasSelectedVideo = false),
                        icon: const Icon(Icons.delete_sweep),
                        label: const Text('حذف وإعادة اختيار مقطع آخر'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.8)),
                      )
                    ],
                  ),
          ),
        ),

        // منطقة التايم لاين والتحرير (شريط أدوات المونتاج كاملاً)
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // أرقام العداد وتوقيت التقطيع
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_hasSelectedVideo ? '00:04.2' : '00:00', style: const TextStyle(color: Color(0xFFDEFF9A), fontSize: 12, fontWeight: FontWeight.bold)),
                      const Icon(Icons.menu_open, color: Colors.grey, size: 18),
                      Text(_hasSelectedVideo ? '00:15.0 / 00:32.4' : '00:00 / 00:00', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF222222)),
                
                // شريط الأدوات القابل للسحب الجانبي (كافة ميزات كاب كات)
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _buildToolButton(Icons.content_cut, 'قص وتعديل'),
                      _buildToolButton(Icons.music_note, 'إضافة صوت'),
                      _buildToolButton(Icons.text_fields, 'نص متحرك'),
                      _buildToolButton(Icons.auto_fix_high, 'مؤثرات VIP'),
                      _buildToolButton(Icons.filter_b_and_w, 'فلاتر سينمائية'),
                      _buildToolButton(Icons.speed, 'السرعة / بطيء'),
                      _buildToolButton(Icons.layers, 'تراكب فيديو'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2️⃣ شاشة مستودع القوالب والتريندات VIP
  Widget _buildTemplatesScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('قوالب تريندات VIP 🔥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('قوالب تيك توك وإنستغرام جاهزة ومحدثة تلقائياً بالذكاء الاصطناعي', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF222222)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFDEFF9A), borderRadius: BorderRadius.circular(6)),
                            child: const Text('PRO VIP', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                          const Icon(Icons.bolt, color: Colors.amber, size: 18),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تريند كاب كات جاهز #$index', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          const Text('استيراد صور تلقائي بدقة 4K', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 3️⃣ شاشة الحساب الشخصي
  Widget _buildProfileScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 45, backgroundColor: Color(0xFF161616), child: Icon(Icons.person, size: 45, color: Colors.grey)),
          const SizedBox(height: 16),
          const Text('مطور تطبيق YMAI المحترف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('نوع الحساب: نسخة المطور الحرة', style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _openVIPModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDEFF9A), 
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('فتح ميزات الـ VIP الدائمة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  // ودجت بناء أزرار أدوات التايم لاين السفلي
  Widget _buildToolButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('أداة [$label] نشطة الآن وجاهزة للاستخدام داخل هذا المقطع'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: Colors.white),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // نافذة الـ VIP المنبثقة
  void _openVIPModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('مستودع تريندات وقوالب VIP 🔥', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'مرحباً بك في النسخة الذهبية! هنا ستجد جميع قوالب تيك توك ومؤثرات الذكاء الاصطناعي الحصرية بدون علامات مائية وبدقة فورية تصل إلى 4K.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('تفعيل السحر والبدء', style: TextStyle(color: Color(0xFFDEFF9A), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
