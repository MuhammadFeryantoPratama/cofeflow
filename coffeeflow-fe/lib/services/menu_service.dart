import '../models/menu_model.dart';
import 'api_service.dart';

/// Service layer for menu CRUD operations strictly from REST API & MySQL.
class MenuService {
  /// Fetch all menus directly from MySQL via CodeIgniter 4 REST API
  static Future<List<MenuModel>> getMenus() async {
    final response = await ApiService.get('menus');
    final List<dynamic> data =
        response is List ? response : response['data'] ?? [];
    return data.map((json) => MenuModel.fromJson(json)).toList();
  }

  /// Add a new menu item
  static Future<MenuModel> addMenu(MenuModel menu) async {
    final response = await ApiService.post('menus', menu.toJson());
    return MenuModel.fromJson(response['data'] ?? response);
  }

  /// Update an existing menu item
  static Future<MenuModel> updateMenu(MenuModel menu) async {
    final response = await ApiService.put('menus/${menu.id}', menu.toJson());
    return MenuModel.fromJson(response['data'] ?? response);
  }

  /// Delete a menu item
  static Future<void> deleteMenu(int id) async {
    await ApiService.delete('menus/$id');
  }
}
