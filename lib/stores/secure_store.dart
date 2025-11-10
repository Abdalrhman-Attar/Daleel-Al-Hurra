import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class SecureStore extends GetxService {
  static const _keyAuthToken = 'authToken';
  static const _keyFCMToken = 'fcmToken';

  final GetStorage _storage = GetStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final RxString _authToken = ''.obs;
  final RxString _fcmToken = ''.obs;

  Future<SecureStore> init() async {
    await GetStorage.init();

    _authToken.value = _storage.read(_keyAuthToken) ?? '';
    _fcmToken.value = _storage.read(_keyFCMToken) ?? '';

    ever(_authToken, (val) => _storage.write(_keyAuthToken, val));
    ever(_fcmToken, (val) => _storage.write(_keyFCMToken, val));

    await _initializeFCM();

    return this;
  }

  Future<void> _initializeFCM() async {
    try {
      // Request permission for iOS
      var settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        Logger().d('User granted FCM permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        Logger().d('User granted provisional FCM permission');
      } else {
        Logger().d('User declined or has not accepted FCM permission');
      }

      // Get FCM token
      var token = await _firebaseMessaging.getToken();
      if (token != null) {
        _fcmToken.value = token;
        Logger().d('FCM Token obtained: $token');
      } else {
        Logger().d('Failed to get FCM token');
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken.value = newToken;
        Logger().d('FCM Token refreshed: $newToken');
        // Optionally send the new token to your server
        _onTokenRefresh(newToken);
      });
    } catch (e) {
      Logger().e('Error initializing FCM: $e');
    }
  }

  void _onTokenRefresh(String newToken) {
    // Override this method to handle token refresh
    // For example, send to your server
    Logger().d('Token refreshed, implement server update logic here');
  }

  // Public methods for FCM token management
  Future<String?> refreshFCMToken() async {
    try {
      var token = await _firebaseMessaging.getToken();
      if (token != null) {
        _fcmToken.value = token;
        return token;
      }
      return null;
    } catch (e) {
      Logger().e('Error refreshing FCM token: $e');
      return null;
    }
  }

  Future<void> deleteFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken.value = '';
      Logger().d('FCM token deleted');
    } catch (e) {
      Logger().e('Error deleting FCM token: $e');
    }
  }

  String get authToken => _authToken.value;
  set authToken(String token) => _authToken.value = token;

  String get fcmToken => _fcmToken.value;
  set fcmToken(String token) => _fcmToken.value = token;

  void clearAuthToken() {
    _authToken.value = '';
    _storage.remove(_keyAuthToken);
  }
}
