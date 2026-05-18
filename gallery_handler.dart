import 'package:flutter/material.dart';
// استدعاء الملفات التي أنشأتها لربطها بالواجهة
import 'gallery_handler.dart';
import 'vip_store_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMAI Video Editor',
      theme: ThemeData.dark(), // ثيم داكن يناسب تطبيقات المونتاج الاحترافية
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // إنهاء كائنات المعالج للاستخدام في الواجهة
  final GalleryHandler _galleryHandler = GalleryHandler();
  final VipStoreHandler _vipStoreHandler = VipStoreHandler();

  String _statusMessage = "مرحباً بك في تطبيق المونتاج! اختر فيديو للبدء.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YMAI Pro Editor'),
        actions: [
          // أيقونة مميزة تدل على حالة الـ VIP
          IconButton(
            icon: Icon(
              Icons.star,
              color: _vipStoreHandler.isVip ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _vipStoreHandler.activateVipStatus();
                _statusMessage = "تم تفعيل الـ VIP! تم فتح جميع ميزات التصدير بدقة 4K.";
              });
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              
              // زر اختيار الفيديو من الاستوديو
              ElevatedButton.icon(
                icon: const Icon(Icons.video_library),
                label: const Text('اختيار فيديو للمونتاج'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                onPressed: () async {
                  final videoFile = await _galleryHandler.pickVideoFromGallery();
                  setState(() {
                    if (videoFile != null) {
                      _statusMessage = "تم تحميل الفيديو بنجاح:\n${videoFile.path.split('/').last}";
                    } else {
                      _statusMessage = "لم يتم اختيار أي فيديو.";
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
