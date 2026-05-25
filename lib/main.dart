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
  bool _isUserVIP = false; // حالة اشتراك المستخدم

  Future<void> _pickVideoFromGallery() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
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
      _buildTemplatesStoreScreen(), // المتجر الرهيب الجديد
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
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: 'متجر VIP'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }

  // 1️⃣ شاشة التحرير والتايم لاين
  Widget _buildEditScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('YMAI EDITOR', style: TextStyle(fontSize: 22, fontWeight: FontWeight.black)),
              ElevatedButton.icon(
                onPressed: () => _openVIPPaywall(context),
                icon: Icon(Icons.workspace_premium, color: _isUserVIP ? Colors.amber : Colors.black, size: 18),
                label: Text(_isUserVIP ? 'عضو VIP نشط' : 'ترقية لـ VIP', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDEFF9A)),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(24)),
            child: !_isVideoInitialized
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickVideoFromGallery,
                          child: Container(
                            width: 120, height: 120,
                            decoration: const BoxDecoration(color: Color(0xFF222222), shape: BoxShape.circle),
                            child: const Icon(Icons.add, size: 45, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('مشروع جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!)),
                      ),
                      IconButton(
                        icon: Icon(_videoController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 50, color: const Color(0xFFDEFF9A)),
                        onPressed: () {
                          setState(() { _videoController!.value.isPlaying ? _videoController?.pause() : _videoController?.play(); });
                        },
                      ),
                    ],
                  ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity, margin: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_isVideoInitialized ? '${_videoController?.value.position.inSeconds} ثانية' : '00:00', style: const TextStyle(color: Color(0xFFDEFF9A))),
                      const Icon(Icons.menu_open, color: Colors.grey),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF222222)),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildToolButton(Icons.content_cut, 'قص وتعديل'),
                      _buildToolButton(Icons.music_note, 'إضافة صوت'),
                      _buildToolButton(Icons.text_fields, 'نص متحرك'),
                      _buildToolButton(Icons.auto_fix_high, 'مؤثرات VIP'),
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

  // 2️⃣ شاشة متجر القوالب الرهيبة والمدفوعة مع نظام الاشتراك
  Widget _buildTemplatesStoreScreen() {
    final List<Map<String, String>> _mockTemplates = [
      {'title': 'تريند تيك توك السينمائي 4K', 'price': '\$4.99 أو اشتراك'},
      {'title': 'انتقالات الغليتش السريعة', 'price': 'حصري للمشتركين'},
      {'title': 'مؤثرات النيون الاحترافية', 'price': '\$2.99 أو اشتراك'},
      {'title': 'مقدمة الألعاب ثلاثية الأبعاد', 'price': 'حصري للمشتركين'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('متجر القوالب الرهيبة 👑', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('قوالب مدفوعة وضمن اشتراك VIP', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              if (!_isUserVIP)
                TextButton(
                  onPressed: () => _openVIPPaywall(context),
                  child: const Text('اشترك الآن', style: TextStyle(color: Color(0xFFDEFF9A), fontWeight: FontWeight.bold)),
                )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
              itemCount: _mockTemplates.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF222222))),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(6)),
                        child: const Text('PREMIUM', style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.play_circle_outline, size: 40, color: Colors.grey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_mockTemplates[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(_mockTemplates[index]['price']!, style: const TextStyle(fontSize: 11, color: Color(0xFFDEFF9A))),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _useTemplate(context, _mockTemplates[index]['title']!),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF222222)),
                          child: const Text('استخدام القالب', style: TextStyle(fontSize: 11)),
                        ),
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

  // 3️⃣ شاشة الحساب والشراء
  Widget _buildProfileScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 45, backgroundColor: const Color(0xFF161616), child: Icon(Icons.person, size: 45, color: _isUserVIP ? Colors.amber : Colors.grey)),
          const SizedBox(height: 16),
          Text(_isUserVIP ? 'عضو YMAI VIP الماسي 👑' : 'مطور تطبيق YMAI', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _openVIPPaywall(context),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDEFF9A)),
            child: Text(_isUserVIP ? 'إدارة اشتراكي الملكي' : 'فتح متجر وقوالب VIP الدائمة', style: const TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label) {
    return Container(
      width: 90, margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 22), const SizedBox(height: 6), Text(label, style: const TextStyle(fontSize: 11))],
      ),
    );
  }

  // شاشة الدفع والاشتراك المحاكية (Paywall)
  void _openVIPPaywall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, size: 60, color: Colors.amber),
            const SizedBox(height: 16),
            const Text('انضم إلى الخزنة الذهبية لـ YMAI VIP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('شحن كافة القوالب المدفوعة، التصدير بدقة 4K، وبدون أي إعلانات', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ListTile(
              tileColor: const Color(0xFF222222),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text('اشتراك شهري ملكي', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Text('\$4.99 / شهر', style: TextStyle(color: Color(0xFFDEFF9A), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() { _isUserVIP = true; });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('مبروك! تم تفعيل اشتراك VIP وفتح جميع القوالب والواجهات بنجاح! 🎉')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDEFF9A)),
                child: const Text('تفعيل الاشتراك الفوري', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _useTemplate(BuildContext context, String templateName) {
    if (!_isUserVIP) {
      _openVIPPaywall(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري معالجة وحقن قالب [$templateName] داخل مشروعك الحالي... 🚀')));
    }
  }
}
