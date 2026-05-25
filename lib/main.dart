import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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
  File? _selectedVideoFile;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  final ImagePicker _picker = ImagePicker();

  // ميزة فتح معرض الهاتف الحقيقي واختيار فيديو وحقنه داخل محرك التشغيل
  Future<void> _pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      // تنظيف المحرك القديم لو كان موجوداً
      if (_videoController != null) {
        await _videoController!.dispose();
      }

      _selectedVideoFile = File(video.path);
      _videoController = VideoPlayerController.file(_selectedVideoFile!)
        ..initialize().then((_) {
          setState(() {
            _isVideoInitialized = true;
            _videoController!.play();
            _videoController!.setLooping(true);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم استيراد وتنشيط الفيديو بنجاح: ${video.name}')),
          );
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
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

  // 1️⃣ شاشة التحرير والتايم لاين الكاملة (كاب كات)
  Widget _buildEditScreen() {
    return Column(
      children: [
        // الشريط العلوي للاشتراكات والـ VIP
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

        // شاشة عرض الفيديو الحية المركزية
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: !_isVideoInitialized
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickVideoFromGallery,
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
                        const Text('اضغط لفتح استوديو الهاتف واختيار فيديو حقيقي', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                      ),
                      // أزرار التحكم بالتشغيل فوق الفيديو
                      Positioned(
                        bottom: 20,
                        child: IconButton(
                          icon: Icon(
                            _videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            size: 50,
                            color: const Color(0xFFDEFF9A),
                          ),
                          onPressed: () {
                            setState(() {
                              _videoController!.value.isPlaying ? _videoController?.pause() : _videoController?.play();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        // التايم لاين السفلي مع شريط الأدوات الكامل للمونتاج
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
                // عداد الوقت التفاعلي للمقطع
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isVideoInitialized ? '${_videoController?.value.position.inSeconds} ثانية' : '00:00',
                        style: const TextStyle(color: Color(0xFFDEFF9A), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.menu_open, color: Colors.grey, size: 18),
                      Text(
                        _isVideoInitialized ? 'إجمالي المقطع: ${_videoController?.value.duration.inSeconds} ثانية' : '00:00 / 00:00',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF222222)),
                
                // شريط ميزات وأدوات المونتاج (تحرير، صوت، نص، فلاتر)
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

  // 2️⃣ شاشة القوالب والتريندات VIP
  Widget _buildTemplatesScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('قوالب تريندات VIP 🔥', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDEFF9A), borderRadius: BorderRadius.circular(6)),
                        child: const Text('PRO VIP', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      Text('تريند كاب كات جاهز #$index', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _openVIPModal(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDEFF9A)),
            child: const Text('فتح ميزات الـ VIP الدائمة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label) {
    return Container(
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
    );
  }

  void _openVIPModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        title: const Text('مستودع تريندات وقوالب VIP 🔥', textAlign: TextAlign.center),
        content: const Text('مرحباً بك في النسخة الذهبية! هنا ستجد جميع قوالب تيك توك ومؤثرات الذكاء الاصطناعي الحصرية.', textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق', style: TextStyle(color: Color(0xFFDEFF9A)))),
        ],
      ),
    );
  }
}
