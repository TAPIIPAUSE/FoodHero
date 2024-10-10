import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:image_picker/image_picker.dart';

class addFoodDetails extends StatefulWidget {
  @override
  _AddFoodDetailsPageState createState() => _AddFoodDetailsPageState();
}

class _AddFoodDetailsPageState extends State<addFoodDetails> {
  String itemName = 'Banana';
  String category = 'Fresh Food';
  String storageLocation = 'Refrigerator';
  DateTime expirationDate = DateTime(2024, 4, 24);
  int quantity = 1;
  double weight = 1; // in grams
  double costPerPiece = 0;
  double totalCost = 160;

  ImageProvider? _image; // Image provider for the selected image
  bool _isLoading = false; // Flag to indicate image loading state
  bool _chooseImageOption = false;
  bool _showImageOption = false;
  DateTime reminderDate = DateTime(2024);

  String weightReduced = ''; //make it proper for the decimals
  double allCost = 0;
  double updateAllCost = 0;
  void _pickImage() async {
    // Implement your image picking logic here (e.g., using image_picker)
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      final image = FileImage(File(pickedFile.path));
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate image loading delay
      setState(() {
        _image = image;
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _toggleImageOption() {
    setState(() {
      _showImageOption = !_showImageOption;
    });
  }

  void _chooseAddImageOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Transform.translate(
          offset: Offset(10, 10), // Adjust the offset to change the position
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              margin:
                  const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
              width: 340,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.mainBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Image.asset('assets/images/Photo.png'),
                        Text(
                          'Take\nPhoto',
                          style: FontsTheme.hindBold_20(),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.softBlue,
                      fixedSize: Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between buttons
                  TextButton(
                    onPressed: _pickImage,
                    child: Column(
                      children: [
                        Image.asset('assets/images/Photo.png'),
                        Text(
                          'Choose\nPhoto',
                          style: FontsTheme.hindBold_20(),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.softBlue,
                      fixedSize: Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Add spacing between buttons
                  TextButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Image.asset('assets/images/Photo.png'),
                        Text(
                          'Choose\nFile',
                          style: FontsTheme.hindBold_20(),
                        ),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.softBlue,
                      fixedSize: Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.greenMainTheme,
        toolbarHeight: 90,
        centerTitle: true,
        title: Text('Inventory'),
        titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.arrow_upward_rounded,
              size: 50,
            ),
            Row(
              children: [
                GestureDetector(
                  //add photo
                  onTap: () => _chooseAddImageOption(context),
                  child: Container(
                    width: 100,
                    height: 68,
                    decoration: BoxDecoration(
                      color: AppTheme.mainBlue,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image == null
                        ? Center(child: Icon(Icons.add_a_photo))
                        : _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(image: _image!, fit: BoxFit.cover),
                              ),
                  ),
                ),
                SizedBox(
                  //itemName
                  width: 200,
                  child: TextField(
                    style: FontsTheme.mouseMemoirs_50Black(),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintStyle: FontsTheme.mouseMemoirs_50Black(),
                        hintText: 'Food name'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            //buildDropdownField('Categories', "value", Icons.local_dining),
            buildCategoriesField("Categories", "value", Icons.arrow_drop_down),
            buildWhereField('Add to', 'value', Icons.kitchen),
            buildDateField('Expiration date', ''),
            buildReminderField('30 April 2024'),
            buildQuantityWeight(),
            buildEachPieceField(),
            //buildCostField(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.softBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Previous',
                    style: FontsTheme.mouseMemoirs_30Black()
                        .copyWith(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.softOrange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Done',
                    style: FontsTheme.mouseMemoirs_30Black()
                        .copyWith(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.softBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Next',
                    style: FontsTheme.mouseMemoirs_30Black()
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            Center(
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
            )
          ],
        ),
      ),
    );
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
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: AppTheme.greenMainTheme,
                                width: 2.0), // Set border color and width
                          ),
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
                        )),
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
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: AppTheme.mainBlue,
                                width: 2.0), // Set border color and width
                          ),
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
                        )),
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget buildDateField(String label, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: FontsTheme.mouseMemoirs_30Black(),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text(
                        '${expirationDate.toLocal().toString().split(' ')[0]}',
                        style: FontsTheme.hind_20()),
                    trailing: Icon(Icons.calendar_month_rounded),
                    onTap: _selectExDate,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReminderField(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.notifications, color: Colors.red),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text('Remind on',
                      style: FontsTheme.mouseMemoirs_30Black()),
                ),
                SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text(
                        '${reminderDate.toLocal().toString().split(' ')[0]}',
                        style: FontsTheme.hind_20()),
                    trailing: Icon(Icons.calendar_month_rounded),
                    onTap: _selectReDate,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityWeight() {
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
                                    _updateAllCost();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    //Weight
                    Row(
                      children: [
                        Text('Weight',
                            style: FontsTheme.mouseMemoirs_30Black()),
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
                                  Text('$weightReduced ',
                                      style: FontsTheme.hindBold_20()),
                                  Text(Gram, style: FontsTheme.hindBold_20()),
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

  Widget buildEachPieceField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      //buildQuantityButton(Icons.remove),
                      Expanded(
                        flex: 5,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Each piece',
                                    style: FontsTheme.mouseMemoirs_30Black()),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'All Cost',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          allCost =
                                              double.tryParse(value) ?? allCost;
                                          _updateAllCost();
                                        });
                                      },
                                      style: FontsTheme.hindBold_15()),
                                ),
                                Icon(Icons.attach_money, color: Colors.green),
                                SizedBox(
                                  width: 50,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.info_rounded,
                                    color: AppTheme.mainBlue,
                                    size: 30,
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //buildQuantityButton(Icons.remove),

                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                            width: 100,
                            child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      costPerPiece = double.tryParse(value) ??
                                          costPerPiece;
                                      _updateAllCost();
                                    });
                                  }
                                },
                                controller: TextEditingController(
                                    text: _updateWeight()
                                        .toString()), // Set initial text

                                style: FontsTheme.hindBold_15())),
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 100,
                                  child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Cost',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            costPerPiece =
                                                double.tryParse(value) ??
                                                    costPerPiece;
                                            _updateCost();
                                          });
                                        }
                                        // Text(
                                        //     '\$${updateWeight.toStringAsFixed(2)}');
                                        // costPerPiece =
                                        //     double.tryParse(value) ??
                                        //         costPerPiece;
                                        // _updateCost();
                                        // );
                                      },
                                      controller: TextEditingController(
                                          text: _updateCost().toString()),
                                      style: FontsTheme.hindBold_15())),
                              Icon(Icons.attach_money, color: Colors.green),
                            ],
                          )),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _selectExDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expirationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  Future<void> _selectReDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: reminderDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != reminderDate) {
      setState(() {
        reminderDate = picked;
      });
    }
  }

  void _updateAllCost() {
    setState(() {
      updateAllCost = allCost;
    });
  }

  void _updateTotalCost() {
    setState(() {
      totalCost = quantity * costPerPiece;
    });
  }

  String _updateCost() {
    double updateCost = updateAllCost / quantity;
    return updateCost.toStringAsFixed(3);
  }

  String _updateWeight() {
    double updateWeight = weight / quantity;
    return updateWeight.toStringAsFixed(2);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expirationDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }
}
