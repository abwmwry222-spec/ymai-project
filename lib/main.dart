import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PhotoshopStudio()));

class PhotoshopStudio extends StatefulWidget {
  const PhotoshopStudio({super.key});
  @override
  State<PhotoshopStudio> createState() => _PhotoshopStudioState();
}

class _PhotoshopStudioState extends State<PhotoshopStudio> {
  List<Widget> layers = [];
  double brightness = 1.0; // ميزة حقيقية للتحكم في الإضاءة

  void addTextLayer() {
    setState(() {
      layers.add(
        Positioned(
          top: 150,
          left: 100,
          child: Draggable(
            feedback: const Text("K.Z DESIGN", style: TextStyle(fontSize: 30, color: Colors.blueAccent)),
            child: const Text("K.Z DESIGN", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('K.Z Photoshop Pro'), // اسم علامتك التجارية
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () {}),
        ],
      ),
      body: ColorFiltered(
        colorFilter: ColorFilter.matrix([
          brightness, 0, 0, 0, 0,
          0, brightness, 0, 0, 0,
          0, 0, brightness, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: Stack(
          children: [
            Center(child: Container(color: Colors.grey[900], width: 350, height: 550, child: const Icon(Icons.add_a_photo, size: 50, color: Colors.white24))),
            ...layers,
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.text_fields, color: Colors.white), onPressed: addTextLayer),
            IconButton(icon: const Icon(Icons.wb_sunny, color: Colors.yellow), 
              onPressed: () => setState(() => brightness += 0.1)), // زيادة الإضاءة حقيقية
            IconButton(icon: const Icon(Icons.auto_fix_high, color: Colors.purpleAccent), onPressed: () {}), // فلاتر K.Z
            IconButton(icon: const Icon(Icons.layers, color: Colors.blue), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
