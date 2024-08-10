import 'package:flutter/material.dart';
import 'package:foodhero/pages/interorg/dashboard_inter.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/pages/interorg/waste_chart.dart';
import 'package:foodhero/pages/inventory/category.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/inventory/search/search_item.dart';
import 'package:foodhero/pages/notifications.dart';
import 'package:foodhero/pages/register.dart';
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
        return const Register();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'inventory/:foodCategory',
          builder: (BuildContext context, GoRouterState state) {
            final foodCategory =
                state.pathParameters['foodCategory'] ?? 'All food';
            return Inventory(
              initialFoodCategory: foodCategory,
            );
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
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
