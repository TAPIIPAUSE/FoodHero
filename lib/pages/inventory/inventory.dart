import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/models/inventoryfood_model.dart';
import 'package:foodhero/pages/addFoodDetails.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/foodDetails.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/inventory/circle_progressbar.dart';
import 'package:foodhero/widgets/inventory/inventory_dropdown.dart';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:foodhero/widgets/inventory/sort_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inventory extends StatefulWidget {
  final String initialFoodCategory;

  const Inventory({super.key, this.initialFoodCategory = 'all food'});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late int hID;
  int selectedRouteIndex = 0;
  late String foodCategory;
  final ScrollController _InventoryScrollController = ScrollController();
  bool _isButtonVisible = false;
  late double someValue;
  final List<Segment> segments = [
    Segment(value: 26, color: AppTheme.greenMainTheme, label: "On Time"),
    Segment(value: 4, color: AppTheme.softOrange, label: "Nearly Expired"),
    Segment(value: 70, color: AppTheme.softRedCancleWasted, label: "Wasted"),
  ];
  // late Future<List<InventoryListItem>> inventoryItems;
  Future<InventoryFoodData?> _loadInventoryFood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hID = prefs.getInt('hID');
      print('hID from SharedPreferences: $hID'); // Debug print
      final data = await APIFood().getInventoryFood(hID!); //pervent null?
      print('Fetched inventory food data: $data'); // Debug print
      // print('Fetched data: ${data.map((item) => item.toString())}');
      return data;
    } catch (e) {
      print('Error loading inventory food: $e'); // Debug print
      rethrow;
    }
  }

  final dateFormatter = DateFormat('EEEE d MMMM yyyy');
  late final String _todayDate;

  // late String _weekday;
  // int _current = 0;
  // int _weekdayIndex = 0;
  // int touchedIndex = -1;

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
    _todayDate = dateFormatter.format(DateTime.now());
    foodCategory = widget.initialFoodCategory;
    // _loadInventoryFood();
    // SharedPreferences.getInstance().then((prefs) {
    // final hID = prefs.getInt('hID');
    // inventoryItems = fetchUserFood(hID!);
    // this.hID = hID;
    // _updateDate();
    // });
    // final hID = prefs.getInt('hID');
    // foodCategory = widget.initialFoodCategory;
    // inventoryItems = fetchUserFood(hID!);
    // this.hID = hID;
    // _updateDate();

    _InventoryScrollController.addListener(() {
      // Check if scrolled to the bottom
      if (_InventoryScrollController.position.pixels ==
          _InventoryScrollController.position.maxScrollExtent) {
        setState(() {
          _isButtonVisible = true; // Show button when at the bottom
        });
      } else {
        setState(() {
          _isButtonVisible = false; // Hide button otherwise
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe to use context here
    final mediaQuery = MediaQuery.of(context);
    someValue = mediaQuery.size.height; // Example usage
  }

  // Future<int> fetchHId() async {
  //   // Simulate network delay
  //   await Future.delayed(Duration(seconds: 1));
  //   return 123; // Replace with actual logic to get hID
  // }

  // void _updateDate() {
  //   final now = DateTime.now();
  //   _todayDate = DateFormat('EEEE d MMMM yyyy').format(now); // Full format
  //   _weekday = weekdays[now.weekday - 1]; // Adjust for index starting from 0
  //   _weekdayIndex = now.weekday - 1;
  //   log(_weekdayIndex);
  // }

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
  final ScrollController foodList = ScrollController();

  void _scrollToTop() {
    _InventoryScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
    foodList.animateTo(0,
        duration: const Duration(milliseconds: 1200), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBar = PrimerCircularProgressBar(segments: segments);
    //final foodItems = Provider.of<FoodItemsProvider>(context).consumedItems;

    return PopScope(
      canPop: false, // Disables system back gestures
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // Show confirmation dialog before allowing pop
          final bool? shouldPop = await _showBackDialog(context);
          if (shouldPop ?? false) {
            Navigator.of(context).pop(); // Allow pop if confirmed
          }
        }
      },
      child: MainScaffold(
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
                RawScrollbar(
                    //controller: _InventoryScrollController,
                    thumbColor: AppTheme.greenMainTheme,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            // height: screenHeight * 0.2,
                            width: screenWidth * 0.95,
                            decoration: const BoxDecoration(
                              color: AppTheme.mainBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Today $_todayDate',
                                    style: FontsTheme.mouseMemoirs_30White()
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 8, left: 8),
                            width: screenWidth,
                            decoration: const BoxDecoration(
                              color: AppTheme.mainBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            EdgeInsets.only(right: 8, left: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            InventoryDropdownMenu(),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5.0),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                color: AppTheme.softGreen,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  context.push('/category');
                                                },
                                                child: Container(
                                                  width: 130,
                                                  height: 30,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        foodCategory,
                                                        style: FontsTheme
                                                                .mouseMemoirs_20()
                                                            .copyWith(
                                                                letterSpacing:
                                                                    1),
                                                      ),
                                                      IconButton(
                                                        onPressed: () => context
                                                            .go('/category'),
                                                        icon: const Icon(Icons
                                                            .arrow_drop_down_circle_rounded),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder<InventoryFoodData?>(
                                    future: _loadInventoryFood(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme.softRed,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          controller: foodList,
                                          itemCount:
                                              snapshot.data!.foodItems.length,
                                          itemBuilder: (context, index) {
                                            final foodItem =
                                                snapshot.data!.foodItems[index];
                                            return GestureDetector(
                                                onTap: () async {
                                                  print(
                                                      'Navigating to food details for ID: ${foodItem.foodId}');
                                                  print('Food Item: $foodItem');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          foodDetails(
                                                        FoodID: foodItem.foodId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: InventoryListItem(
                                                  foodname: foodItem.foodName,
                                                  img: foodItem.url,
                                                  progressbar: 40,
                                                  consuming: foodItem.consuming,
                                                  remaining: foodItem.remaining,
                                                  foodid: foodItem.foodId,
                                                  expired: foodItem.expired,
                                                ));
                                          },
                                        );
                                      }
                                    }),
                                const SizedBox(
                                  height: 55,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )),
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
                        padding:
                            const EdgeInsets.only(right: 16.0, bottom: 16.0),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                }),
                            SpeedDialChild(
                                child: const Icon(Icons.history_rounded),
                                backgroundColor: AppTheme.greenMainTheme,
                                foregroundColor: Colors.white,
                                onTap: () {
                                  print("history");
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isButtonVisible)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: FloatingActionButton(
                      onPressed: _scrollToTop,
                      child: Icon(Icons.arrow_upward),
                      backgroundColor: AppTheme.greenMainTheme,
                    ),
                  ),
              ],
            )),
      ),
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit'),
          content: Text('Do you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay on page
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login_regis()),
              ), // Allow exit
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _InventoryScrollController.dispose();
    super.dispose();
  }
}
