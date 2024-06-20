import 'package:flutter/material.dart';

class AddFood extends StatelessWidget {
  const AddFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food"),
      )
    );
  }
}