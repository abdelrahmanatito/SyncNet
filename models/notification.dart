import 'package:flutter/material.dart';

enum NotificationType {
  info,
  warning,
  alert,
  success
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final IconData icon;
  final String? deviceId;
  final String? routineId;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.icon,
    this.deviceId,
    this.routineId,
    this.isRead = false,
  });
}

// Sample data
List<AppNotification> sampleNotifications = [
  AppNotification(
    id: '1',
    title: 'Front Door Camera',
    message: 'Motion detected at the front door',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    type: NotificationType.alert,
    icon: Icons.videocam,
    deviceId: '4',
  ),
  AppNotification(
    id: '2',
    title: 'Good Morning Routine',
    message: 'Routine executed successfully',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.success,
    icon: Icons.wb_sunny,
    routineId: '1',
  ),
  AppNotification(
    id: '3',
    title: 'Thermostat',
    message: 'Temperature reached 22°C',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    type: NotificationType.info,
    icon: Icons.thermostat,
    deviceId: '2',
    isRead: true,
  ),
  AppNotification(
    id: '4',
    title: 'Smart Speaker',
    message: 'Device disconnected',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    type: NotificationType.warning,
    icon: Icons.speaker,
    deviceId: '3',
    isRead: true,
  ),
];
