import '../models/order_model.dart';
import '../models/menu_model.dart';

/// Service layer for order operations.
/// Uses sample data as fallback when the backend is not available.
class OrderService {
  static bool useApi = false;

  /// In-memory sample orders for development
  static final List<OrderModel> _sampleOrders = [
    OrderModel(
      id: 1,
      orderNumber: 'CF-20261114-001',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      items: [
        OrderItem(
          menu: MenuReference(id: 1, name: 'Americano', price: 18000),
          quantity: 2,
          subtotal: 36000,
        ),
        OrderItem(
          menu: MenuReference(id: 6, name: 'Matcha Latte', price: 20000),
          quantity: 1,
          subtotal: 20000,
        ),
      ],
      totalAmount: 56000,
    ),
    OrderModel(
      id: 2,
      orderNumber: 'CF-20261114-002',
      date: DateTime.now().subtract(const Duration(hours: 1)),
      items: [
        OrderItem(
          menu: MenuReference(id: 3, name: 'Cappuccino', price: 22000),
          quantity: 3,
          subtotal: 66000,
        ),
      ],
      totalAmount: 66000,
    ),
    OrderModel(
      id: 3,
      orderNumber: 'CF-20261114-003',
      date: DateTime.now().subtract(const Duration(minutes: 30)),
      items: [
        OrderItem(
          menu: MenuReference(id: 2, name: 'Cafe Latte', price: 22000),
          quantity: 1,
          subtotal: 22000,
        ),
        OrderItem(
          menu: MenuReference(id: 7, name: 'Chocolate', price: 18000),
          quantity: 2,
          subtotal: 36000,
        ),
      ],
      totalAmount: 58000,
    ),
  ];
  static int _nextId = 4;
  static int _orderCount = 3;

  /// Generate a unique order number
  static String _generateOrderNumber() {
    _orderCount++;
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'CF-$dateStr-${_orderCount.toString().padLeft(3, '0')}';
  }

  /// Fetch all orders (newest first)
  static Future<List<OrderModel>> getOrders() async {
    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      final sorted = List<OrderModel>.from(_sampleOrders)
        ..sort((a, b) => b.date.compareTo(a.date));
      return sorted;
    }
    // TODO: Implement API call
    // final response = await ApiService.get('orders');
    return [];
  }

  /// Create a new order from cart items
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
      id: _nextId++,
      orderNumber: _generateOrderNumber(),
      date: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
    );

    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      _sampleOrders.add(order);
      return order;
    }
    // TODO: Implement API call
    // final response = await ApiService.post('orders', order.toJson());
    return order;
  }

  /// Get total revenue from all orders
  static Future<double> getTotalRevenue() async {
    final orders = await getOrders();
    return orders.fold<double>(0.0, (sum, order) => sum + order.totalAmount);
  }
}
