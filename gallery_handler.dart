import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GalleryHandler {
  // إنشاء نسخة من ImagePicker للتعامل مع المعرض
  final ImagePicker _picker = ImagePicker();

  /// دالة لاختيار فيديو واحد من المعرض لبدء المونتاج
  Future<File?> pickVideoFromGallery() async {
    try {
      // طلب اختيار فيديو بجودة عالية
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10), // تحديد حد أقصى اختياري لطول الفيديو
      );

      if (pickedFile != null) {
        // تحويل الملف المسترجع إلى ملف كائن (File) يمكن للتطبيق معالجته
        return File(pickedFile.path);
      }
      return null; // في حال ألغى المستخدم الاختيار
    } catch (e) {
      print("خطأ أثناء اختيار الفيديو: $e");
      return null;
    }
  }

  /// دالة لاختيار صورة واحدة (مثلاً لتصميم غلاف أو دمجها في الفيديو)
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print("خطأ أثناء اختيار الصورة: $e");
      return null;
    }
  }

  /// دالة لاختيار عدة صور أو فيديوهات معاً (مفيدة لدمج مقاطع متعددة)
  Future<List<File>> pickMultipleMedia() async {
    List<File> mediaFiles = [];
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      for (var file in pickedFiles) {
        mediaFiles.add(File(file.path));
      }
      return mediaFiles;
    } catch (e) {
      print("خطأ أثناء اختيار ملفات متعددة: $e");
      return mediaFiles;
    }
  }
}
