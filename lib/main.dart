import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PhotoshopStudio()));

class PhotoshopStudio extends StatefulWidget {
  const PhotoshopStudio({super.key});
  @override
  State<PhotoshopStudio> createState() => _PhotoshopStudioState();
}

class _PhotoshopStudioState extends State<PhotoshopStudio> {
  // قائمة الطبقات الحقيقية (نصوص، صور، فلاتر)
  List<Widget> layers = [];

  void addTextLayer() {
    setState(() {
      layers.add(
        Positioned(
          top: 100,
          left: 100,
          child: Draggable(
            feedback: const Text("نص جديد", style: TextStyle(fontSize: 24, color: Colors.blue)),
            childWhenDragging: Container(),
            child: const Text("نص جديد", style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // لون خلفية احترافي
      appBar: AppBar(
        title: const Text('استوديو YMAI الاحترافي'),
        backgroundColor: Colors.black,
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: () {})],
      ),
      body: Stack(
        children: [
          // مساحة العمل (الطبقات تظهر هنا فوق بعضها)
          Center(child: Container(color: Colors.grey[900], width: 300, height: 500)),
          ...layers, 
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.text_fields, color: Colors.white), onPressed: addTextLayer),
            IconButton(icon: const Icon(Icons.image, color: Colors.white), onPressed: () {}), // إضافة صورة
            IconButton(icon: const Icon(Icons.layers, color: Colors.white), onPressed: () {}), // إدارة الطبقات
            IconButton(icon: const Icon(Icons.auto_fix_high, color: Colors.white), onPressed: () {}), // الفلاتر
          ],
        ),
      ),
    );
  }
}
