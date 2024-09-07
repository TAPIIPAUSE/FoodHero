import 'package:flutter/material.dart';

const List<String> list = <String>['Refrigerator', 'Pantry'];

class SortDropdownMenu extends StatefulWidget {
  final List<String> sortlist;
  const SortDropdownMenu({
    super.key,
    required this.sortlist,
  });

  @override
  State<SortDropdownMenu> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<SortDropdownMenu> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.sortlist.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        dropdownColor: Colors.white,
        icon: const Icon(
          Icons.switch_left_rounded,
          // color: Color,
        ),
        // style: const TextStyle(color: Colors.white),
        onChanged: (String? value) {
          setState(() {
            dropdownValue = value!;
          });
        },
        items: widget.sortlist.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
