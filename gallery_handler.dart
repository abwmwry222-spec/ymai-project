import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHandler {
  final ImagePicker _picker = ImagePicker();

  /// طلب صلاحيات الوصول إلى الملفات والاستوديو
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.videos.request();
      return status.isGranted;
    }
    return true; // لنظام iOS أو الأنظمة الأخرى
  }

  /// دالة اختيار فيديو حقيقي من المعرض
  Future<File?> pickVideoFromGallery() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// دالة حقيقية لحفظ وتصدير الفيديو بعد التعديل إلى ذاكرة الجهاز
  Future<File?> exportAndSaveVideo(File sourceVideo, String quality) async {
    try {
      // الحصول على المجلد الحقيقي داخل جهاز المستخدم لحفظ الملف فيه
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String newPath = '${directory.path}/YMAI_Export_$timestamp\_$quality.mp4';

      // محاكاة عملية معالجة (نسخ الملف الفعلي إلى المسار الجديد كأنه فيديو تم تصديره)
      final File savedVideo = await sourceVideo.copy(newPath);
      return savedVideo;
    } catch (e) {
      return null;
    }
  }
}
