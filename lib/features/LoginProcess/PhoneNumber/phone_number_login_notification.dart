import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('ic_notification'); // Your custom icon here

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'login_channel',
      'Login Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification', // Optional, explicitly set here too
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notifications.show(0, title, body, details);
  }
}