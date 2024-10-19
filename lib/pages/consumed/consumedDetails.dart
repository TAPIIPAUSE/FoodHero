// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/models/idconsumedfood_model.dart';
import 'package:foodhero/pages/api/consumedfood_api.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumedDetails extends StatefulWidget {
  final bool isCountable;
  const ConsumedDetails({
    super.key,
    required this.cID,
    required this.isCountable,
  });
  final int cID;

  //  final InventoryListItem item;
  // ConsumedDetails({required this.item});

  @override
  _ConsumedDetailsState createState() => _ConsumedDetailsState();
}

class _ConsumedDetailsState extends State<ConsumedDetails> {
  int quantity = 1;
  double weight = 1; // in grams
  String weightReduced = ''; //make it proper for the decimals
  final TextEditingController foodname = TextEditingController();
  int consumeQuantity = 0;
  late bool isCountable;

  Future<List<IdconsumedfoodModel>> _loadConsumedFoodByID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hID = prefs.getInt('hID');
      // final cID = prefs.getInt('consume_ID');
      final cID = widget.cID;
      final isCountable = widget.isCountable;
      // if (hID == null) {
      //   throw Exception('hID not found in SharedPreferences');
      // }
      print('hID from SharedPreferences: $hID'); // Debug print
      print('cID from SharedPreferences: $cID'); // Debug print
      print('isCountable: $isCountable');
      final data = await ConsumedFood().getConsumedfoodById(cID);
      print('Fetched consumed food data by ID: $data'); // Debug print
      // print('Fetched data: ${data.map((item) => item.toString())}');
      return data;
    } catch (e) {
      print('Error loading consumed food by ID: $e'); // Debug print
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadConsumedFoodByID();
    isCountable = widget.isCountable as bool;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    foodname.dispose();
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
            body: FutureBuilder<List<IdconsumedfoodModel>>(
                future: _loadConsumedFoodByID(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No consumed food data available'),
                    );
                  } else {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        "foodname",
                                        style:
                                            FontsTheme.mouseMemoirs_50Black(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                //buildDropdownField('Categories', "value", Icons.local_dining),
                                buildCategoriesField("Categories", "value",
                                    Icons.arrow_drop_down),
                                buildWhereField('In', 'value', Icons.kitchen),
                                buildQuantityWeight(),

                                buildConsumed(),
                                buildWasted(),
                                //buildCostField(),
                                SizedBox(height: 16),
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
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Delete item',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
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
                          ],
                        ),
                      ),
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
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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

  bool isVisible = true;
  Widget buildQuantityWeight() {
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
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isVisible,
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
                                width: 200,
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
                                    Text('$quantity ',
                                        style: FontsTheme.hindBold_20()),
                                    buildQuantityUnit('')
                                  ],
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 10.0,
                                  thumbShape: SliderComponentShape.noThumb,
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 24.0),
                                  activeTrackColor: Colors.orange,
                                  inactiveTrackColor: Colors.orange[100],
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.orange.withAlpha(32),
                                ),
                                child: Slider(
                                  value: quantity.toDouble(),
                                  min: 1,
                                  max: 100,
                                  divisions: 100,
                                  onChanged: (value) {
                                    setState(() {
                                      quantity = value.toInt();
                                      //_updateAllCost();
                                      consumeQuantity = quantity;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Weight
                    Row(
                      children: [
                        Text('Weight',
                            style: FontsTheme.mouseMemoirs_30Black()),
                        SizedBox(
                          width: 55,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 200,
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
                                  Text('$weightReduced ',
                                      style: FontsTheme.hindBold_20()),
                                  buildWeightUnit('')
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 24.0),
                                activeTrackColor: Colors.orange,
                                inactiveTrackColor: Colors.orange[100],
                                thumbColor: Colors.white,
                                overlayColor: Colors.orange.withAlpha(32),
                              ),
                              child: Slider(
                                value: weight,
                                min: 1,
                                max: 10000,
                                divisions: 10000,
                                onChanged: (value) {
                                  setState(() {
                                    weight = value;

                                    weightReduced = weight.toStringAsFixed(0);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          isExpanded: true,
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: FontsTheme.hindBold_20(),
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          isExpanded: true,
                          items: items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: FontsTheme.hindBold_20(),
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

  Widget buildConsumed() {
    String Piece = "Piece";
    if (quantity == 1) {
      Piece = "Piece";
    } else if (quantity > 1) {
      Piece = "Pieces";
    }
    String Gram = "Gram";
    if (weight == 1) {
      Gram = "Gram";
    } else if (weight > 1) {
      Gram = "Grams";
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
                    Row(
                      children: [
                        Text('Consumed',
                            style: FontsTheme.mouseMemoirs_30Black()),
                        Column(
                          children: [
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$quantity ',
                                      style: FontsTheme.hindBold_20()),
                                  Text(Piece, style: FontsTheme.hindBold_20()),
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 24.0),
                                activeTrackColor: Colors.orange,
                                inactiveTrackColor: Colors.orange[100],
                                thumbColor: Colors.white,
                                overlayColor: Colors.orange.withAlpha(32),
                              ),
                              child: Slider(
                                value: quantity.toDouble(),
                                min: 1,
                                max: 100,
                                divisions: 100,
                                onChanged: (value) {
                                  setState(() {
                                    quantity = value.toInt();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

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

  Widget buildWasted() {
    String Piece = "Piece";
    if (quantity == 1) {
      Piece = "Piece";
    } else if (quantity > 1) {
      Piece = "Pieces";
    }
    String Gram = "Gram";
    if (weight == 1) {
      Gram = "Gram";
    } else if (weight > 1) {
      Gram = "Grams";
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
                    Row(
                      children: [
                        Text('Waste', style: FontsTheme.mouseMemoirs_30Black()),
                        Column(
                          children: [
                            Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$quantity ',
                                      style: FontsTheme.hindBold_20()),
                                  Text(Piece, style: FontsTheme.hindBold_20()),
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 10.0,
                                thumbShape: SliderComponentShape.noThumb,
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 24.0),
                                activeTrackColor: Colors.orange,
                                inactiveTrackColor: Colors.orange[100],
                                thumbColor: Colors.white,
                                overlayColor: Colors.orange.withAlpha(32),
                              ),
                              child: Slider(
                                value: quantity.toDouble(),
                                min: 1,
                                max: 100,
                                divisions: 100,
                                onChanged: (value) {
                                  setState(() {
                                    quantity = value.toInt();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

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
