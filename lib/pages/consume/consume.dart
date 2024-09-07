import 'package:flutter/material.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/theme.dart';

class Consume extends StatefulWidget {
  @override
  _ConsumeState createState() => _ConsumeState();
}

class _ConsumeState extends State<Consume> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        selectedRouteIndex: 1,
        child: Scaffold(
          backgroundColor: AppTheme.lightGreenBackground,
        ));
  }
}
