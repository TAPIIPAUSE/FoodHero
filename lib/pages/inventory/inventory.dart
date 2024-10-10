import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/addFoodDetails.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/inventory/circle_progressbar.dart';
import 'package:foodhero/widgets/inventory/inventory_dropdown.dart';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:foodhero/widgets/inventory/sort_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textwrap/textwrap.dart';

class Inventory extends StatefulWidget {
  final String initialFoodCategory;

  Inventory(
      {super.key, this.initialFoodCategory = 'all food'});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late int hID;

  int selectedRouteIndex = 0;
  late String foodCategory;
  final List<Segment> segments = [
    Segment(value: 26, color: AppTheme.greenMainTheme, label: "On Time"),
    Segment(value: 4, color: AppTheme.softOrange, label: "Nearly Expired"),
    Segment(value: 70, color: AppTheme.softRedCancleWasted, label: "Wasted"),
  ];
  late Future<List<InventoryListItem>> inventoryItems;
  late String _todayDate;
  late String _weekday;
  int _current = 0;
  int _weekdayIndex = 0;
  int touchedIndex = -1;

  void _onItemTapped(int index) {
    setState(() {
      selectedRouteIndex = index;
    });
  }

  // void _food() async {
  //   bool success = await food
  //  }
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final hID = prefs.getInt('hID');
      foodCategory = widget.initialFoodCategory;
      inventoryItems = fetchUserFood(hID!);
      this.hID = hID;
      _updateDate();
    });
    // final hID = prefs.getInt('hID');
    // foodCategory = widget.initialFoodCategory;
    // inventoryItems = fetchUserFood(hID!);
    // this.hID = hID;
    // _updateDate();
  }

  // Future<int> fetchHId() async {
  //   // Simulate network delay
  //   await Future.delayed(Duration(seconds: 1));
  //   return 123; // Replace with actual logic to get hID
  // }

  void _updateDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('EEEE d MMMM yyyy').format(now); // Full format
    _weekday = weekdays[now.weekday - 1]; // Adjust for index starting from 0
    _weekdayIndex = now.weekday - 1;
    log(_weekdayIndex);
  }

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> briefweekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  List<Map<String, dynamic>> members = [
    {"name": "You", "score": 24058},
    {"name": "Dad", "score": 24024},
    {"name": "Mom", "score": 18547},
    {"name": "Brother", "score": 17245},
  ];

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBar = PrimerCircularProgressBar(segments: segments);
    //final foodItems = Provider.of<FoodItemsProvider>(context).consumedItems;

    return MainScaffold(
      selectedRouteIndex: 0,
      child: Scaffold(
          backgroundColor: AppTheme.lightGreenBackground,
          appBar: AppBar(
            backgroundColor: AppTheme.greenMainTheme,
            toolbarHeight: 90,
            centerTitle: true,
            title: Text(
              "Inventory",
              style: FontsTheme.mouseMemoirs_64Black(),
            ),
            titleTextStyle: FontsTheme.mouseMemoirs_64White(),
            leading: IconButton(
              onPressed: () => context.push(''),
              icon: const Icon(
                Icons.person_sharp,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
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
                          Text('Today $_todayDate',
                              style: FontsTheme.mouseMemoirs_30White()
                                  .copyWith(color: Colors.white)),
                          Text(
                            'Things you should eat today:',
                            style: FontsTheme.hind_15()
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            '- Tomatos expire tomorrow',
                            style: FontsTheme.hind_15()
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            '- Lettuce expire in 2 days',
                            style: FontsTheme.hind_15()
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            '- Tomatos expire tomorrow',
                            style: FontsTheme.hind_15()
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            'Yogurt should be eaten before the next 3 days',
                            style: FontsTheme.hind_15()
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(child: progressBar),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        color: AppTheme.mainBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const InventoryDropdownMenu(),
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: AppTheme.softGreen,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.push('/category');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            foodCategory,
                                            style: FontsTheme.hind_15(),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                context.go('/category'),
                                            icon: const Icon(
                                                Icons.arrow_drop_down_rounded),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     IconButton(
                                    //       onPressed: () => context.go('/category'),
                                    //       icon: const Icon(Icons.swipe_down_alt),
                                    //     ),
                                    //     IconButton(
                                    //       onPressed: () => context.go('/inventory'),
                                    //       icon: const Icon(Icons.circle_outlined),
                                    //     ),
                                    //     IconButton(
                                    //         onPressed: () => context.go('/inventory'),
                                    //         icon: const Icon(Icons.swipe_up_alt)),
                                    //   ],
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder<List<InventoryListItem>>(
                              future: fetchUserFood(hID!),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return Center(
                                      child:
                                          Text('Loading...')); // Loading state
                                } else if (snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text(
                                          'No food items found for this house ID.'));
                                } else {
                                  List<InventoryListItem> foodItems =
                                      snapshot.data!;
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: foodItems.length,
                                          itemBuilder: (context, index) {
                                            final item = foodItems[index];
                                            double progress =
                                                (item.current_amount /
                                                        item.total_quanitity) *
                                                    100;
                                            int remaining = (item.total_amount -
                                                item.current_amount);
                                            return InventoryListItem(
                                                hID: item.hID,
                                                food_name: foodItems[index]
                                                    .food_name,
                                                img:
                                                    "assets/images/default.jpg", // You can update this based on your data

                                                location: foodItems[index]
                                                    .location,
                                                food_category: foodItems[index]
                                                    .food_category,
                                                isCountable: foodItems[index]
                                                    .isCountable,
                                                weight_type: foodItems[index]
                                                    .weight_type,
                                                package_type: foodItems[index]
                                                    .package_type,
                                                current_amount: foodItems[index]
                                                    .current_amount,
                                                total_amount: foodItems[index]
                                                    .total_amount,
                                                consumed_amount: foodItems[
                                                        index]
                                                    .consumed_amount,
                                                current_quantity:
                                                    foodItems[index]
                                                        .consumed_quantity,
                                                total_quanitity:
                                                    foodItems[index]
                                                        .total_quanitity,
                                                consumed_quantity:
                                                    foodItems[index]
                                                        .consumed_quantity,
                                                total_price: foodItems[index]
                                                    .total_price,
                                                RemindDate:
                                                    foodItems[index].RemindDate,
                                                bestByDate: foodItems[index]
                                                    .bestByDate, // Format as needed
                                                progressbar: progress,
                                                consuming: foodItems[index]
                                                    .current_amount,
                                                remaining: remaining);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                          const InventoryListItem(
                            hID: 1,
                            food_name: 'Banana',
                            img: "assets/images/banana.jpg",
                            location: "loacation",
                            food_category: foodTypeFresh,
                            isCountable: true,
                            weight_type: 'gram',
                            package_type: 'piece',
                            current_amount: 5,
                            total_amount: 7,
                            consumed_amount: 2,
                            current_quantity: 5,
                            total_quanitity: 7,
                            consumed_quantity: 2,
                            total_price: 50,
                            RemindDate: "5/10/2024",
                            bestByDate: '2 weeks',
                            progressbar: 40,
                            consuming: 5,
                            remaining: 5,
                          ),
                          const InventoryListItem(
                            hID: 1,
                            food_name: 'Apple',
                            img: "assets/images/apple.jpg",
                            location: "loacation",
                            food_category: foodTypeFresh,
                            isCountable: true,
                            weight_type: 'gram',
                            package_type: 'piece',
                            current_amount: 5,
                            total_amount: 7,
                            consumed_amount: 2,
                            current_quantity: 5,
                            total_quanitity: 7,
                            consumed_quantity: 2,
                            total_price: 50,
                            RemindDate: "5/10/2024",
                            bestByDate: '2 weeks',
                            progressbar: 40,
                            consuming: 5,
                            remaining: 5,
                          ),
                          // const InventoryListItem(
                          //    hID: 1,
                          //   img: "assets/images/apples.jpg",
                          //   food_name: 'Apple',
                          //   bestByDate: '3 days left',
                          //   progressbar: 60,
                          //   consuming: 5,
                          //   remaining: 7,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addFoodDetails(),
                            ),
                          );
                        },
                        shape: const CircleBorder(),
                        backgroundColor: AppTheme.greenMainTheme,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                      child: SpeedDial(
                        animatedIcon: AnimatedIcons.menu_close,
                        backgroundColor: AppTheme.greenMainTheme,
                        foregroundColor: Colors.white,
                        children: [
                          SpeedDialChild(
                              child: const Icon(Icons.search_rounded),
                              backgroundColor: AppTheme.greenMainTheme,
                              foregroundColor: Colors.white,
                              onTap: () {
                                context.push('/searchitem');
                              }),
                          SpeedDialChild(
                              child: const Icon(Icons.filter_alt_rounded),
                              backgroundColor: AppTheme.greenMainTheme,
                              foregroundColor: Colors.white,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Date added'),
                                              SortDropdownMenu(sortlist: [
                                                'Ascending',
                                                'Descending'
                                              ]),
                                            ],
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Expiration date'),
                                              SortDropdownMenu(sortlist: [
                                                'Ascending',
                                                'Descending'
                                              ]),
                                            ],
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Remaining'),
                                              SortDropdownMenu(sortlist: [
                                                'Ascending',
                                                'Descending'
                                              ]),
                                            ],
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Alphabet'),
                                              SortDropdownMenu(sortlist: [
                                                'Ascending',
                                                'Descending'
                                              ]),
                                            ],
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Quantity'),
                                              SortDropdownMenu(sortlist: [
                                                'Ascending',
                                                'Descending'
                                              ]),
                                            ],
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                context.push(
                                                    '/inventory/All food');
                                              },
                                              child: const Text("search")),
                                        ],
                                      ),
                                    );
                                  },
                                );
                                // context.go('');
                              }),
                          SpeedDialChild(
                              child: const Icon(Icons.history_rounded),
                              backgroundColor: AppTheme.greenMainTheme,
                              foregroundColor: Colors.white,
                              onTap: () {
                                print("history");
                              }),
                        ],
                        // onPressed: () {
                        //   // Add your onPressed code here!
                        // },
                        // child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )

          // bottomNavigationBar: BottomNavigationBar(
          //   items: const <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.inventory),
          //       label: 'Inventory',
          //       backgroundColor: AppTheme.greenMainTheme,
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.confirmation_number),
          //       label: 'Consumed',
          //       backgroundColor: AppTheme.greenMainTheme,
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.business),
          //       label: 'Inter',
          //       backgroundColor: AppTheme.greenMainTheme,
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.house),
          //       label: 'Household',
          //       backgroundColor: AppTheme.greenMainTheme,
          //     ),
          //   ],
          //   currentIndex: _selectedIndex,
          //   selectedItemColor: AppTheme.mainBlue,
          //   onTap: _onItemTapped,
          // ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => {},
          //   tooltip: 'Adding food',
          //   child: const Icon(Icons.add),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniCenterFloat,
          ),
    );
  }
}
