import 'package:get/get.dart';
import '../services/menu_service.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

/// Controller for the Dashboard (Home) page
/// Manages summary statistics and recent orders
class HomeController extends GetxController {
  final RxInt totalMenus = 0.obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxList<OrderModel> recentOrders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Fetch menus count
      final menus = await MenuService.getMenus();
      totalMenus.value = menus.length;

      // Fetch orders
      final orders = await OrderService.getOrders();
      totalOrders.value = orders.length;

      // Calculate revenue
      totalRevenue.value =
          orders.fold(0.0, (sum, order) => sum + order.totalAmount);

      // Get the 3 most recent orders
      recentOrders.value = orders.take(3).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh all data — called when returning from other pages
  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
