/// Model representing a menu item in CoffeeFlow
class MenuModel {
  final int? id;
  final String name;
  final String category; // "Coffee" or "Non-Coffee"
  final double price;

  MenuModel({
    this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  /// Create a MenuModel from JSON response
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0,
    );
  }

  /// Convert MenuModel to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'category': category,
      'price': price,
    };
  }

  /// Create a copy with updated fields
  MenuModel copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}
