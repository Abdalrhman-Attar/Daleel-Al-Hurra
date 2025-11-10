import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/locale/locale.dart';
import '../services/remote_config_service.dart';
import '../utils/loggers/custom_logger.dart';

class VersionCheckService {
  static bool _isCheckingVersion = false;
  static bool _dialogShown = false;

  /// Check if app needs to be updated
  static Future<void> checkForUpdate({bool showDialogAlways = false}) async {
    if (_isCheckingVersion || _dialogShown) {
      logger.i('Version check skipped - already checking: $_isCheckingVersion, dialog shown: $_dialogShown');
      return;
    }

    try {
      _isCheckingVersion = true;
      logger.i('🔄 Starting version check...');

      // Add a small delay to ensure UI is ready
      await Future.delayed(const Duration(milliseconds: 500));

      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      logger.i('📱 Current app version: $currentVersion');

      // Get latest version from Remote Config (more reliable than store parsing)
      logger.i('🔍 Getting latest version from Remote Config...');
      final latestVersion = RemoteConfigService.latestAppVersion;
      logger.i('🏪 Latest version from config: $latestVersion');

      // Get remote config values
      final forceUpdateRequired = RemoteConfigService.forceUpdateRequired;
      final updateMessage = RemoteConfigService.updateMessage;

      logger.i('🔧 Remote config - Force update required: $forceUpdateRequired');

      // Compare versions
      final hasNewVersion = _compareVersions(currentVersion, latestVersion) < 0;

      logger.i('📊 Version comparison - Has new version: $hasNewVersion');
      logger.i('📊 Comparison details: $currentVersion vs latest:$latestVersion = ${_compareVersions(currentVersion, latestVersion)}');

      // Show dialog if there's a new version available
      if (hasNewVersion || showDialogAlways) {
        logger.i('🚨 Showing update dialog - Force required: $forceUpdateRequired');
        await _showUpdateDialog(
          isForced: forceUpdateRequired,
          currentVersion: currentVersion,
          latestVersion: latestVersion,
          message: updateMessage,
        );
      } else {
        logger.i('✅ No update needed - Current version is up to date');
      }
    } catch (e, stackTrace) {
      logger.e('❌ Error checking app version', error: e, stackTrace: stackTrace);
    } finally {
      _isCheckingVersion = false;
    }
  }

  /// Compare two version strings
  /// Returns: -1 if v1 < v2, 0 if equal, 1 if v1 > v2
  static int _compareVersions(String v1, String v2) {
    try {
      final v1Parts = v1.split('.').map((e) => int.parse(e)).toList();
      final v2Parts = v2.split('.').map((e) => int.parse(e)).toList();

      // Ensure both lists have the same length
      while (v1Parts.length < v2Parts.length) {
        v1Parts.add(0);
      }
      while (v2Parts.length < v1Parts.length) {
        v2Parts.add(0);
      }

      for (var i = 0; i < v1Parts.length; i++) {
        if (v1Parts[i] < v2Parts[i]) return -1;
        if (v1Parts[i] > v2Parts[i]) return 1;
      }
      return 0;
    } catch (e) {
      logger.e('Error comparing versions: $v1 vs $v2', error: e);
      return 0;
    }
  }

  /// Show update dialog
  static Future<void> _showUpdateDialog({
    required bool isForced,
    required String currentVersion,
    required String latestVersion,
    required String message,
  }) async {
    if (_dialogShown) return;

    final context = Get.context;
    if (context == null) {
      logger.w('Context is null, cannot show update dialog');
      return;
    }

    _dialogShown = true;
    logger.i('Showing update dialog - Forced: $isForced');

    // Get localized text
    final localeController = Get.find<LocaleController>();
    final isArabic = localeController.getLanguageCode() == 'ar';

    final title = isArabic ? 'تحديث مطلوب' : 'Update Required';
    final updateButtonText = isArabic ? 'تحديث الآن' : 'Update Now';
    final laterButtonText = isArabic ? 'لاحقاً' : 'Later';

    await showDialog(
      context: context,
      barrierDismissible: !isForced,
      builder: (BuildContext context) {
        return PopScope(
          canPop: !isForced,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(title)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                const SizedBox(height: 16),
                Text(
                  isArabic ? 'الإصدار الحالي: $currentVersion\nأحدث إصدار: $latestVersion' : 'Current Version: $currentVersion\nLatest Version: $latestVersion',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              if (!isForced)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _dialogShown = false;
                  },
                  child: Text(laterButtonText),
                ),
              ElevatedButton(
                onPressed: () => _openStore(),
                child: Text(updateButtonText),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Open app store for update
  static Future<void> _openStore() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      Uri storeUri;
      if (Platform.isAndroid) {
        storeUri = Uri.parse('https://play.google.com/store/apps/details?id=$packageName');
      } else if (Platform.isIOS) {
        // You'll need to replace this with your actual App Store ID
        storeUri = Uri.parse('https://apps.apple.com/jo/app/دليل-الحرة/id6670617809');
      } else {
        logger.w('Unsupported platform for store redirect');
        return;
      }

      logger.i('Opening store URL: $storeUri');

      if (await canLaunchUrl(storeUri)) {
        await launchUrl(storeUri, mode: LaunchMode.externalApplication);
      } else {
        logger.e('Could not launch store URL: $storeUri');
      }
    } catch (e, stackTrace) {
      logger.e('Error opening store', error: e, stackTrace: stackTrace);
    }
  }

  /// Reset dialog state (useful for testing)
  static void resetDialogState() {
    _dialogShown = false;
    _isCheckingVersion = false;
    logger.d('Version check dialog state reset');
  }
}
