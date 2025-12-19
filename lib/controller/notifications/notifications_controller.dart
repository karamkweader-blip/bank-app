import 'package:bank_app/data/datasource/remote/app/notifications/notifications_remote.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final NotificationsService _service = NotificationsService();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _service.getNotifications();
        if (notifications.isNotEmpty) {
        for (var n in notifications) {
          n['is_read'] = 1;
        }
        notifications.refresh();
      }
    } finally {
      isLoading.value = false;
    }
  }
  // void markAllAsRead() async {
  //   await _service.markAllAsRead();
  // }

    // void markAsRead(int id) async {
  //   await _service.markAsRead(id);
  //   int index = notifications.indexWhere((n) => n['id'] == id);
  //   if (index != -1) {
  //     notifications[index]['is_read'] = 1;
  //     notifications.refresh();
  //   }
  // }
}
