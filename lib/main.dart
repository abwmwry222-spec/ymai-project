import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(home: PhotoshopStudio()));

class PhotoshopStudio extends StatefulWidget {
  const PhotoshopStudio({super.key});
  @override
  State<PhotoshopStudio> createState() => _PhotoshopStudioState();
}

class _PhotoshopStudioState extends State<PhotoshopStudio> {
  List<Widget> layers = [];
  String myWallet = "TBuP2Lc7aq9kZFxNtpdUzA3AP3poyYEGBJ"; // محفظتك المشفرة

  // دالة الشراء والاشتراك
  void showVipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("عضوية VIP الجبارة", style: TextStyle(color: Colors.amber)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("استمتع بـ 3 أيام تجريبية، ثم اشتراك شهري بسيط لفتح كافة الميزات.", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            SelectableText("عنوان الدفع (USDT):\n$myWallet", style: const TextStyle(color: Colors.cyan, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            Clipboard.setData(ClipboardData(text: myWallet));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم نسخ عنوان المحفظة")));
          }, child: const Text("نسخ العنوان وبدء الاشتراك")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('K.Z Photoshop Pro'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.amber), onPressed: showVipDialog), // أيقونة المتجر
          IconButton(icon: const Icon(Icons.star, color: Colors.amber), onPressed: showVipDialog), // زر VIP
        ],
      ),
      body: Stack(
        children: [
          Center(child: Container(color: Colors.grey[800], width: 350, height: 550, child: const Icon(Icons.add_a_photo, size: 50, color: Colors.white10))),
          ...layers,
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.text_fields, color: Colors.white), onPressed: () {
               setState(() => layers.add(const Positioned(top: 200, left: 100, child: Text("K.Z DESIGN", style: TextStyle(color: Colors.white, fontSize: 24)))));
            }),
            IconButton(icon: const Icon(Icons.auto_fix_high, color: Colors.purpleAccent), onPressed: showVipDialog), // ميزة VIP
            IconButton(icon: const Icon(Icons.layers, color: Colors.blue), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
