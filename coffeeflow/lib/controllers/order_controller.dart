import 'package:get/get.dart';
import '../models/menu_model.dart';
import '../services/menu_service.dart';
import '../services/order_service.dart';

/// Controller for the Order Creation page
/// Manages available menu items and cart state
class OrderController extends GetxController {
  final RxList<MenuModel> availableMenus = <MenuModel>[].obs;
  final RxMap<int, int> cart = <int, int>{}.obs; // menuId -> quantity
  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMenus();
  }

  /// Load available menus for ordering
  Future<void> loadMenus() async {
    isLoading.value = true;
    try {
      availableMenus.value = await MenuService.getMenus();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menus: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add one unit of a menu item to the cart
  void addToCart(int menuId) {
    cart[menuId] = (cart[menuId] ?? 0) + 1;
    cart.refresh();
  }

  /// Remove one unit of a menu item from the cart
  void removeFromCart(int menuId) {
    if (cart.containsKey(menuId)) {
      if (cart[menuId]! > 1) {
        cart[menuId] = cart[menuId]! - 1;
      } else {
        cart.remove(menuId);
      }
      cart.refresh();
    }
  }

  /// Get the quantity of a specific menu item in the cart
  int getQuantity(int menuId) {
    return cart[menuId] ?? 0;
  }

  /// Calculate the total amount for the entire cart
  double get totalAmount {
    double total = 0;
    cart.forEach((menuId, qty) {
      final menu = availableMenus.firstWhereOrNull((m) => m.id == menuId);
      if (menu != null) {
        total += menu.price * qty;
      }
    });
    return total;
  }

  /// Get the number of distinct items in the cart
  int get cartItemCount => cart.length;

  /// Check if the cart is empty
  bool get isCartEmpty => cart.isEmpty;

  /// Submit the order
  Future<void> submitOrder() async {
    if (isCartEmpty) {
      Get.snackbar('Warning', 'Cart is empty. Please add items first.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      // Build cart map: MenuModel -> quantity
      final Map<MenuModel, int> cartMap = {};
      cart.forEach((menuId, qty) {
        final menu = availableMenus.firstWhereOrNull((m) => m.id == menuId);
        if (menu != null) {
          cartMap[menu] = qty;
        }
      });

      await OrderService.createOrder(cartMap);
      cart.clear();
      cart.refresh();

      Get.snackbar(
        'Order Created!',
        'Your order has been placed successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e');
    } finally {
      isSubmitting.value = false;
    }
  }
}
