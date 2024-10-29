import 'package:flutter/material.dart';
import 'package:foodhero/pages/House&Orga/join.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
import 'package:foodhero/pages/interorg/dashboard_inter.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/pages/interorg/waste_chart.dart';
import 'package:foodhero/pages/inventory/category.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/inventory/search/search_item.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/pages/notifications.dart';
import 'package:foodhero/pages/register.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('james');

  runApp(ChangeNotifierProvider(
    create: (context) => ConsumedItemsProvider(),
    child: MyApp(
      initialRoute: token != null ? '/home' : '/login',
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
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
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // final hID = ;
            return
                // FutureBuilder<int>(
                //   future: fetchHId(), // Fetch hID from database
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //     } else if (!snapshot.hasData) {
                //       return Center(child: Text('No ID found'));
                //     } else {
                //       int hID = snapshot.data!;
                //       return
                Inventory(initialFoodCategory: foodCategory);
            // }
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return RegisterScreen();
          },
        ),
        GoRoute(
          path: 'consumed',
          builder: (BuildContext context, GoRouterState state) {
            return const Consumed();
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
