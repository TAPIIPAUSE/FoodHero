import 'package:flutter/material.dart';
import 'package:foodhero/pages/inventory.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Inventory();
              }));
            },
            child: const Text("Login"),
          ),
        ));
  }
}
