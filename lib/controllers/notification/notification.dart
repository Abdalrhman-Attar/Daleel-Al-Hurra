import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/notification.dart';
import '../../stores/preferences_store.dart';

class NotificationController extends GetxController {
  // RxBool for reactive state management
  RxBool isReceivingNotifications = true.obs;
  // Rx list for reactive state management
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final PreferencesStore preferencesStore = Get.find<PreferencesStore>();
  // RxInt for unread counts
  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotificationPreference();
    fetchNotifications();
  }

  // Load the notification preference from SharedPreferences
  Future<void> _loadNotificationPreference() async {
    try {
      isReceivingNotifications.value = preferencesStore.isReceivingNotification;
      _applyNotificationSettings();
    } catch (e) {
      Logger().e('Error loading notification preferences: $e');
      // Default to true if there's an error
      isReceivingNotifications.value = true;
    }
  }

  // Update the notification preference and persist it
  Future<void> toggleNotifications(bool value) async {
    try {
      preferencesStore.isReceivingNotification = value;
      isReceivingNotifications.value = value;
      _applyNotificationSettings();

      // If turning notifications on, request permission again if needed
      if (value) {
        await _requestFCMPermission();
      }
    } catch (e) {
      Logger().e('Error saving notification preferences: $e');
    }
  }

  // Apply notification settings to Firebase
  void _applyNotificationSettings() async {
    try {
      if (isReceivingNotifications.value) {
        // Enable Firebase notifications
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      } else {
        // Disable Firebase notifications in foreground
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
      }
    } catch (e) {
      Logger().e('Error applying notification settings: $e');
    }
  }

  // Request Firebase permission
  Future<void> _requestFCMPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Update UI based on permission result
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        isReceivingNotifications.value = true;
      } else {
        isReceivingNotifications.value = false;
      }

      // Save the updated preference
      preferencesStore.isReceivingNotification = isReceivingNotifications.value;
    } catch (e) {
      Logger().e('Error requesting FCM permission: $e');
    }
  }

  // Fetch notifications from local database
  Future<void> fetchNotifications() async {
    try {
      notifications.value = await NotificationDatabase.getNotifications();
      _updateUnreadCount();
    } catch (e) {
      Logger().e('Error fetching notifications: $e');
      notifications.value = [];
    }
  }

  // Update unread count
  void _updateUnreadCount() {
    unreadCount.value =
        notifications.where((notification) => !notification.isRead).length;
  }

  // Mark a notification as read
  Future<void> markAsRead(int id) async {
    try {
      await NotificationDatabase.markAsRead(id);
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      await NotificationDatabase.markAllAsRead();
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error marking all notifications as read: $e');
    }
  }

  // Delete a notification
  Future<void> deleteNotification(int id) async {
    try {
      await NotificationDatabase.deleteNotification(id);
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error deleting notification: $e');
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await NotificationDatabase.deleteAllNotifications();
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error clearing all notifications: $e');
    }
  }

  // Add a new notification directly (for testing)
  Future<void> addTestNotification(String title, String body) async {
    try {
      await NotificationDatabase.insertNotification(
        NotificationModel(
          title: title,
          body: body,
          timestamp: DateTime.now(),
        ),
      );
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error adding test notification: $e');
    }
  }

  // Save notification from FCM message
  Future<void> saveNotificationFromFCM(RemoteMessage message) async {
    try {
      await NotificationDatabase.insertNotification(
        NotificationModel(
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? '',
          timestamp: DateTime.now(),
          data: message.data,
        ),
      );
      await fetchNotifications();
    } catch (e) {
      Logger().e('Error saving notification from FCM: $e');
    }
  }
}
