import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/theme.dart';

class ConsumedDetails extends StatefulWidget {
  @override
  _ConsumedDetailsState createState() => _ConsumedDetailsState();
}

class _ConsumedDetailsState extends State<ConsumedDetails> {
  int quantity = 1;
  double weight = 1; // in grams
  String weightReduced = ''; //make it proper for the decimals
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
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Stack(
            children: [
              Positioned(
                // Item history
                top: 20,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    // Handle the tap event here
                    print('Container tapped');
                  },
                  child: Container(
                    width: 60,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppTheme.greenMainTheme,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(27),
                          bottomLeft: Radius.circular(27),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Container(
                      alignment: const Alignment(-8, 0),
                      child: Image.asset('assets/images/TimeMachine.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          style: FontsTheme.mouseMemoirs_50Black(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  //buildDropdownField('Categories', "value", Icons.local_dining),
                  buildCategoriesField(
                      "Categories", "value", Icons.arrow_drop_down),
                  buildWhereField('In', 'value', Icons.kitchen),

                  buildQuantity(),
                  buildConsumed(),
                  buildWasted(),
                  //buildCostField(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _consumeOption(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF4A261),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
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
                      icon: Image.asset('assets/images/BackButton.png'),
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
      ),
    );

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

  Widget buildQuantity() {
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.softBlue,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Quantity',
                            style: FontsTheme.mouseMemoirs_30Black()),
                        Column(
                          children: [
                            Container(
                              width: 120,
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
                                  Text(Piece, style: FontsTheme.hindBold_20()),
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
                padding: EdgeInsets.all(8),
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
                                  Text(Piece, style: FontsTheme.hindBold_20()),
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
                padding: EdgeInsets.all(8),
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
                                  Text(Piece, style: FontsTheme.hindBold_20()),
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
            offset: Offset(0, 0),
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
                        padding: EdgeInsets.all(10),
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
                              fixedSize: Size(350, 50),
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
                        margin: EdgeInsets.all(10),
                        foregroundDecoration: BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF4A261),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Complete Consume',
                    style: FontsTheme.mouseMemoirs_30Black()
                        .copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE76F51),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Cancle',
                    style: FontsTheme.hind_20().copyWith(color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}
