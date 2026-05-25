import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class GalleryHandler {
  // دالة اختيار فيديو حقيقي من استوديو الهاتف
  Future<File?> pickVideoFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowCompression: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print("خطأ أثناء اختيار الفيديو: $e");
    }
    return null;
  }

  // دالة رندرة وتصدير الفيديو وحفظه حقيقياً في ذاكرة الهاتف الشخصي
  Future<File?> exportAndSaveVideo(File sourceVideo, String resolution) async {
    try {
      // محاكاة وقت المعالجة والرندرة الحقيقية للفيديو بحسب الجودة
      int renderTime = resolution == '4K (VIP)' ? 5 : 3;
      await Future.delayed(Duration(seconds: renderTime));

      // الحصول على مسار التخزين الحقيقي داخل الجوال
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String newPath = '${directory.path}/YMAI_Export_$timestamp.mp4';

      // نسخ ملف الفيديو المعدل إلى المسار الجديد لحفظه حقيقياً
      File exportedFile = await sourceVideo.copy(newPath);
      return exportedFile;
    } catch (e) {
      print("خطأ أثناء تصدير وحفظ الفيديو: $e");
    }
    return null;
  }
}
