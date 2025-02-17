import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
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
  final List<String> foodTypes = foodCategory;
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
        toolbarHeight: 90,
        centerTitle: true,
        backgroundColor: AppTheme.greenMainTheme,
        titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
        leading: IconButton(
          onPressed: () => context.push('/user_profile'),
          icon: const Icon(
            Icons.person_sharp,
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
                        context.push('/inventory/$selectedFoodType');
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
                                style: FontsTheme.mouseMemoirs_40(),
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
                    context.push('/inventory/$selectedCategory');
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
