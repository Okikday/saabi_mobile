import 'package:path/path.dart' as p;

class AppPaths {
  // static const _appDirName = "scholar_ark";

  /// Temporary directory name
  static const tempDirName = "temp";

  /// Where all downloaded files are stored
  static const _downloadsDir = "downloads";
  //.... Map based on structure needed later

  /// Where all uploaded files are stored
  static const _uploadsDir = "uploads";

  static String get uploadsDir => _uploadsDir;
  static String get downloadsDir => _downloadsDir;

  /// Course video uploads directory => Only use with tailored functions
  static String courseVideoUploadsDir(String courseId) => p.join(_uploadsDir, courseId, "videos");

  /// Course reading uploads directory => Only use with tailored functions
  static String courseReadingUploadsDir(String courseId) => p.join(_uploadsDir, courseId, "reading");
}
