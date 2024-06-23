import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      //example
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.go('/add_food'),
              child: const Text('Go to the add food'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/edit_food'),
              child: const Text('Go to the edit food'),
            ),
          ],
        ),
      ),
    );
  }
}
