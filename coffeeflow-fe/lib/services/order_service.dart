import '../models/order_model.dart';
import '../models/menu_model.dart';
import 'api_service.dart';

/// Service layer for order operations strictly from REST API & MySQL.
class OrderService {
  static int _orderCount = 0;

  static String _generateOrderNumber() {
    _orderCount++;
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'CF-$dateStr-${_orderCount.toString().padLeft(3, '0')}';
  }

  /// Fetch all orders directly from MySQL
  static Future<List<OrderModel>> getOrders() async {
    final response = await ApiService.get('orders');
    final List<dynamic> data =
        response is List ? response : response['data'] ?? [];
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }

  /// Create a new order to MySQL
  static Future<OrderModel> createOrder(Map<MenuModel, int> cart) async {
    final items = cart.entries.map((entry) {
      return OrderItem(
        menu: MenuReference(
          id: entry.key.id,
          name: entry.key.name,
          price: entry.key.price,
        ),
        quantity: entry.value,
        subtotal: entry.key.price * entry.value,
      );
    }).toList();

    final totalAmount = items.fold(0.0, (sum, item) => sum + item.subtotal);

    final order = OrderModel(
      id: 0,
      orderNumber: _generateOrderNumber(),
      date: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
    );

    final response = await ApiService.post('orders', order.toJson());
    return OrderModel.fromJson(response['data'] ?? response);
  }

  /// Get total revenue from all orders
  static Future<double> getTotalRevenue() async {
    final orders = await getOrders();
    return orders.fold<double>(0.0, (sum, order) => sum + order.totalAmount);
  }
}
