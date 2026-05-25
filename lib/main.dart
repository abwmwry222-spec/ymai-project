import 'package:flutter/material.dart';
import 'gallery_handler.dart';
import 'vip_store_handler.dart';

void main() {
  runApp(const YmaiCapCutApp());
}

class YmaiCapCutApp extends StatelessWidget {
  const YmaiCapCutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMAI CapCut Pro',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      debugShowCheckedModeBanner: false,
      home: const EditorHomeScreen(),
    );
  }
}

class EditorHomeScreen extends StatefulWidget {
  const EditorHomeScreen({super.key});

  @override
  State<EditorHomeScreen> createState() => _EditorHomeScreenState();
}

class _EditorHomeScreenState extends State<EditorHomeScreen> {
  final GalleryHandler _galleryHandler = GalleryHandler();
  final VipStoreHandler _vipHandler = VipStoreHandler();
  
  String _currentResolution = '1080p';
  bool _isProcessing = false;
  String _statusMessage = 'جاهز لبدء المونتاج';

  void _selectVideo() async {
    setState(() {
      _statusMessage = 'جاري فتح استوديو الجوال...';
    });
    final video = await _galleryHandler.pickVideoFromGallery();
    if (video != null) {
      setState(() {
        _statusMessage = 'تم اختيار الفيديو بنجاح!';
      });
    } else {
      setState(() {
        _statusMessage = 'لم يتم اختيار أي فيديو.';
      });
    }
  }

  void _exportVideo() {
    if (!_vipHandler.hasAccessToFeature('export_4k') && _currentResolution == '4K (VIP)') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ميزة الـ 4K مخصصة لأعضاء VIP فقط!')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'جاري رندرة وتصدير الفيديو بدقة $_currentResolution...';
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'تم حفظ الفيديو بنجاح في معرض الهاتف! ✨';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YMAI Video Editor'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.star,
              color: _vipHandler.isVip ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _vipHandler.toggleVipStatus();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_vipHandler.isVip 
                      ? 'تم تفعيل اشتراك VIP بنجاح! 👑' 
                      : 'تم العودة للحساب المجاني.'),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: Center(
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : Text(_statusMessage, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.video_library),
              label: const Text('اضغط هنا لاختيار فيديو من الاستوديو'),
              onPressed: _selectVideo,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _currentResolution,
              decoration: const InputDecoration(labelText: 'جودة التصدير'),
              items: const [
                DropdownMenuItem(value: '720p', child: Text('720p (عادي)')),
                DropdownMenuItem(value: '1080p', child: Text('1080p (عالي)')),
                DropdownMenuItem(value: '4K (VIP)', child: Text('4K (ميزات VIP 👑)')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentResolution = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportVideo,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('تصدير وحفظ الفيديو الحقيقي'),
            ),
          ],
        ),
      ),
    );
  }
}
