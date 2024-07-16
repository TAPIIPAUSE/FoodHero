import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/circle_progressbar.dart';
import 'package:foodhero/widgets/inventory_dropdown.dart';
import 'package:foodhero/widgets/inventory_list_item.dart';
import 'package:foodhero/widgets/sort_dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:textwrap/textwrap.dart';

class Inventory extends StatefulWidget {
  final String initialFoodCategory;
  const Inventory({super.key, this.initialFoodCategory = 'all food'});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int _selectedIndex = 0;
  late String foodCategory;
  final List<Segment> segments = [
    Segment(value: 26, color: AppTheme.greenMainTheme, label: "On Time"),
    Segment(value: 4, color: AppTheme.softOrange, label: "Nearly Expired"),
    Segment(value: 70, color: AppTheme.softRedCancleWasted, label: "Wasted"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    foodCategory = widget.initialFoodCategory;
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final progressBar = PrimerCircularProgressBar(segments: segments);

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
        actions: [
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  Text(
                    'Today 3 July 2024',
                    style: FontsTheme.mouseMemoir_30(color: AppTheme.softGreen),
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
                  Text(
                    '- Tomatos expire tomorrow',
                    style: FontsTheme.hind_15(color: Colors.white),
                  ),
                  Text(
                    fill(
                        '- Lettuce expire in 2 days gkgkglh;hlg;g;glhlg;ghh;g;gk',
                        width: 50),
                    style: FontsTheme.hind_15(color: Colors.white),
                  ),
                  Text(
                    'Yogurt should be eaten before the next 3 days',
                    style: FontsTheme.hind_15(color: Colors.white),
                  ),
                  Text(
                    'Yogurt should be eaten before the next 3 days',
                    style: FontsTheme.hind_15(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(child: progressBar),
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
                                context.go('/category');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    foodCategory,
                                    style: FontsTheme.hind_15(),
                                  ),
                                  IconButton(
                                    onPressed: () => context.go('/category'),
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
                  const InventoryListItem(
                    thumbnail: "assets/banana.jpg",
                    foodname: 'Banana',
                    expiry: '2 weeks',
                    progressbar: 40,
                    consuming: 5,
                    remaining: 5,
                  ),
                  const InventoryListItem(
                    thumbnail: "assets/tomatoes.jpg",
                    foodname: 'Tomatos',
                    expiry: '3 days left',
                    progressbar: 20.3,
                    consuming: 5,
                    remaining: 7,
                  ),
                  const InventoryListItem(
                    thumbnail: "assets/apples.jpg",
                    foodname: 'Apple',
                    expiry: '3 days left',
                    progressbar: 60.57,
                    consuming: 5,
                    remaining: 7,
                  ),
                  const InventoryListItem(
                    thumbnail: "assets/banana.jpg",
                    foodname: 'Banana',
                    expiry: '2 weeks',
                    progressbar: 40,
                    consuming: 5,
                    remaining: 5,
                  ),
                  const InventoryListItem(
                    thumbnail: "assets/tomatoes.jpg",
                    foodname: 'Tomatos',
                    expiry: '3 days left',
                    progressbar: 20.3,
                    consuming: 5,
                    remaining: 7,
                  ),
                  const InventoryListItem(
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
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              shape: const CircleBorder(),
              backgroundColor: AppTheme.greenMainTheme,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
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
                        context.go('/searchitem');
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
                                        context.go('/inventory/All food');
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   tooltip: 'Adding food',
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
