import 'dart:io';
import 'package:dio/dio.dart';
import '../services/remote_config_service.dart';
import '../utils/loggers/custom_logger.dart';

class StoreVersionService {
  static final Dio _dio = Dio();

  /// Get the latest version from Play Store or App Store
  static Future<String?> getLatestStoreVersion() async {
    try {
      if (Platform.isAndroid) {
        return await _getPlayStoreVersion();
      } else if (Platform.isIOS) {
        return await _getAppStoreVersion();
      }
      return null;
    } catch (e, stackTrace) {
      logger.e('Error fetching store version',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Get version from Google Play Store
  static Future<String?> _getPlayStoreVersion() async {
    try {
      final packageName = RemoteConfigService.androidPackageName;
      final url = 'https://play.google.com/store/apps/details?id=$packageName';

      logger.i('🔍 Fetching Play Store version for: $packageName');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
          },
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        // Look for version patterns in the HTML content
        final htmlContent = response.data.toString();
        final versionRegex = RegExp(
            r'Current Version["\s]*[>]*[\s]*([0-9]+\.[0-9]+\.[0-9]+)',
            caseSensitive: false);
        final match = versionRegex.firstMatch(htmlContent);

        if (match != null && match.group(1) != null) {
          final version = match.group(1)!;
          logger.i('📱 Found Play Store version: $version');
          return version;
        }

        // Alternative approach - try other version patterns
        final versionPatterns = [
          RegExp(r'"([0-9]+\.[0-9]+\.[0-9]+)".*versionName',
              caseSensitive: false),
          RegExp(r'versionName.*"([0-9]+\.[0-9]+\.[0-9]+)"',
              caseSensitive: false),
          RegExp(r'Current Version.*?([0-9]+\.[0-9]+\.[0-9]+)',
              caseSensitive: false),
        ];

        for (final pattern in versionPatterns) {
          final match = pattern.firstMatch(htmlContent);
          if (match != null && match.group(1) != null) {
            final version = match.group(1)!;
            logger.i('📱 Found Play Store version (pattern): $version');
            return version;
          }
        }

        logger.w('⚠️ Could not parse Play Store version from HTML');
        return null;
      } else {
        logger.e('❌ Failed to fetch Play Store page: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      logger.e('❌ Error fetching Play Store version',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Get version from Apple App Store
  static Future<String?> _getAppStoreVersion() async {
    try {
      final appId = RemoteConfigService.iosAppStoreId;
      final url = 'https://itunes.apple.com/lookup?id=$appId';

      logger.i('🔍 Fetching App Store version for ID: $appId');

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['results'] != null && data['results'].isNotEmpty) {
          final version = data['results'][0]['version'];
          logger.i('🍎 Found App Store version: $version');
          return version;
        } else {
          logger.w('⚠️ No results found in App Store response');
          return null;
        }
      } else {
        logger.e('❌ Failed to fetch App Store data: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      logger.e('❌ Error fetching App Store version',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }
}
