import 'package:flutter/material.dart';
import 'package:foodhero/pages/House&Orga/join.dart';
import 'package:foodhero/pages/history.dart';
import 'package:foodhero/pages/interorg/dashboard_inter.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/pages/interorg/waste_chart.dart';
import 'package:foodhero/pages/inventory/category.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/inventory/search/search_item.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/pages/notifications.dart';
import 'package:foodhero/pages/register.dart';
import 'package:foodhero/pages/setting.dart';
import 'package:foodhero/pages/userprofile/user_dashboard.dart';
import 'package:foodhero/pages/userprofile/user_profile.dart';
import 'package:foodhero/pages/userprofile/user_waste_chart.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MainApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return login_regis();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'inventory/:foodCategory',
          builder: (BuildContext context, GoRouterState state) {
            final foodCategory =
                state.pathParameters['foodCategory'] ?? 'All food';
            return Inventory(initialFoodCategory: foodCategory);
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const Register();
          },
        ),
        GoRoute(
          path: 'HouseOrga',
          builder: (BuildContext context, GoRouterState state) {
            return join();
          },
        ),
        GoRoute(
          path: 'category',
          builder: (BuildContext context, GoRouterState state) {
            return const ChooseCategory();
          },
        ),
        GoRoute(
          path: 'searchitem',
          builder: (BuildContext context, GoRouterState state) {
            return const SearchItem();
          },
        ),
        GoRoute(
          path: 'notification',
          builder: (BuildContext context, GoRouterState state) {
            return const Notifications();
          },
        ),
        GoRoute(
          path: 'history',
          builder: (BuildContext context, GoRouterState state) {
            return const History();
          },
        ),
        GoRoute(
          path: 'inter_org',
          builder: (BuildContext context, GoRouterState state) {
            return const InterOrganization();
          },
        ),
        GoRoute(
          path: 'dashboard_inter',
          builder: (BuildContext context, GoRouterState state) {
            return const InterDashboard();
          },
        ),
        GoRoute(
          path: 'waste_chart',
          builder: (BuildContext context, GoRouterState state) {
            return const WasteChart();
          },
        ),
        GoRoute(
          path: 'user_profile',
          builder: (BuildContext context, GoRouterState state) {
            return const UserProfile();
          },
        ),
        GoRoute(
          path: 'user_dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const UserDashboard();
          },
        ),
        GoRoute(
          path: 'user_waste_chart',
          builder: (BuildContext context, GoRouterState state) {
            return const UserWasteChart();
          },
        ),
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) {
            return UserSetting();
          },
        ),
      ],
    ),
  ],
);

// Main app entry
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
    // return MaterialApp(
    //   // home: foodDetails(),
    //   home: household(),
    // );
  }
}

// Reusable scaffold with BottomNavigationBar
class MainScaffold extends StatelessWidget {
  final int selectedRouteIndex;
  final Widget child;

  const MainScaffold(
      {super.key, required this.selectedRouteIndex, required this.child});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        String foodCategory = 'All food';
        context.go('/inventory/${Uri.encodeComponent(foodCategory)}');

        break;
      case 1:
        context.go('/consumed');
        break;
      case 2:
        context.go('/inter_org');
        break;
      case 3:
        context.go('/HouseOrga');
        break;
    }
  }

  // Widget _getSelectedPage(int index) {
  //   switch (index) {
  //     case 0:
  //       return Inventory(); // Example page
  //     case 1:
  //     // return  ConsumedPage(); // Example page
  //     case 2:
  //       return InterDashboard(); // Example page
  //     case 3:
  //       return household(); // Example page
  //     default:
  //       return Inventory(); // Default page
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Consumed',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Inter',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Household',
            backgroundColor: AppTheme.greenMainTheme,
          ),
        ],
        currentIndex: selectedRouteIndex,
        selectedItemColor: AppTheme.lightGreenBackground,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
