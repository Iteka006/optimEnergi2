import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_type.dart';

class NotificationData {
  final int id;
  final String title;
  final String body;
  final DateTime time;
  final NotificationType type;
  final String? location; // Added location parameter

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.location, // Nullable location parameter
  });

  NotificationData copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? time,
    NotificationType? type,
    String? location,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      type: type ?? this.type,
      location: location ?? this.location,
    );
  }

  factory NotificationData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationData(
      id: data['id'] ?? 0,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      time: (data['time'] != null) ? (data['time'] as Timestamp).toDate() : DateTime.now(),
      type: NotificationType.values[data['type'] ?? 0],
      location: data['location'],
    );
  }

  // Add the toMap method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'time': Timestamp.fromDate(time),
      'type': type.index,
      'location': location,
    };
  }
}
