import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

/// Controller for the Order History page
/// Manages the list of past transactions
class HistoryController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  /// Load all orders from the service
  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      orders.value = await OrderService.getOrders();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh the order list
  Future<void> refreshOrders() async {
    await loadOrders();
  }
}
