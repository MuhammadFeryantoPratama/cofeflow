import 'package:flutter_test/flutter_test.dart';
import 'package:coffeeflow/models/order_model.dart';

void main() {
  group('OrderModel Tests', () {
    test('fromJson and toJson deserialize and serialize order correctly', () {
      final json = {
        'id': 1,
        'order_number': 'CF-20261114-001',
        'date': '2026-11-14T10:00:00.000Z',
        'items': [
          {
            'menu': {'id': 1, 'name': 'Americano', 'price': 18000},
            'quantity': 2,
            'subtotal': 36000,
          },
          {
            'menu': {'id': 6, 'name': 'Matcha Latte', 'price': 20000},
            'quantity': 1,
            'subtotal': 20000,
          }
        ],
        'total_amount': 56000,
      };

      final order = OrderModel.fromJson(json);
      expect(order.id, 1);
      expect(order.orderNumber, 'CF-20261114-001');
      expect(order.items.length, 2);
      expect(order.totalItems, 3);
      expect(order.totalAmount, 56000.0);

      final serialized = order.toJson();
      expect(serialized['order_number'], 'CF-20261114-001');
      expect((serialized['items'] as List).length, 2);
      expect(serialized['total_amount'], 56000.0);
    });
  });
}

