import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../utils/helpers/helper_functions.dart';

class DownloadService {
  static final Dio _dio = Dio();

  /// Downloads an image from URL and returns a File
  static Future<File?> downloadImageFromUrl(String imageUrl) async {
    try {
      // Validate URL
      if (!isValidUrl(imageUrl)) {
        debugPrint('Invalid URL: $imageUrl');
        return null;
      }

      // Check if the URL is a video file
      if (!HelperFunctions().isValidImageUrl(imageUrl)) {
        debugPrint('Attempting to download video file as image: $imageUrl');
        return null;
      }

      // Create a temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageUrl)}';
      final filePath = path.join(tempDir.path, fileName);

      // Download the image with timeout
      final response = await _dio.get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Write the bytes to a file
        final file = File(filePath);
        await file.writeAsBytes(response.data as Uint8List);

        // Verify the file was created and has content
        if (await file.exists() && await file.length() > 0) {
          return file;
        } else {
          debugPrint('Downloaded file is empty or invalid: $filePath');
          return null;
        }
      } else {
        debugPrint('Failed to download image from $imageUrl: Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading image from $imageUrl: $e');
    }
    return null;
  }

  /// Downloads multiple images from URLs and returns a list of Files
  static Future<List<File>> downloadImagesFromUrls(List<String> imageUrls) async {
    final downloadedFiles = <File>[];

    for (final url in imageUrls) {
      final file = await downloadImageFromUrl(url);
      if (file != null) {
        downloadedFiles.add(file);
      }
    }

    return downloadedFiles;
  }

  /// Downloads a video from URL and returns a File
  static Future<File?> downloadVideoFromUrl(String videoUrl) async {
    try {
      // Validate URL
      if (!isValidUrl(videoUrl)) {
        debugPrint('Invalid URL: $videoUrl');
        return null;
      }

      // Create a temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(videoUrl)}';
      final filePath = path.join(tempDir.path, fileName);

      // Download the video with timeout
      final response = await _dio.get(
        videoUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60), // Longer timeout for videos
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Write the bytes to a file
        final file = File(filePath);
        await file.writeAsBytes(response.data as Uint8List);

        // Verify the file was created and has content
        if (await file.exists() && await file.length() > 0) {
          return file;
        } else {
          debugPrint('Downloaded video file is empty or invalid: $filePath');
          return null;
        }
      } else {
        debugPrint('Failed to download video from $videoUrl: Status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading video from $videoUrl: $e');
    }
    return null;
  }

  /// Checks if a string is a valid URL
  static bool isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Converts a list of mixed URLs and Files to a list of Files
  static Future<List<File>> convertMixedToFiles(List<dynamic> mixedItems) async {
    final files = <File>[];

    for (final item in mixedItems) {
      if (item is File) {
        // Verify the file exists and is valid
        if (await item.exists() && await item.length() > 0) {
          files.add(item);
        } else {
          debugPrint('Skipping invalid file: ${item.path}');
        }
      } else if (item is String && isValidUrl(item)) {
        final downloadedFile = await downloadImageFromUrl(item);
        if (downloadedFile != null) {
          files.add(downloadedFile);
        } else {
          debugPrint('Failed to download image from URL: $item');
        }
      } else {
        debugPrint('Skipping invalid item: $item');
      }
    }

    return files;
  }
}
