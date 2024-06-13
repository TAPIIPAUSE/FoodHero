import 'package:flutter/material.dart';
import 'package:foodhero/pages/consumed_food.dart';
import 'package:foodhero/pages/dashboard.dart';
import 'package:foodhero/pages/edit_food.dart';
import 'package:foodhero/pages/household.dart';
import 'package:foodhero/pages/interorganization.dart';
import 'package:foodhero/pages/organization.dart';
import 'package:foodhero/pages/user_profile.dart';
import 'package:go_router/go_router.dart';

import 'package:foodhero/pages/add_food.dart';
import 'package:foodhero/pages/inventory.dart';
import 'package:foodhero/pages/login.dart';
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
            return const EditFood();
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
