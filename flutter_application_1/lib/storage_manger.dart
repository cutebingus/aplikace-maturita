 import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> moveToCachePath(String path) async {
  if (path.isEmpty) {
    throw ArgumentError('Path cannot be empty');
  }

// Get the application's cache directory
  Directory cacheDir = await getApplicationCacheDirectory();
  String fileName = path
      .split('/')
      .last;

// Create the destination path
  String destinationPath = '${cacheDir.path}/$fileName';

// Copy the file
  try {
    File sourceFile = File(path);
    await sourceFile.copy(destinationPath);
    return destinationPath;
  } catch (e) {
    throw Exception('Failed to move file to cache: $e');
  }
}