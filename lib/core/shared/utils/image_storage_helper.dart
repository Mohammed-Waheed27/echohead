import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Copies an image to the app's persistent storage and returns the new path.
/// Use this to ensure images persist across app restarts.
class ImageStorageHelper {
  static Future<String?> copyToAppStorage(String sourcePath) async {
    try {
      final file = File(sourcePath);
      if (!await file.exists()) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final reportsDir = Directory('${appDir.path}/report_images');
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = sourcePath.split('.').last;
      final newPath = '${reportsDir.path}/report_$timestamp.$extension';

      await file.copy(newPath);
      return newPath;
    } catch (_) {
      return null;
    }
  }
}
