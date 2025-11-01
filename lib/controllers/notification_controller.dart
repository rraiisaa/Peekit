import 'package:get/get.dart';
import 'package:peekit_app/models/app_notification.dart';

class NotificationController extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  var isSelectionMode = false
      .obs; // 🔥 status apakah lagi dalam mode "select" untuk delete

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

  // Cek apakah ada yang dipilih
  bool get hasSelected => notifications.any((n) => n.isSelected);

  // Hapus notif terpilih
  void deleteSelected() {
    notifications.removeWhere((n) => n.isSelected);
    exitSelectionMode();
  }

  // Masuk mode select
  void enterSelectionMode() {
    isSelectionMode.value = true;
  }

  // Keluar mode select dan hapus semua tanda centang
  void exitSelectionMode() {
    isSelectionMode.value = false;
    for (var n in notifications) {
      n.isSelected = false;
    }
    notifications.refresh();
  }

  // Hapus semua notif
  void clearAll() {
    notifications.clear();
  }

  void clearSelection() {
  for (var n in notifications) {
    n.isSelected = false;
  }
  isSelectionMode.value = false; // keluar dari mode pilih
  notifications.refresh();
}

}
