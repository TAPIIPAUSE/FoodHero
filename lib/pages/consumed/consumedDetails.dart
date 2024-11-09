// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/models/idconsumedfood_model.dart';
import 'package:foodhero/pages/api/consumedfood_api.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/theme.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumedDetails extends StatefulWidget {
  final int cID;
  final int FoodID;
  // final String foodname;
  //final bool isCountable;
  const ConsumedDetails({
    //required this.foodname,
    required this.FoodID,
    required this.cID,
    //required this.isCountable,
  });

  //  final InventoryListItem item;
  // ConsumedDetails({required this.item});

  @override
  _ConsumedDetailsState createState() => _ConsumedDetailsState();
}

class _ConsumedDetailsState extends State<ConsumedDetails> {
  late Future<IdconsumedfoodModel?> _consumedFoodFuture;
  int quantity = 1;
  double weight = 1; // in grams
  String weightReduced = ''; //make it proper for the decimals
  int consume = 1;
  int waste = 1;
  //late final
  String foodname = '';
  FileImage? _image;
  int consumeQuantity = 0;
  //late
  bool isCountable = true;

  String location = '';
  int showQuantity = 0;
  String showPackage = '';
  double weightUncountable = 0;
  String showUnit = '';

  double showNumofConsume = 0;
  double showConsumePercent = 0;
  double calculatedNumofConsume = 0;
  String showConsumePackage = '';
  String showConsumeUnit = '';
  String showPackageOrUnit = '';

  Future<IdconsumedfoodModel?> _loadConsumedFoodByID() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final cID = prefs.getInt('consume_ID');
      //final foodname = widget.foodname;
      // final cID = widget.cID;
      //final isCountable = widget.isCountable;
      // if (hID == null) {
      //   throw Exception('hID not found in SharedPreferences');
      // }
      print('foodname from SharedPreferences: $foodname'); // Debug print

      // print('Consume_ID from SharedPreferences: $cID'); // Debug print
      print('isCountable: $isCountable');
      print('Loading Consumed food details for ID: ${widget.cID}');

      final data = await ConsumedFood().getConsumedfoodById(widget.cID);

