import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}