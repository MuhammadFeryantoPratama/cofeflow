import '../models/menu_model.dart';
import 'api_service.dart';

/// Service layer for menu CRUD operations.
/// Uses sample data as fallback when the backend is not available.
class MenuService {
  /// Flag to toggle between API and sample data
  /// Set to true when your CI4 backend is ready
  static bool useApi = false;

  /// Sample data for development without backend
  static final List<MenuModel> _sampleMenus = [
    MenuModel(id: 1, name: 'Americano', category: 'Coffee', price: 18000),
    MenuModel(id: 2, name: 'Cafe Latte', category: 'Coffee', price: 22000),
    MenuModel(id: 3, name: 'Cappuccino', category: 'Coffee', price: 22000),
    MenuModel(id: 4, name: 'Espresso', category: 'Coffee', price: 15000),
    MenuModel(id: 5, name: 'Mocha', category: 'Coffee', price: 25000),
    MenuModel(id: 6, name: 'Matcha Latte', category: 'Non-Coffee', price: 20000),
    MenuModel(id: 7, name: 'Chocolate', category: 'Non-Coffee', price: 18000),
    MenuModel(id: 8, name: 'Thai Tea', category: 'Non-Coffee', price: 16000),
    MenuModel(id: 9, name: 'Lemon Tea', category: 'Non-Coffee', price: 14000),
  ];
  static int _nextId = 10;

  /// Fetch all menus
  static Future<List<MenuModel>> getMenus() async {
    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      return List.from(_sampleMenus);
    }
    final response = await ApiService.get('menus');
    final List<dynamic> data = response is List ? response : response['data'] ?? [];
    return data.map((json) => MenuModel.fromJson(json)).toList();
  }

  /// Add a new menu item
  static Future<MenuModel> addMenu(MenuModel menu) async {
    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      final newMenu = menu.copyWith(id: _nextId++);
      _sampleMenus.add(newMenu);
      return newMenu;
    }
    final response = await ApiService.post('menus', menu.toJson());
    return MenuModel.fromJson(response['data'] ?? response);
  }

  /// Update an existing menu item
  static Future<MenuModel> updateMenu(MenuModel menu) async {
    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      final index = _sampleMenus.indexWhere((m) => m.id == menu.id);
      if (index != -1) _sampleMenus[index] = menu;
      return menu;
    }
    final response = await ApiService.put('menus/${menu.id}', menu.toJson());
    return MenuModel.fromJson(response['data'] ?? response);
  }

  /// Delete a menu item
  static Future<void> deleteMenu(int id) async {
    if (!useApi) {
      await Future.delayed(const Duration(milliseconds: 300));
      _sampleMenus.removeWhere((m) => m.id == id);
      return;
    }
    await ApiService.delete('menus/$id');
  }
}
