import 'package:bank_app/controller/notifications/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController controller = Get.put(NotificationsController());
  @override
  void initState() {
    super.initState();
    controller.fetchNotifications();
  }

  String formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return "الآن";
    if (diff.inMinutes < 60) return "${diff.inMinutes} دقيقة";
    if (diff.inHours < 24) return "${diff.inHours} ساعة";
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  bool isNew(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    return now.difference(dateTime).inHours < 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الإشعارات")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text("لا يوجد إشعارات"));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];
            final fresh = isNew(notif['created_at']);
            return Card( 
              
              color: fresh ? Colors.grey.shade200 : Colors.white,
              child: ListTile(
                title: Text(
                  notif['title'] ?? '',
                  style: TextStyle(
                    fontWeight: fresh ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif['body'] ?? ''),
                    const SizedBox(height: 4),
                    Text(
                      formatTime(notif['created_at']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
