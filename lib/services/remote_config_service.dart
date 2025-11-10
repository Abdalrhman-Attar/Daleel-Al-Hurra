import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../utils/loggers/custom_logger.dart';

class RemoteConfigService {
  static final _remoteConfig = FirebaseRemoteConfig.instance;
  static bool _initialized = false;

  static Future<bool> init() async {
    try {
      if (_initialized) {
        return true;
      }

      // Set default values
      await _remoteConfig.setDefaults({
        'x_api_token': 'fallback-token',
        'base_url': 'https://daleelalhurra.com/api',
        'android_package_name': 'com.daleelalhurra.frontend',
        'ios_app_store_id': '6670617809',
        'force_update_required': false,
        'latest_app_version': '1.1.29', // Set this to the latest Play Store version
        'update_message': 'Please update your app to continue',
      });

      // Configure settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1) // Shorter interval for development
            : const Duration(hours: 1), // Normal interval for production
      ));

      // Fetch and activate
      var updated = await _remoteConfig.fetchAndActivate();
      _initialized = true;

      logger.i('Remote Config initialized. Config updated: $updated');
      logger.d('Remote Config values:'
          '\n - API Token: ${_remoteConfig.getString('x_api_token')}'
          '\n - Base URL: ${_remoteConfig.getString('base_url')}');
      '\n - Android Package Name: ${_remoteConfig.getString('android_package_name')}'
          '\n - iOS App Store ID: ${_remoteConfig.getString('ios_app_store_id')}'
          '\n - Force Update Required: ${_remoteConfig.getBool('force_update_required')}'
          '\n - Update Message: ${_remoteConfig.getString('update_message')}';

      return true;
    } catch (e, stackTrace) {
      logger.e('Failed to initialize Remote Config', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  static String get apiToken {
    try {
      return _remoteConfig.getString('x_api_token');
    } catch (e) {
      logger.e('Error getting apiToken from Remote Config', error: e);
      return 'fallback-token';
    }
  }

  static String get baseUrl {
    try {
      return _remoteConfig.getString('base_url');
    } catch (e) {
      logger.e('Error getting baseUrl from Remote Config', error: e);
      return 'https://api.example.com';
    }
  }

  // Force a refresh of the remote config
  static Future<bool> refresh() async {
    try {
      await _remoteConfig.fetch();
      return await _remoteConfig.activate();
    } catch (e) {
      logger.e('Error refreshing Remote Config', error: e);
      return false;
    }
  }

  // Version checking methods
  static String get androidPackageName {
    try {
      return _remoteConfig.getString('android_package_name');
    } catch (e) {
      logger.e('Error getting androidPackageName from Remote Config', error: e);
      return 'com.daleelalhurra.frontend';
    }
  }

  static String get iosAppStoreId {
    try {
      return _remoteConfig.getString('ios_app_store_id');
    } catch (e) {
      logger.e('Error getting iosAppStoreId from Remote Config', error: e);
      return '6670617809';
    }
  }

  static bool get forceUpdateRequired {
    try {
      return _remoteConfig.getBool('force_update_required');
    } catch (e) {
      logger.e('Error getting forceUpdateRequired from Remote Config', error: e);
      return false;
    }
  }

  static String get updateMessage {
    try {
      return _remoteConfig.getString('update_message');
    } catch (e) {
      logger.e('Error getting updateMessage from Remote Config', error: e);
      return 'Please update your app to continue';
    }
  }

  static String get latestAppVersion {
    try {
      return _remoteConfig.getString('latest_app_version');
    } catch (e) {
      logger.e('Error getting latestAppVersion from Remote Config', error: e);
      return '1.1.29';
    }
  }
}
