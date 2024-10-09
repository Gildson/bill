import 'package:bill/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification(
    {
      required this.id,
      required this.title,
      required this.body,
      required this.payload
    }
  );
}

class NotificationServer {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationServer() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await _inicializeNotifications();
  }

  Future<void> _inicializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onDidReceiveNotificationResponse: _onSelectedNotifications,
    );
  }

  _onSelectedNotifications(NotificationResponse? notificationResponse) {
    if (notificationResponse!.payload != null) {
      Routes.navigatorKey?.currentState?.pushNamed(notificationResponse.payload!);
    }
  }

  void showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
      'pay_bill',
      'pay',
      channelDescription: 'Lembrete para pagar conta',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
    );
  }

  Future<void> checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectedNotifications(details.notificationResponse);
    }
  }
}