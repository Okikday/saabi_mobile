import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:saabi_mobile/core/utils/misc/result.dart';
import 'package:saabi_mobile/core/utils/storage/file_utils.dart';

class CleanUpUtils {
  Future<void> clearCacheData() async {
    final result = await Result.tryRunAsync(() async {
      await clearCacheOrTemp();
    });

    if (result.isError) {
      log('Error clearing cache data: ${result.message}');
    }
  }

  /// Clears the cache and temporary directories.
  Future<void> clearCacheOrTemp() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        // Delete contents, not the directory itself
        tempDir.listSync().forEach((file) {
          file.deleteSync(recursive: true);
        });
      }

      final cacheDir = await getApplicationCacheDirectory();
      if (cacheDir.existsSync()) {
        // Delete contents, not the directory itself
        cacheDir.listSync().forEach((file) {
          file.deleteSync(recursive: true);
        });
      }

      log('Cache and temporary directories cleared.');
    } catch (e) {
      log('Error clearing cache/temp: $e');
    }
  }

  /// Recursively collects all empty directories under [rootDirPath].
  static Future<List<Directory>> findEmptyDirectories(String rootDirPath) async {
    final root = Directory(rootDirPath);
    if (!await root.exists()) return [];

    List<Directory> emptyDirs = [];

    Future<void> scan(Directory dir) async {
      final entries = dir.listSync();
      for (var entity in entries) {
        if (entity is Directory) {
          await scan(entity);
        }
      }
      // Recheck after scanning children — some subdirs might have been empty
      if (dir.listSync().isEmpty) {
        emptyDirs.add(dir);
      }
    }

    await scan(root);
    return emptyDirs;
  }
}
