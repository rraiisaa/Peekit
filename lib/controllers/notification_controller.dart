import 'package:get/get.dart';
import 'package:peekit_app/models/app_notification.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  // Tambah notifikasi baru
  void addNotification(String title, String message, {String? newsUrl}) {
    final newNotif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      time: DateTime.now(),
      newsUrl: newsUrl,
      isRead: false,
    );
    notifications.insert(0, newNotif);
  }

  // Tandai notif sudah dibaca
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
    }
  }

  // Toggle pilihan notifikasi (untuk multi-select)
  void toggleSelection(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isSelected = !notifications[index].isSelected;
      notifications.refresh();
    }
  }

  // Apakah ada notifikasi yang sedang dipilih
  bool get hasSelected => notifications.any((n) => n.isSelected);

  // Hapus notif yang terpilih
  void deleteSelected() {
    notifications.removeWhere((n) => n.isSelected);
    notifications.refresh();
  }

  // Hapus semua notif
  void clearAll() {
    notifications.clear();
  }
}
