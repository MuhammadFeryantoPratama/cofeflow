import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../utils/app_colors.dart';
import '../utils/currency_format.dart';

/// Reusable menu item card with edit/delete actions
/// Used in the Menu Management page
class MenuCard extends StatelessWidget {
  final MenuModel menu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MenuCard({
    super.key,
    required this.menu,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Coffee icon container
            Container(
              width: 50,
              height: 50,
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
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Menu details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _CategoryChip(category: menu.category),
                      const SizedBox(width: 8),
                      Text(
                        CurrencyFormat.format(menu.price),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.espressoBrown,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.edit_outlined,
                  color: AppColors.coffeeBrown,
                  onTap: onEdit,
                ),
                const SizedBox(width: 4),
                _ActionButton(
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.error,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small chip showing the menu category
class _CategoryChip extends StatelessWidget {
  final String category;
  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.lightBeige,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.coffeeBrown,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Small icon button for edit/delete actions
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  const _ActionButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
