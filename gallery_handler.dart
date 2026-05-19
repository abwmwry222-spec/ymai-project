import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHandler {
  final ImagePicker _picker = ImagePicker();

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.videos.request();
      return status.isGranted;
    }
    return true; 
  }

  Future<File?> pickVideoFromGallery() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 15),
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<File?> exportAndSaveVideo(File sourceVideo, String quality) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String newPath = '${directory.path}/YMAI_CapCut_Export_$timestamp\_$quality.mp4';

      final File savedVideo = await sourceVideo.copy(newPath);
      return savedVideo;
    } catch (e) {
      return null;
    }
  }
}
