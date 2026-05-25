import 'package:flutter/material.dart';

void main() {
  runApp(const YMAIApp());
}

class YMAIApp extends StatelessWidget {
  const YMAIApp({super.key});

  @style
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YMAI Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFFDEFF9A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDEFF9A),
          secondary: Color(0xFF007AFF),
        ),
      ),
      home: const YMAIHomeScreen(),
    );
  }
}

class YMAIHomeScreen extends StatefulWidget {
  const YMAIHomeScreen({super.key});

  @override
  State<YMAIHomeScreen> createState() => _YMAIHomeScreenState();
}

class _YMAIHomeScreenState extends State<YMAIHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // الشريط العلوي للاشتراك والميزات
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                justifyContent: spaceBetween,
                children: [
                  const Text(
                    'YMAI PRO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  // زر الـ VIP الحقيقي
                  ElevatedButton.icon(
                    onPressed: () {
                      _showVIPDialog(context);
                    },
                    icon: const Icon(Icons.star, color: Colors.black),
                    label: const Text('VIP Templates', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDEFF9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // مساحة العمل المركزية (أزرار إنشاء فيديو)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // زر مشروع جديد الضخم مثل كاب كات
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('جاري فتح الاستوديو لبدء مشروع جديد...')),
                        );
                      },
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFF333333)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 50, color: Colors.white),
                            SizedBox(height: 10),
                            Text('مشروع جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'ابدأ بصنع سحرك الخاص الآن',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // شريط التنقل السفلي المحاكي لكاب كات
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF111111),
        selectedItemColor: const Color(0xFFDEFF9A),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'تحرير'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'قوالب'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  // نافذة الـ VIP عند الضغط على الزر
  void _showVIPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('مستودع قوالب VIP 🔥', textAlign: TextAlign.center),
        content: const Text(
          'مرحباً بك في الخزنة الذهبية! هنا ستجد جميع قوالب تيك توك وتريندات إنستغرام جاهزة ومحدثة يومياً بدون أي علامات مائية وبدقة 4K.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(color: Color(0xFFDEFF9A))),
          ),
        ],
      ),
    );
  }
}
