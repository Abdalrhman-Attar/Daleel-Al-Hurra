import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../stores/secure_store.dart';

class FCMService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final DeviceDataStore _deviceStore = Get.find<DeviceDataStore>();
  final SecureStore _secureStore = Get.find<SecureStore>();
  Future<FCMService> init() async {
    // Request permission for iOS
    await _requestPermission();

    // Get and store FCM token
    await _getFCMToken();

    // Listen for token refresh
    _listenForTokenRefresh();

    // Setup message handlers
    _setupMessageHandlers();

    return this;
  }

  Future<void> _requestPermission() async {
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
      Logger().d('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      Logger().d('User granted provisional permission');
    } else {
      Logger().d('User declined or has not accepted permission');
    }
  }

  Future<void> _getFCMToken() async {
    try {
      var token = await _firebaseMessaging.getToken();
      if (token != null) {
        _secureStore.fcmToken = token;
        Logger().d('FCM Token: $token');
      } else {
        Logger().d('Failed to get FCM token');
      }
    } catch (e) {
      Logger().e('Error getting FCM token: $e');
    }
  }

  void _listenForTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _secureStore.fcmToken = newToken;
      Logger().d('FCM Token refreshed: $newToken');
      // Optionally send the new token to your server
      _sendTokenToServer(newToken);
    });
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().d('Got a message whilst in the foreground!');
      Logger().d('Message data: ${message.data}');

      if (message.notification != null) {
        Logger().d('Message also contained a notification: ${message.notification}');
        // Handle foreground notification display
        _showLocalNotification(message);
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification tap when app is terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger().d('A new onMessageOpenedApp event was published!');
      // Handle notification tap
      _handleNotificationTap(message);
    });
  }

  Future<void> _sendTokenToServer(String token) async {
    // Implement your server API call here
    // Example:
    /*
    try {
      await ApiService.sendFCMToken({
        'fcm_token': token,
        'device_id': _deviceStore.deviceId,
        'platform': _deviceStore.platform,
      });
    } catch (e) {
      debugPrint('Error sending token to server: $e');
    }
    */
  }

  void _showLocalNotification(RemoteMessage message) {
    // Implement local notification display for foreground messages
    // You might want to use flutter_local_notifications package
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle what happens when user taps notification
    Logger().d('Notification tapped: ${message.data}');
    // Navigate to specific screen based on message data
  }

  // Get current token (useful for manual refresh)
  Future<String?> getCurrentToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      Logger().e('Error getting current FCM token: $e');
      return null;
    }
  }

  // Delete token (useful for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _secureStore.fcmToken = '';
      Logger().d('FCM token deleted');
    } catch (e) {
      Logger().e('Error deleting FCM token: $e');
    }
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      Logger().d('Subscribed to topic: $topic');
    } catch (e) {
      Logger().e('Error subscribing to topic: $e');
    }
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      Logger().d('Unsubscribed from topic: $topic');
    } catch (e) {
      Logger().e('Error unsubscribing from topic: $e');
    }
  }
}

// Background message handler (must be top-level function)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger().d('Handling a background message: ${message.messageId}');
  // Handle background message
}
