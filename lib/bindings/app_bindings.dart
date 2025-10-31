import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/controllers/notification_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(NewsController(), permanent: true);
    Get.lazyPut<NotificationController>(() => NotificationController());
  }
}