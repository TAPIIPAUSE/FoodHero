import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/models/inventoryfood_model.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/foodDetails.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:foodhero/widgets/inventory/select_category.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchItem extends StatefulWidget {
  const SearchItem({super.key});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late String fooditem;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _InventoryScrollController = ScrollController();
  bool _isButtonVisible = false;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _searchController.dispose();
    _InventoryScrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _InventoryScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
    foodList.animateTo(0,
        duration: const Duration(milliseconds: 1200), curve: Curves.easeOut);
  }

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

  Widget buildFoodItem() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Search Food',
        hintText: 'Enter your food name',
        labelStyle: FontsTheme.hindBold_15(),
        hintStyle: FontsTheme.hind_15(),
      ),
      // validator: (String? value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please enter your food item';
      //   }
      //   return null;
      // },
      // onSaved: (String? value) {
      //   fooditem = value ?? '';
      // },
      onChanged: (value) {
        setState(() {
          _searchQuery = value.toLowerCase(); // Update the search query
        });
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

  final ScrollController foodList = ScrollController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.mainBlue,
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          "Inventory",
          style: FontsTheme.mouseMemoirs_64Black(),
        ),
        backgroundColor: AppTheme.greenMainTheme,
      ),
      body: Stack(
        children: [
          RawScrollbar(
            thumbColor: AppTheme.greenMainTheme,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppTheme.lightGreenBackground,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                icon:
                                    const Icon(Icons.arrow_forward_ios_rounded),
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
                                    icon: const Icon(
                                        Icons.calendar_today_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            // onPressed: () {
                            //   if (!formKey.currentState!.validate()) {
                            //     return;
                            //   }
                            //   formKey.currentState?.save();
                            //   print(fooditem);

                            //   context.push('/inventory/All food');
                            // },
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              formKey.currentState?.save();
                              print(fooditem);

                              context.push('/inventory/All food');
                            },
                            // style: buttonStyle,
                            child: const Text("search"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
                    width: screenWidth,
                    decoration: const BoxDecoration(
                      color: AppTheme.mainBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        // Padding(
                        //     padding: EdgeInsets.only(right: 8, left: 8),
                        //     child: Row(
                        //       mainAxisAlignment:
                        //           MainAxisAlignment.spaceBetween,
                        //       children: <Widget>[
                        //         //Location
                        //         InventoryDropdownMenu(),
                        //         //Category
                        //         Container(
                        //           margin:
                        //               const EdgeInsets.only(left: 5.0),
                        //           padding: const EdgeInsets.all(5.0),
                        //           decoration: BoxDecoration(
                        //             color: AppTheme.softGreen,
                        //             borderRadius:
                        //                 BorderRadius.circular(10.0),
                        //           ),
                        //           child: GestureDetector(
                        //             onTap: () {
                        //               context.push('/category');
                        //             },
                        //             child: Container(
                        //               width: 130,
                        //               height: 30,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.center,
                        //                 children: [
                        //                   Text(
                        //                     foodCategory,
                        //                     style: FontsTheme
                        //                             .mouseMemoirs_20()
                        //                         .copyWith(
                        //                             letterSpacing: 1),
                        //                   ),
                        //                   IconButton(
                        //                     onPressed: () =>
                        //                         context.go('/category'),
                        //                     icon: const Icon(Icons
                        //                         .arrow_drop_down_circle_rounded),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //           // Row(
                        //           //   children: [
                        //           //     IconButton(
                        //           //       onPressed: () => context.go('/category'),
                        //           //       icon: const Icon(Icons.swipe_down_alt),
                        //           //     ),
                        //           //     IconButton(
                        //           //       onPressed: () => context.go('/inventory'),
                        //           //       icon: const Icon(Icons.circle_outlined),
                        //           //     ),
                        //           //     IconButton(
                        //           //         onPressed: () => context.go('/inventory'),
                        //           //         icon: const Icon(Icons.swipe_up_alt)),
                        //           //   ],
                        //           // )
                        //         ),
                        //       ],
                        //     )),
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
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                // Filter food items where remaining is not "0" and matches the search query
                                List<Food> filteredFoodItems =
                                    snapshot.data!.foodItems.where((foodItem) {
                                  return !foodItem.remaining.startsWith("0 ") &&
                                      //Search
                                      foodItem.foodName
                                          .toLowerCase()
                                          .contains(_searchQuery);
                                }).toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  controller: foodList,
                                  itemCount: filteredFoodItems.length,
                                  itemBuilder: (context, index) {
                                    final foodItem = filteredFoodItems[index];

                                    return GestureDetector(
                                        onTap: () async {
                                          //FoodDetailData foodDetail = await getFoodDetail(fID);
                                          print(
                                              'Navigating to food details for ID: ${foodItem.foodId}');
                                          print('Food Item: $foodItem');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => foodDetails(
                                                FoodID: foodItem.foodId,
                                              ),
                                            ),
                                          );
                                        },
                                        child: InventoryListItem(
                                          foodname: foodItem
                                              .foodName, // Use 'foodName' from model
                                          img: foodItem
                                              .url, // Use 'url' from model
                                          progressbar:
                                              40, // Static or calculated value
                                          consuming: foodItem
                                              .consuming, // Use 'consuming' from model
                                          remaining: foodItem
                                              .remaining, // Use 'remaining' from model
                                          foodid: foodItem
                                              .foodId, // Use 'foodId' from model
                                          expired: foodItem
                                              .expired, // Use 'expired' from model
                                          // location: foodItem.location,
                                          // category: foodItem.category,
                                          // Uncomment and use additional properties if needed
                                          // remind: foodItem.remind,
                                          // isCountable: foodItem.isCountable,
                                          // TotalCost: foodItem.TotalCost,
                                          // IndividualWeight: foodItem.IndividualWeight,
                                          // IndividualCost: foodItem.IndividualCost,
                                        ));
                                  },
                                );
                              }
                            }),
                        // InventoryListItem(
                        //   foodname: "Try food",
                        //   img: "ssss",
                        //   // location: "Pantry try",
                        //   expired: DateTime(2024, 0012, 30),
                        //   // remind: "2024-11-24",
                        //   progressbar: 40,
                        //   consuming: "2",
                        //   // remaining: 3,
                        //   foodid: 10, remaining: '5 pieces',
                        //   //expired: "2024-12-31",
                        //   // isCountable: true,
                        //   // TotalCost: 50,
                        //   // IndividualWeight: 100,
                        //   // IndividualCost: 10,
                        // ),
                        const SizedBox(
                          height: 55,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: Image.asset('assets/images/BackButton.png'),
              iconSize: 50,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Inventory(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
