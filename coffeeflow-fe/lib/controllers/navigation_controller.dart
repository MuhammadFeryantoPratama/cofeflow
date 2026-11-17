import 'package:get/get.dart';
import 'home_controller.dart';
import 'menu_controller.dart';
import 'order_controller.dart';
import 'history_controller.dart';

/// Controller for managing bottom navigation tabs across the app
class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// Change active tab and trigger data refresh for the destination page
  void changeTab(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().refreshData();
        }
        break;
      case 1:
        if (Get.isRegistered<CoffeeMenuController>()) {
          Get.find<CoffeeMenuController>().loadMenus();
        }
        break;
      case 2:
        if (Get.isRegistered<OrderController>()) {
          Get.find<OrderController>().loadMenus();
        }
        break;
      case 3:
        if (Get.isRegistered<HistoryController>()) {
          Get.find<HistoryController>().refreshOrders();
        }
        break;
    }
  }
}

