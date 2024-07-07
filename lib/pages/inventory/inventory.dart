import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/inventory/inventory_list_item.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          // height: screenHeight * 0.2,
          width: screenWidth * 0.9,
          decoration: const BoxDecoration(
            color: AppTheme.mainBlue,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today 3 July 2024',
                        style: FontsTheme.mouseMemoir_30(
                            color: AppTheme.softGreen),
                      ),
                      Text(
                        'Things you should eat today:',
                        style: FontsTheme.hind_15(color: Colors.white),
                      ),
                      Text(
                        '- Tomatos expire tomorrow',
                        style: FontsTheme.hind_15(color: Colors.white),
                      ),
                      Text(
                        '- Lettuce expire in 2 days',
                        style: FontsTheme.hind_15(color: Colors.white),
                      ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    animation: true,
                    percent: 0.7,
                    center: const Text(
                      "70%",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: AppTheme.softOrange),
                    ),
                    footer: const Text(
                      "Another",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                          color: AppTheme.softOrange),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: AppTheme.softBrightGreen,
                    progressColor: AppTheme.softOrange,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Text(
                'Yogurt should be eaten before the next 3 days',
                style: FontsTheme.hind_15(color: Colors.white),
              ),
              Text(
                'Yogurt should be eaten before the next 3 days',
                style: FontsTheme.hind_15(color: Colors.white),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          width: screenWidth,
          // height: screenHeight,
          decoration: const BoxDecoration(
            color: AppTheme.mainBlue,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            //   topLeft: Radius.circular(30),
            //   topRight: Radius.circular(30),
            // ),
          ),
          child: const Column(
            children: [
              InventoryListItem(
                thumbnail: "assets/banana.jpg",
                foodname: 'Banana',
                expiry: '2 weeks',
                progressbar: 40,
                consuming: 5,
                remaining: 5,
              ),
              InventoryListItem(
                thumbnail: "assets/tomatoes.jpg",
                foodname: 'Tomatos',
                expiry: '3 days left',
                progressbar: 20.3,
                consuming: 5,
                remaining: 7,
              ),
              InventoryListItem(
                thumbnail: "assets/apples.jpg",
                foodname: 'Apple',
                expiry: '3 days left',
                progressbar: 60.57,
                consuming: 5,
                remaining: 7,
              ),
              InventoryListItem(
                thumbnail: "assets/banana.jpg",
                foodname: 'Banana',
                expiry: '2 weeks',
                progressbar: 40,
                consuming: 5,
                remaining: 5,
              ),
              InventoryListItem(
                thumbnail: "assets/tomatoes.jpg",
                foodname: 'Tomatos',
                expiry: '3 days left',
                progressbar: 20.3,
                consuming: 5,
                remaining: 7,
              ),
              InventoryListItem(
                thumbnail: "assets/apples.jpg",
                foodname: 'Apple',
                expiry: '3 days left',
                progressbar: 60.57,
                consuming: 5,
                remaining: 7,
              ),
            ],
          ),
        ),
      ])),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Consumed',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Inter',
            backgroundColor: AppTheme.greenMainTheme,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Household',
            backgroundColor: AppTheme.greenMainTheme,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.mainBlue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Adding food',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
