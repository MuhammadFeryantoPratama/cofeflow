import 'package:get/get.dart';
import '../models/menu_model.dart';
import '../services/menu_service.dart';

/// Controller for the Menu Management page
/// Handles CRUD operations and filtering
class CoffeeMenuController extends GetxController {
  final RxList<MenuModel> allMenus = <MenuModel>[].obs;
  final RxList<MenuModel> filteredMenus = <MenuModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenus();

    // React to search/filter changes
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCategory, (_) => _applyFilters());
  }

  /// Load all menus from service
  Future<void> loadMenus() async {
    isLoading.value = true;
    try {
      final menus = await MenuService.getMenus();
      allMenus.value = menus;
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menus: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Apply search and category filters
  void _applyFilters() {
    List<MenuModel> result = List.from(allMenus);

    // Filter by category
    if (selectedCategory.value != 'All') {
      result = result
          .where((menu) => menu.category == selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((menu) =>
              menu.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredMenus.value = result;
  }

  /// Set the category filter
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  /// Update the search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  /// Add a new menu item
  Future<void> addMenu(MenuModel menu) async {
    try {
      await MenuService.addMenu(menu);
      await loadMenus();
      Get.snackbar('Success', '${menu.name} added successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add menu: $e');
    }
  }

  /// Update an existing menu item
  Future<void> updateMenu(MenuModel menu) async {
    try {
      await MenuService.updateMenu(menu);
      await loadMenus();
      Get.snackbar('Success', '${menu.name} updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update menu: $e');
    }
  }

  /// Delete a menu item
  Future<void> deleteMenu(int id) async {
    try {
      await MenuService.deleteMenu(id);
      await loadMenus();
      Get.snackbar('Success', 'Menu deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete menu: $e');
    }
  }
}
