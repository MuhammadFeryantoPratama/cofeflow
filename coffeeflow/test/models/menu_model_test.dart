import 'package:flutter_test/flutter_test.dart';
import 'package:coffeeflow/models/menu_model.dart';

void main() {
  group('MenuModel Tests', () {
    test('fromJson deserializes properly', () {
      final json = {
        'id': 1,
        'name': 'Americano',
        'category': 'Coffee',
        'price': 18000,
      };

      final menu = MenuModel.fromJson(json);
      expect(menu.id, 1);
      expect(menu.name, 'Americano');
      expect(menu.category, 'Coffee');
      expect(menu.price, 18000.0);
    });

    test('toJson serializes properly for CodeIgniter 4 backend', () {
      final menu = MenuModel(
        id: 2,
        name: 'Matcha Latte',
        category: 'Non-Coffee',
        price: 20000,
      );

      final json = menu.toJson();
      expect(json['id'], 2);
      expect(json['name'], 'Matcha Latte');
      expect(json['category'], 'Non-Coffee');
      expect(json['price'], 20000.0);
    });

    test('copyWith updates fields correctly', () {
      final menu = MenuModel(
        id: 3,
        name: 'Cappuccino',
        category: 'Coffee',
        price: 22000,
      );

      final updated = menu.copyWith(price: 24000);
      expect(updated.id, 3);
      expect(updated.name, 'Cappuccino');
      expect(updated.price, 24000.0);
    });
  });
}

