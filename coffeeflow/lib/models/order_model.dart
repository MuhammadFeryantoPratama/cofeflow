/// Model representing an item within an order
class OrderItem {
  final MenuReference menu;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.menu,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menu: MenuReference.fromJson(json['menu'] ?? json),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,
      subtotal: (json['subtotal'] is num)
          ? (json['subtotal'] as num).toDouble()
          : double.tryParse(json['subtotal'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu.toJson(),
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

/// Lightweight reference to a menu item within an order
class MenuReference {
  final int? id;
  final String name;
  final double price;

  MenuReference({
    this.id,
    required this.name,
    required this.price,
  });

  factory MenuReference.fromJson(Map<String, dynamic> json) {
    return MenuReference(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
    };
  }
}

/// Model representing a complete order/transaction
class OrderModel {
  final int? id;
  final String orderNumber;
  final DateTime date;
  final List<OrderItem> items;
  final double totalAmount;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.date,
    required this.items,
    required this.totalAmount,
  });

  /// Total number of individual items in this order
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      orderNumber: json['order_number'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['total_amount'] is num)
          ? (json['total_amount'] as num).toDouble()
          : double.tryParse(json['total_amount'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_number': orderNumber,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
    };
  }
}
