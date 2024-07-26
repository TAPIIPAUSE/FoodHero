import 'package:flutter/material.dart';
import 'package:foodhero/pages/addFoodDetails.dart';
import 'package:foodhero/pages/foodDetails.dart';
import 'package:foodhero/pages/household.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: login_regis(),
      //home: addFoodDetails(),
      //home: foodDetails(),
      home: household(),
    );
  }
}
