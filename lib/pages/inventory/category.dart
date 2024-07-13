import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  final ButtonStyle backButtonStyle = IconButton.styleFrom(
    backgroundColor: AppTheme.greenMainTheme,
    foregroundColor: Colors.white,
  );

  final List<Color> gridColors = [
    AppTheme.softBrightGreen,
    AppTheme.softGreen,
    AppTheme.softBlue,
    AppTheme.softRed,
    AppTheme.softOrange,
    AppTheme.greenMainTheme,
  ];
  final List<String> foodTypes = [
    'Cooked food',
    'Fresh food',
    'Frozen food',
    'Dry food',
    'Instant food',
    'All food',
  ];
  final List<IconData> foodTypeIcons = [
    Icons.coffee_maker_outlined,
    Icons.free_breakfast_sharp,
    Icons.icecream_outlined,
    Icons.dry,
    Icons.food_bank_outlined,
    Icons.all_inbox_rounded,
  ];

  String selectedCategory = "All food";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        title: const Text('Inventory'),
        centerTitle: true,
        backgroundColor: AppTheme.greenMainTheme,
        titleTextStyle: FontsTheme.mouseMemoirs_64(color: Colors.white),
        leading: IconButton.filled(
          onPressed: () => context.go('/user_profile'),
          icon: const Icon(
            Icons.person_sharp,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: foodTypes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        String selectedFoodType =
                            foodTypes[index % foodTypes.length];
                        context.go('/inventory/$selectedFoodType');
                        // _updateSelectedCategory(
                        // foodTypes[index % foodTypes.length]);
                        // context.go('/dashboard');
                        // context.go(
                        // '/inventory/foodTypes[index % foodTypes.length]');
                        // context.go('/inventory/${foodTypes[index]}');
                        // extra: foodTypes[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: gridColors[index % gridColors.length],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                foodTypeIcons[index % foodTypeIcons.length],
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                foodTypes[index % foodTypes.length],
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    // context.go('/inventory');
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                  style: backButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
