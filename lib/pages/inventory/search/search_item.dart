import 'package:flutter/material.dart';
import 'package:foodhero/widgets/select_category.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({super.key});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late String fooditem;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget buildFoodItem() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Food item',
        hintText: 'Enter your food item',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
      ),
      // validator: (String? value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please enter your food item';
      //   }
      //   return null;
      // },
      onSaved: (String? value) {
        fooditem = value ?? '';
      },
    );
  }

// DateTime d = DateTime.now();
  DateTime today = DateTime.now();

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2050, 12),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        today = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search item"),
        backgroundColor: AppTheme.greenMainTheme,
        leading: BackButton(
          onPressed: () => context.go('/inventory/all food'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: buildFoodItem(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Category"),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const SelectFoodCategory();
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Expiry date"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        // '$today',
                        '${today.year}-${today.month}-${today.day}',
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today_rounded),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  formKey.currentState?.save();
                  print(fooditem);

                  context.go('/inventory/all food');
                },
                // style: buttonStyle,
                child: const Text("search"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
