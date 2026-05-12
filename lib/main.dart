import 'package:flutter/material.dart';
import 'ymai.dart'; // ربط الملف الثاني

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YMAI App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const YmaiPage(), 
    );
  }
}
