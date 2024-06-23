import 'package:flutter/material.dart';

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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
