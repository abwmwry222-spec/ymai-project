import 'package:flutter/material.dart';

void main() => runApp(const UltraApp());

class UltraApp extends StatelessWidget {
  const UltraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultra K.Z',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultra K.Z Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stars, color: Colors.amber),
            onPressed: () => _showVIPDialog(context),
          )
        ],
      ),
      body: Stack(
        children: [
          // القسم الخاص بالمتاجر والقوالب
          GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 6, // عدد القوالب
            itemBuilder: (context, index) => Card(
              child: Column(
                children: [
                  const Expanded(child: Icon(Icons.auto_awesome, size: 50, color: Colors.deepPurple)),
                  const Text('قالب جبار #1'),
                  ElevatedButton(
                    onPressed: () => _processPayment(context),
                    child: const Text('شراء'),
                  )
                ],
              ),
            ),
          ),
          
          // العلامة المائية K.Z
          Positioned(
            bottom: 20,
            right: 20,
            child: Opacity(
              opacity: 0.3,
              child: Row(
                children: const [
                  Icon(Icons.verified, size: 16),
                  SizedBox(width: 5),
                  Text('K.Z Developed', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // نظام الدفع للمحفظة
  void _processPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('إتمام الدفع إلى محفظة K.Z', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const ListTile(leading: Icon(Icons.wallet), title: Text('رصيد المحفظة')),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('تأكيد العملية'))
          ],
        ),
      ),
    );
  }

  void _showVIPDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اشتراك VIP'),
        content: const Text('احصل على تصاميم مذهلة وحصرية الآن!'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('اشترك الآن'))],
      ),
    );
  }
}
