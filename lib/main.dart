import 'dart:io';
import 'package:flutter/material.dart';
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
      title: 'YMAI Pro Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0密121212),
      ),
      home: const EditorDashboard(),
    );
  }
}

class EditorDashboard extends StatefulWidget {
  const EditorDashboard({super.key});

  @override
  State<EditorDashboard> createState() => _EditorDashboardState();
}

class _EditorDashboardState extends State<EditorDashboard> {
  final GalleryHandler _gallery = GalleryHandler();
  final VipStoreHandler _vipStore = VipStoreHandler();

  File? _selectedVideo;
  String _currentFilter = "بدون فلتر";
  String _selectedResolution = "1080p"; // الدقة الافتراضية المجانية
  bool _removeWatermark = false;
  bool _isExporting = false;
  String? _exportedPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YMAI Video Editor Pro'),
        backgroundColor: Colors.black,
        actions: [
          // زر تفعيل اشتراك VIP للتجربة واختبار القيود
          TextButton.icon(
            icon: Icon(Icons.star, color: _vipStore.isVip ? Colors.amber : Colors.grey),
            label: Text(_vipStore.isVip ? "حساب VIP" : "ترقية للـ VIP", 
              style: TextStyle(color: _vipStore.isVip ? Colors.amber : Colors.white)),
            onPressed: () {
              setState(() {
                _vipStore.toggleVipStatus();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_vipStore.isVip ? "تم تفعيل ميزات الـ VIP بنجاح!" : "تم العودة للحساب المجاني.")),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 1. منطقة عرض الفيديو أو شاشة البدء
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.black26,
              child: _selectedVideo == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.video_library, size: 80, color: Colors.grey),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                          onPressed: () async {
                            final video = await _gallery.pickVideoFromGallery();
                            if (video != null) {
                              setState(() {
                                _selectedVideo = video;
                                _exportedPath = null;
                              });
                            }
                          },
                          child: const Text("إدراج فيديو للبدء في المونتاج"),
                        ),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.all(20),
                      alignment: Center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie, size: 60, color: Colors.amber),
                          const SizedBox(height: 10),
                          Text("الفيديو النشط: ${_selectedVideo!.path.split('/').last}", 
                              textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text("تأثير الفلتر الحالي: $_currentFilter", style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
            ),
          ),

          // 2. شريط أدوات المونتاج (يفتح فقط إذا تم اختيار فيديو)
          if (_selectedVideo != null) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.black87,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolButton(Icons.content_cut, "قص الفيديو", () {
                    _showActionFeedback("تم تحديد نقطة البداية والنهاية للقص بنجاح.");
                  }),
                  _buildToolButton(Icons.filter_banyuv, "الفلاتر", _openFilterDialog),
                  _buildToolButton(_removeWatermark ? Icons.check_box : Icons.check_box_outline_blank, "إزالة الشعار", _toggleWatermarkFeature),
                ],
              ),
            ),
            
            // 3. خيارات تصدير وجودة الفيديو الحقيقية
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("دقة التصدير:", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedResolution,
                    items: <String>['720p', '1080p', '4K (VIP)'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue == '4K (VIP)' && !_vipStore.hasAccessToFeature('export_4k')) {
                        _showVipWarning("دقة 4K حصرية للمشتركين في باقة VIP!");
                      } else {
                        setState(() => _selectedResolution = newValue!);
                      }
                    },
                  ),
                ],
              ),
            ),

            // 4. زر التصدير والتحميل النهائي بالجهاز
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isExporting ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save_alt),
                  label: Text(_isExporting ? "جاري معالجة وتصدير الفيديو..." : "حفظ وتحميل الفيديو النهائي"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _isExporting ? null : _exportVideoWorkflow,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent, size: 28),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("اختر الفلتر الاحترافي"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['سينمائي', 'خريف عتيق', 'أبيض وأسود', 'دراما'].map((filter) {
            return ListTile(
              title: Text(filter),
              onTap: () {
                setState(() => _currentFilter = filter);
                Navigator.pop(context);
                _showActionFeedback("تم تطبيق فلتر $filter بنجاح.");
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _toggleWatermarkFeature() {
    if (!_vipStore.hasAccessToFeature('remove_watermark')) {
      _showVipWarning("ميزة إزالة العلامة المائية متاحة فقط لأعضاء VIP!");
    } else {
      setState(() => _removeWatermark = !_removeWatermark);
      _showActionFeedback(_removeWatermark ? "سيتم حفظ الفيديو بدون علامة مائية." : "ستظهر علامة التطبيق المائية.");
    }
  }

  Future<void> _exportVideoWorkflow() async {
    setState(() => _isExporting = true);
    
    // محاكاة زمن الرندرة والمعالجة للمونتاج
    await Future.delayed(const Duration(seconds: 3));

    final result = await _gallery.exportAndSaveVideo(_selectedVideo!, _selectedResolution);

    setState(() {
      _isExporting = false;
      if (result != null) {
        _exportedPath = result.path;
      }
    });

    if (_exportedPath != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
          title: const Text("تم التصدير بنجاح!"),
          content: Text("تم حفظ الفيديو النهائي في جهازك بمسار:\n\n$_exportedPath"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("حسناً"))
          ],
        ),
      );
    }
  }

  void _showActionFeedback(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  void _showVipWarning(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [Icon(Icons.lock, color: Colors.amber), SizedBox(width: 10), Text("ميزة VIP مقفلة")],
        ),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إغلاق")),
        ],
      ),
    );
  }
}
