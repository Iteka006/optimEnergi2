import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_detail_page.dart';
import 'notification_data.dart';
import 'notification_type.dart'; // Import NotificationType
import 'package:intl/intl.dart'; // For date formatting

class NotificationsPage extends StatelessWidget {
  final String userID; // Add userID parameter

  NotificationsPage({required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .collection('notifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found.'));
          }

          final List<NotificationData> notifications = snapshot.data!.docs
              .map((doc) => NotificationData.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              String formattedTime = DateFormat.jm().format(notification.time);
              bool isToday = DateTime.now().difference(notification.time).inDays == 0;

              IconData iconData;
              Color iconColor;
              switch (notification.type) {
                case NotificationType.Important:
                  iconData = Icons.error;
                  iconColor = Colors.red;
                  break;
                case NotificationType.Info:
                  iconData = Icons.info;
                  iconColor = Colors.blue;
                  break;
                default:
                  iconData = Icons.notifications;
                  iconColor = Colors.grey;
              }

              return ListTile(
                leading: Icon(iconData, color: iconColor),
                title: Text(notification.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body),
                    if (notification.location != null)
                      Text('Location: ${notification.location!}'),
                    SizedBox(height: 4),
                    Text(
                      '$formattedTime ${isToday ? '(Today)' : ''}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailPage(notification: notification),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
