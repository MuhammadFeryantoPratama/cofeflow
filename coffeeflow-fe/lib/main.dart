import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'utils/app_colors.dart';
import 'views/home/home_page.dart';
import 'views/menu/menu_page.dart';
import 'views/orders/order_page.dart';
import 'views/history/history_page.dart';
import 'widgets/bottom_navbar.dart';
import 'controllers/home_controller.dart';
import 'controllers/menu_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/navigation_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set system UI overlay style to match the app theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CoffeeFlowApp());
}

/// Root widget for CoffeeFlow app
class CoffeeFlowApp extends StatelessWidget {
  const CoffeeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CoffeeFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.espressoBrown,
          surface: AppColors.cream,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cream,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkText),
          titleTextStyle: TextStyle(
            color: AppColors.darkText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationPage(),
    );
  }
}

/// Main shell page that manages the bottom navigation and page switching
class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register GetX controllers
    Get.put(HomeController());
    Get.put(CoffeeMenuController());
    Get.put(OrderController());
    Get.put(HistoryController());
    final navController = Get.put(NavigationController());

    const pages = [
      HomePage(),
      MenuPage(),
      OrderPage(),
      HistoryPage(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: navController.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: CoffeeBottomNavBar(
          currentIndex: navController.currentIndex.value,
          onTap: navController.changeTab,
        ),
      ),
    );
  }
}
