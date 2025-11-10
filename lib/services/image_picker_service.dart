import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick a single image from camera or gallery
  static Future<File?> pickImage({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: ${e.toString()}');
      return null;
    }
  }

  /// Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages({
    required BuildContext context,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 80,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick images: ${e.toString()}');
      return [];
    }
  }

  /// Pick a video from camera or gallery
  static Future<File?> pickVideo({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
    Duration? maxDuration,
  }) async {
    try {
      final video = await _picker.pickVideo(
        source: source,
        maxDuration: maxDuration ?? const Duration(minutes: 10),
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick video: ${e.toString()}');
      return null;
    }
  }

  /// Show image source selection dialog
  static Future<ImageSource?> showImageSourceDialog({
    required BuildContext context,
    String title = 'Select Image Source',
    bool includeCamera = true,
    bool includeGallery = true,
  }) async {
    if (!includeCamera && !includeGallery) {
      return null;
    }

    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (includeCamera)
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(tr('camera')),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
              if (includeGallery)
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(tr('gallery')),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Show video source selection dialog
  static Future<ImageSource?> showVideoSourceDialog({
    required BuildContext context,
    String title = 'Select Video Source',
    bool includeCamera = true,
    bool includeGallery = true,
  }) async {
    if (!includeCamera && !includeGallery) {
      return null;
    }

    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (includeCamera)
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: Text(tr('camera')),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
              if (includeGallery)
                ListTile(
                  leading: const Icon(Icons.video_library),
                  title: Text(tr('gallery')),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Show multiple image selection dialog
  static Future<List<File>> showMultipleImageSelectionDialog({
    required BuildContext context,
    String title = 'Select Images',
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    // First close the dialog
    Navigator.of(context).pop();

    // Then pick multiple images directly
    return await pickMultipleImages(
      context: context,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
