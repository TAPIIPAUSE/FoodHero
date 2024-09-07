import 'package:flutter/material.dart';
import 'package:foodhero/example/get.dart';
import 'package:foodhero/example/post.dart';
// import 'package:foodhero/example/put.dart';

void main() {
  runApp(const MaterialApp(
    title: "APP",
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const POST();
                  }));
                },
                child: const Text("POST"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const GET();
                  }));
                },
                child: const Text("GET"),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const PUT();
              //     }));
              //   },
              //   child: const Text("UPDATE"),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const GET();
              //     }));
              //   },
              //   child: const Text("DELETE"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
