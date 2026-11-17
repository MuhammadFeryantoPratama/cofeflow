import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/currency_format.dart';

/// Order creation page — select menu items and create an order
class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return SafeArea(
      child: Column(
        children: [
          // ── Page Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                // Cart badge
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: controller.isCartEmpty
                            ? AppColors.lightBeige
                            : AppColors.espressoBrown,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_rounded,
                            size: 16,
                            color: controller.isCartEmpty
                                ? AppColors.secondaryText
                                : AppColors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${controller.cartItemCount}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: controller.isCartEmpty
                                  ? AppColors.secondaryText
                                  : AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Menu List ──
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.espressoBrown,
                  ),
                );
              }

              if (controller.availableMenus.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu_rounded,
                          size: 64, color: AppColors.secondaryText),
                      const SizedBox(height: 16),
                      Text(
                        'No menu items available',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.availableMenus.length,
                itemBuilder: (context, index) {
                  final menu = controller.availableMenus[index];
                  return Obx(() {
                    final qty = controller.getQuantity(menu.id!);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: qty > 0
                            ? AppColors.espressoBrown.withAlpha(8)
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: qty > 0
                            ? Border.all(
                                color: AppColors.espressoBrown.withAlpha(40),
                                width: 1.5,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Menu icon
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: menu.category == 'Coffee'
                                  ? AppColors.espressoBrown.withAlpha(25)
                                  : AppColors.coffeeBrown.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              menu.category == 'Coffee'
                                  ? Icons.coffee_rounded
                                  : Icons.local_drink_rounded,
                              color: menu.category == 'Coffee'
                                  ? AppColors.espressoBrown
                                  : AppColors.coffeeBrown,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Menu info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormat.format(menu.price),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.espressoBrown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Quantity controls
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (qty > 0)
                                _QuantityButton(
                                  icon: Icons.remove_rounded,
                                  onTap: () => controller.removeFromCart(menu.id!),
                                ),
                              if (qty > 0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    '$qty',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                ),
                              _QuantityButton(
                                icon: Icons.add_rounded,
                                onTap: () => controller.addToCart(menu.id!),
                                isPrimary: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            }),
          ),

          // ── Cart Summary & Create Order Button ──
          Obx(() {
            if (controller.isCartEmpty) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cart summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.cartItemCount} items',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          CurrencyFormat.format(controller.totalAmount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.espressoBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Create Order button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () => controller.submitOrder(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.espressoBrown,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text(
                                'Create Order',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Round quantity increment/decrement button
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.espressoBrown : AppColors.lightBeige,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? AppColors.white : AppColors.darkText,
        ),
      ),
    );
  }
}
