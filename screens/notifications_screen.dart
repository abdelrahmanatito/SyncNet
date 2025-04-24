import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  final List<AppNotification> notifications;

  const NotificationsScreen({
    super.key,
    required this.notifications,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Sort notifications by date (newest first)
    final sortedNotifications = List.of(widget.notifications)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark all as read'),
            ),
        ],
      ),
      body: sortedNotifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: sortedNotifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(sortedNotifications[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final formattedDate = dateFormat.format(notification.timestamp);
    
    Color iconColor;
    switch (notification.type) {
      case NotificationType.alert:
        iconColor = Colors.red;
        break;
      case NotificationType.warning:
        iconColor = Colors.orange;
        break;
      case NotificationType.success:
        iconColor = Colors.green;
        break;
      case NotificationType.info:
      default:
        iconColor = Colors.blue;
    }
    
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          widget.notifications.removeWhere((n) => n.id == notification.id);
        });
      },
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            notification.icon,
            color: iconColor,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          // Navigate to related screen based on notification type
        },
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in widget.notifications) {
        notification.isRead = true;
      }
    });
  }
}
