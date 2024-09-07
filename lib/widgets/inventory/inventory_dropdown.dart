import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';

const List<String> list = <String>['Refrigerator', 'Pantry'];

class InventoryDropdownMenu extends StatefulWidget {
  const InventoryDropdownMenu({super.key});

  @override
  State<InventoryDropdownMenu> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<InventoryDropdownMenu> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      value: dropdownValue,
      dropdownColor: AppTheme.mainBlue,
      icon: const Icon(
        Icons.switch_left_rounded,
        color: Colors.white,
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (String? value) {
        setState(
          () {
            dropdownValue = value!;
          },
        );
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    ));
  }
}
