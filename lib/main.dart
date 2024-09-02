import 'package:flutter/material.dart';
import 'package:foodhero/pages/House&Orga/join.dart';
import 'package:foodhero/pages/interorg/dashboard_inter.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/pages/interorg/waste_chart.dart';
import 'package:foodhero/pages/inventory/category.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/inventory/search/search_item.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/pages/notifications.dart';
import 'package:foodhero/pages/register.dart';

void main() {
  runApp(const MainApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Inventory();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const Login();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const Register();
          },
        ),
        GoRoute(
          path: 'add_food',
          builder: (BuildContext context, GoRouterState state) {
            return const AddFood();
          },
        ),
        GoRoute(
          path: 'edit_food',
          builder: (BuildContext context, GoRouterState state) {
            return join();
          },
        ),
        GoRoute(
          path: 'consumed_food',
          builder: (BuildContext context, GoRouterState state) {
            return const ConsumedFood();
          },
        ),
        GoRoute(
          path: 'wasted_food',
          builder: (BuildContext context, GoRouterState state) {
            return const ConsumedFood();
          },
        ),
        GoRoute(
          path: 'notification',
          builder: (BuildContext context, GoRouterState state) {
            return const Notifications();
          },
        ),
        GoRoute(
          path: 'household',
          builder: (BuildContext context, GoRouterState state) {
            return const Household();
          },
        ),
        GoRoute(
          path: 'organization',
          builder: (BuildContext context, GoRouterState state) {
            return const Organization();
          },
        ),
        GoRoute(
          path: 'inter_organization',
          builder: (BuildContext context, GoRouterState state) {
            return const InterOrganization();
          },
        ),
        GoRoute(
          path: 'dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const Dashboard();
          },
        ),
        GoRoute(
          path: 'user_profile',
          builder: (BuildContext context, GoRouterState state) {
            return const UserProfile();
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
    );
  }
}
