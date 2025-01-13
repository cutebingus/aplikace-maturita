 import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> moveToCachePath(String path) async {
  if (path.isEmpty) {
    throw ArgumentError('Path cannot be empty');
  }

// Ziskani cache directory aplikace
  Directory cacheDir = await getApplicationCacheDirectory();
  String fileName = path
      .split('/')
      .last;

  String destinationPath = '${cacheDir.path}/$fileName';

// kopie souboru

  try {
    File sourceFile = File(path);
    await sourceFile.copy(destinationPath);
    return destinationPath;
  } catch (e) {
    throw Exception('Failed to move file to cache: $e');
  }
}