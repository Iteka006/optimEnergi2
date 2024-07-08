import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_data.dart';
import 'notification_detail_page.dart';
import 'notification_type.dart';
import 'notifications_page.dart';

class NotificationManager {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final List<NotificationData> _notifications = [];
  static double _dailyBudget = 0;
  static bool _budgetExceededNotified = false; // Flag to track if notification has been shown
  static late String userID; // Add userID

  static List<NotificationData> get notifications => _notifications;

  static Future<void> init(BuildContext context, String userID) async {
    NotificationManager.userID = userID; // Initialize userID
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NotificationsPage(userID: userID)),
        );
      },
    );

    // Reset the notification flag at the start of each day
    Timer.periodic(Duration(days: 1), (timer) {
      _budgetExceededNotified = false;
    });
  }

  static void setDailyBudget(double budget) {
    _dailyBudget = budget;
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required NotificationType type, // Include NotificationType in parameters
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    NotificationData notification = NotificationData(
      id: id,
      title: title,
      body: body,
      time: DateTime.now(),
      type: type, // Assign NotificationType to the NotificationData instance
    );

    _notifications.add(notification);

    // Save the notification to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('notifications')
        .add(notification.toMap());
  }

  static void checkBudget(double dailyUsage) {
    if (_dailyBudget > 0 && dailyUsage >= _dailyBudget && !_budgetExceededNotified) {
      showNotification(
        id: 1,
        title: 'Daily Budget Exceeded',
        body: 'You have exceeded your daily energy budget of $_dailyBudget kWh.',
        type: NotificationType.Info, // Example: Set NotificationType
      );

      _budgetExceededNotified = true; // Set the flag to prevent multiple notifications
    }
  }
}
