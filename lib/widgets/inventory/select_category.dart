import 'package:flutter/material.dart';
import 'package:foodhero/utils/constants.dart';

class SelectFoodCategory extends StatefulWidget {
  const SelectFoodCategory({super.key});

  @override
  State<SelectFoodCategory> createState() => _SelectFoodCategory();
}

class _SelectFoodCategory extends State<SelectFoodCategory> {
  final List<String> _items = foodCategory;
  final List<bool> _selected = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: CheckboxListTile(
            title: Text(_items[index]),
            value: _selected[index],
            onChanged: (bool? value) {
              setState(() {
                _selected[index] = value ?? false;
              });
            },
          ),
        );
      },
    );
  }
}