      if (widget.cID == null) {
        print('widget.cID is null');
        return null; // or handle accordingly
      }
      print('Fetched consumed food data by ID: $data'); // Debug print
      // print('Fetched data: ${data.map((item) => item.toString())}');
      print(data);
      if (data != null) {
        print(
            'Successfully loaded Consumed food details: ${data.foodName}'); // Debug log
        return data;
      } else {
        print('No Consumed food details found'); // Debug log
        return null;
      }
    } catch (e) {
      print('Error loading consumed food by ID: $e'); // Debug print
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _consumedFoodFuture = _loadConsumedFoodByID();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //MainScaffold(
        //   selectedRouteIndex: 1,
        //   child:
        Scaffold(
            backgroundColor: AppTheme.lightGreenBackground,
            appBar: AppBar(
              backgroundColor: AppTheme.greenMainTheme,
              toolbarHeight: 90,
              centerTitle: true,
              title: Text(
                "Consumed",
                style: FontsTheme.mouseMemoirs_64Black(),
              ),
              leading: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
            body: FutureBuilder<IdconsumedfoodModel?>(
                future: _consumedFoodFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Text('No consumed food data available'),
                    );
                  } else {
                    final consumedFoodDetail = snapshot.data!;

                    foodname = consumedFoodDetail.foodName;
                    isCountable = consumedFoodDetail.isCountable;
                    showQuantity = consumedFoodDetail.quantityCountable;
                    showPackage = consumedFoodDetail.packageType;
                    weightUncountable = consumedFoodDetail.weightUncountable;
                    showUnit = consumedFoodDetail.unit;

                    //Consumed Field
                    showConsumePackage = consumedFoodDetail.packageType;
                    showConsumeUnit = consumedFoodDetail.unit;

                    return Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 2000,
                            child: Center(
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            foodname,
                                            style: FontsTheme
                                                .mouseMemoirs_50Black(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),

                                      // SizedBox(height: 16),
                                      // //buildDropdownField('Categories', "value", Icons.local_dining),
                                      //buildCategoriesField("Categories",
                                      //    "value", Icons.arrow_drop_down),
                                      //buildWhereField(
                                      //   'In', 'value', Icons.kitchen),
                                      buildQuantityWeight(),
                                      buildConsumed(),
                                      // buildWasted(),
                                      buildCostField(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            color: AppTheme.lightGreenBackground,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _consumeOption(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFF4A261),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: Text(
                                        'Confirm',
                                        style: FontsTheme.mouseMemoirs_30Black()
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                // Center(
                                //   child: TextButton(
                                //     onPressed: () {},
                                //     child: Text(
                                //       'Delete item',
                                //       style: TextStyle(color: Colors.black),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: 5),
                                Center(
                                  child: IconButton(
                                    icon: Image.asset(
                                        'assets/images/BackButton.png'),
                                    iconSize: 50,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Consumed(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }));

    //);
  }

  Widget buildCategoriesField(String label, String value, IconData icon) {
    List<String> items = [
      "Cooked food",
      "Fresh food",
      "Frozen food",
      "Dried food",
      "Instant food"
    ];
    String selectedValue = items[0];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            child: Text(
                              label,
                              style: FontsTheme.mouseMemoirs_30Black(),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 215,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          isExpanded: true,
                          icon: Icon(icon),
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: FontsTheme.mouseMemoirs_30Black(),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedValue = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget buildWhereField(String label, String value, IconData icon) {
    List<String> items = [
      "Refrigerator",
      "Pantry",
    ];
    String selectedValue = items[0];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  label,
                                  style: FontsTheme.mouseMemoirs_30Black(),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 215,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: AppTheme.mainBlue,
                                    width: 2.0), // Set border color and width
                              ),
                              child: Text(
                                location,
                                style: FontsTheme.mouseMemoirs_30Black(),
                              )

                              // child: DropdownButtonHideUnderline(
                              //   child: DropdownButton<String>(
                              //     value: selectedValue,
                              //     isExpanded: true,
                              //     icon: Icon(icon),
                              //     items: items.map((String item) {
                              //       return DropdownMenuItem<String>(
                              //         value: item,
                              //         child: Text(
                              //           item,
                              //           style: FontsTheme.mouseMemoirs_30Black(),
                              //         ),
                              //       );
                              //     }).toList(),
                              //     onChanged: (String? newValue) {
                              //       if (newValue != null) {
                              //         setState(() {
                              //           selectedValue = newValue;
                              //         });
                              //       }
                              //     },
                              //   ),
                              //
                              ),
                        )
                      ],
                    )),
              ],
            )
          ],
        ),
      );
    });
  }

  String _getQuantityPackage(double showQuantity, String package) {
    if (showQuantity == 0 || showQuantity <= 1.99) {
      return package; // Singular form
    } else {
      // Pluralize based on the unit
      switch (package) {
        case 'Piece':
          return 'Pieces';
        case 'Box':
          return 'Boxes';
        case 'Bottle':
          return 'Bottles';
        default:
          return package; // Fallback to original unit if no match
      }
    }
  }

  String _getWeightUnit(double weightUncountable, String unit) {
    if (weightUncountable == 0 || weightUncountable <= 1) {
      return unit; // Singular form
    } else {
      // Pluralize based on the unit
      switch (unit) {
        case 'Gram':
          return 'Grams';
        case 'Kilogram':
          return 'Kilograms';
        case 'Milliliter':
          return 'Milliliters';
        case 'Litre':
          return 'Litres';
        default:
          return unit; // Fallback to original unit if no match
      }
    }
  }

  bool showQuantityField = true;
  Widget buildQuantityWeight() {
    showQuantityField = isCountable;
    showPackage = _getQuantityPackage(showQuantity.toDouble(), showPackage);
    showUnit = _getWeightUnit(weightUncountable, showUnit);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //buildQuantityButton(Icons.remove),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.softBlue,
                ),
                child: Column(
                  children: [
                    Visibility(
                      visible: isCountable,
                      child: Row(
                        children: [
                          Text('Quantity',
                              style: FontsTheme.mouseMemoirs_30Black()),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 180,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(showQuantity.toString(),
                                        style: FontsTheme.hindBold_20()),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      showPackage,
                                      style: FontsTheme.hindBold_20(),
                                    )
                                    //buildQuantityUnit('')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Weight
                    Visibility(
                      visible: !isCountable,
                      child: Row(
                        children: [
                          Text('Weight',
                              style: FontsTheme.mouseMemoirs_30Black()),
                          SizedBox(
                            width: 55,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 180,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(weightUncountable.toString(),
                                        style: FontsTheme.hindBold_20()),
                                    Text(showUnit.toString(),
                                        style: FontsTheme.hindBold_20()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildQuantityUnit(String value) {
    String pieceLabel = quantity == 1 ? "Piece" : "Pieces";
    String boxLabel = quantity == 1 ? "Box" : "Boxes";
    String bottleLabel = quantity == 1 ? "Bottle" : "Bottles";
    List<String> items = [pieceLabel, boxLabel, bottleLabel];
    String selectedValue = items[0];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: Text(
                        'Piece',
                        style: FontsTheme.hindBold_20(),
                      ),
                      // child: DropdownButtonHideUnderline(
                      //   child: DropdownButton<String>(
                      //     value: selectedValue,
                      //     isExpanded: true,
                      //     items: items.map((String item) {
                      //       return DropdownMenuItem<String>(
                      //         value: item,
                      //         child: Text(
                      //           item,
                      //           style: FontsTheme.hindBold_20(),
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       if (newValue != null) {
                      //         setState(() {
                      //           selectedValue = newValue;
                      //         });
                      //       }
                      //     },
                      //   ),
                      // ),
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget buildWeightUnit(String value) {
    String Gram = "Gram";
    if (weight == 1) {
      Gram = "Gram";
    } else if (weight > 1) {
      Gram = "Grams";
    }
    List<String> items = [Gram];
    String selectedValue = items[0];
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: Text(
                        'gram',
                        style: FontsTheme.hindBold_20(),
                      ),
                      // child: DropdownButtonHideUnderline(
                      //   child: DropdownButton<String>(
                      //     value: selectedValue,
                      //     isExpanded: true,
                      //     items: items.map((String item) {
                      //       return DropdownMenuItem<String>(
                      //         value: item,
                      //         child: Text(
                      //           item,
                      //           style: FontsTheme.hindBold_20(),
                      //         ),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       if (newValue != null) {
                      //         setState(() {
                      //           selectedValue = newValue;
                      //         });
                      //       }
                      //     },
                      //   ),
                      // ),
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget buildConsumed() {
    if (isCountable == true) {
      showNumofConsume = showQuantity.toDouble();
    } else {
      showNumofConsume = weightUncountable;
    }
    calculatedNumofConsume = (showConsumePercent / 100) * showNumofConsume;
    showConsumePackage = _getQuantityPackage(
        calculatedNumofConsume.toDouble(), showConsumePackage);
    showConsumeUnit = _getWeightUnit(calculatedNumofConsume, showConsumeUnit);

    if (isCountable == true) {
      showPackageOrUnit = showConsumePackage;
    } else {
      showPackageOrUnit = showConsumeUnit;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //buildQuantityButton(Icons.remove),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.softBlue,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Consumed',
                        style: FontsTheme.mouseMemoirs_30Black(),
                      ),
                    ),

                    Column(
                      children: [
                        Text(
                          "${showConsumePercent.toStringAsFixed(0)}%",
                          style: FontsTheme.mouseMemoirs_30Black(),
                        ),
                        SizedBox(
                          child: InteractiveSlider(
                            focusedHeight: 20,
                            backgroundColor: AppTheme.softRed,
                            startIcon: const Icon(
                              Icons.remove_circle_rounded,
                              color: Colors.black,
                            ),
                            endIcon: const Icon(
                              Icons.add_circle_rounded,
                              color: Colors.black,
                            ),
                            min: 1,
                            max: 100,
                            onChanged: (percent) => setState(() {
                              showConsumePercent = percent;
                              // _updateAllCost();
                              // consumeQuantity = quantity;
                              // updateQuantityfromSlider();
                            }),
                          ),
                        ),
                        Container(
                          width: 150,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.softRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                calculatedNumofConsume.toStringAsFixed(0),
                                style: FontsTheme.hindBold_20(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                showPackageOrUnit,
                                style: FontsTheme.hindBold_20(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )

                    //Weight
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCostField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //buildQuantityButton(Icons.remove),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.softBlue,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Saved : ',
                            style: FontsTheme.mouseMemoirs_30Black(),
                          ),
                        ),
                        Text(
                          '+1000 ',
                          style: FontsTheme.hindBold_20(),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Lost : ',
                            style: FontsTheme.mouseMemoirs_30Black(),
                          ),
                        ),
                        Text(
                          '+50 ',
                          style: FontsTheme.hindBold_20(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _consumeOption(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext contetxt) {
          return Transform.translate(
            offset: const Offset(0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 375,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.softRed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: AppTheme.softRed,
                              fixedSize: const Size(350, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Consume',
                                  style: FontsTheme.mouseMemoirs_30Black()
                                      .copyWith(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        height: 120,
                        width: 355,
                        margin: const EdgeInsets.all(10),
                        foregroundDecoration: BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A261),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Complete Consume',
                    style: FontsTheme.mouseMemoirs_30Black()
                        .copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Cancle',
                    style: FontsTheme.hind_20().copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
