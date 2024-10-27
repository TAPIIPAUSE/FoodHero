import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/models/fooddetail_model.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class foodDetails extends StatefulWidget {
  final int FoodID;
  //final InventoryListItem item;
  //final String category;
  // final String location;
  //final String expired;
  // final String remind;
  // final bool isCountable;
  //final String remaining;
  foodDetails({required this.FoodID
      // required this.item,
      // // required this.isCountable,
      // required this.remaining,
      // // required this.location,
      // required this.expired, required remind, required isCountable, required location,
      // required this.remind,
      //required this.category,
      });

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

// For countable uncountable option
const double width = 300.0;
const double height = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;

class _FoodDetailsPageState extends State<foodDetails> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FileImage? _image;
  // Image provider for the selected image
  bool _isLoading = false; // Flag to indicate image loading state
  bool _showImageOption = false;
  DateTime expirationDate = DateTime(2024);
  DateTime reminderDate = DateTime(2024);
  String expired = '';
  String remind = '';
  String remaining = '';
  int quantity = 1;
  int weight = 1; // in grams
  String weightReduced = ''; //make it proper for the decimals
  double allCost = 0;
  double costPerPiece = 0;
  double updateAllCost = 0;
  int consumeQuantity = 0;
  late final String foodname;
  late String category;
  late String location;
  late bool isCountable;
  int weightConsumeOption = 1;

  // For countable uncountable option
  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  Future<FoodDetailData?> _loadFoodDetail() async {
    try {
      print('Loading food details for ID: ${widget.FoodID}'); // Debug log

      final data = await InventoryFood().getFoodDetail(widget.FoodID);

      if (data != null) {
        print(
            'Successfully loaded food details: ${data.foodName}'); // Debug log
        return data;
      } else {
        print('No food details found'); // Debug log
        return null;
      }
    } catch (e) {
      print('Error loading food details: $e'); // Debug log
      rethrow;
    }
  }

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
        _showImageOption = true;
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
          offset: Offset(0, 0), // Adjust the offset to change the position
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0),
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
                      fixedSize: const Size(100, 100),
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
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
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

  String _updateCost() {
    double updateCost = updateAllCost / quantity;
    return updateCost.toStringAsFixed(3);
  }

  String _updateWeight() {
    double updateWeight = weight / quantity;
    return updateWeight.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    //foodname = widget.item.foodname;
    //isCountable = widget.item.isCountable as bool;
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
    //category = widget.category;
    weightConsumeOption = weight as int;
    //expired = widget.expired;
    // remind = widget.remind;
    // location = widget.location;
    // isCountable = widget.isCountable;
    //remaining = widget.remaining;
    // quantity = widget.remaining;
    // weight = widget.remaining;
    weightReduced = weight.toString();
  }

  double screenHeight = 950;
  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(67, 189, 174, 1),
      //   toolbarHeight: 75,
      //   centerTitle: true,
      //   title: Text(
      //     "Inventory",
      //     style: FontsTheme.mouseMemoirs_64White(),
      //   ),
      // ),
      // backgroundColor: AppTheme.lightGreenBackground,
      // body: SizedBox(
      //   child: Column(
      //     children: [
      //       Container(
      //         alignment: Alignment.centerLeft,
      //         height: 68,
      //         width: 100,
      //         margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      //         decoration: BoxDecoration(
      //           color: AppTheme.mainBlue,
      //           borderRadius: BorderRadius.circular(10),
      //         ),
      //       ),
      //       Container(
      //         height: 62,
      //         width: 378,
      //         margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      //         decoration: BoxDecoration(
      //           color: AppTheme.pastelsoftBlue,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(15), // Set top left corner radius
      //             topRight: Radius.circular(15), // Set top right corner radius
      //             bottomLeft:
      //                 Radius.circular(5), // Set bottom left corner radius
      //             bottomRight: Radius.circular(5), //
      //           ),
      //         ),
      //       ),
      //       Container(
      //         height: 62,
      //         width: 378,
      //         margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      //         decoration: BoxDecoration(
      //           color: AppTheme.pastelsoftBlue,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(5), // Set top left corner radius
      //             topRight: Radius.circular(5), // Set top right corner radius
      //             bottomLeft:
      //                 Radius.circular(15), // Set bottom left corner radius
      //             bottomRight: Radius.circular(15), //
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.greenMainTheme,
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          "Inventory",
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
      body: 
      FutureBuilder<FoodDetailData?>(
          future: _loadFoodDetail(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print('Error in FutureBuilder: ${snapshot.error}'); // Debug log
              return Center(child: Text('Error loading food details'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              print('No data available in snapshot'); // Debug log
              return Center(child: Text('No food details available'));
            }

            final food = snapshot.data!;
            print('Rendering food details for: ${food.foodName}'); // Debug log

            // Adjust screen height based on isCountable
            double screenHeight = isCountable ? 800 : 600;

            print('this is iscountable: $isCountable');
            return 
            Stack(
              children: [
                // Container(
                //   //for make border
                //   height: 550,
                //   decoration: BoxDecoration(
                //       color: AppTheme.lightGreenBackground,
                //       borderRadius: BorderRadius.only(
                //           bottomLeft: const Radius.circular(20),
                //           bottomRight: const Radius.circular(20))),
                // ),
                SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: screenHeight,
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
                                    child: Image.asset(
                                        'assets/images/TimeMachine.png'),
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
                                    GestureDetector(
                                      onTap: () =>
                                          _chooseAddImageOption(context),
                                      child: Container(
                                        width: 100,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          color: AppTheme.mainBlue,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: _image == null
                                            ? const Center(
                                                child: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                              ))
                                            : _isLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image(
                                                        image: _image!,
                                                        fit: BoxFit.cover),
                                                  ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        style:
                                            FontsTheme.mouseMemoirs_50Black(),
                                        textAlign: TextAlign.center,
                                        foodname,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16),
                                //buildDropdownField('Categories', "value", Icons.local_dining),
                                buildCategoriesField("Categories", "value",
                                    Icons.arrow_drop_down),
                                buildWhereField('In', 'value', Icons.kitchen),
                                buildExpireField('Expiration date', ''),
                                buildReminderField('30 April 2024'),
                                buildQuantityWeight(),
                                buildEachPieceField(),
                                //buildCostField(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: keyboardHeight > 0 ? 0 : 180,
                        color: AppTheme.lightGreenBackground,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      _consumeOption(context, food),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFF4A261),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    'Consume',
                                    style: FontsTheme.mouseMemoirs_30Black()
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _wasteOption(context, food),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE76F51),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    'Waste',
                                    style: FontsTheme.mouseMemoirs_30Black()
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Delete item',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Center(
                              child: IconButton(
                                icon:
                                    Image.asset('assets/images/BackButton.png'),
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
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }

  void _consumeOption(BuildContext context, FoodDetailData food) {
    Widget buildConsumedQuantityUnit(String value) {
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
                width: 100,
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
              ),
            ],
          ),
        );
      });
    }

    String weightConsumeOptionString = "";
    showDialog(
        context: context,
        builder: (BuildContext contetxt) {
          return Transform.translate(
            offset: Offset(0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: Stack(
                  children: [
                    Container(
                      height: 250,
                      width: 375,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.softRed,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            addToConsumed(context);
                            print("adding");
                          },
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
                      height: 175,
                      width: 355,
                      margin: EdgeInsets.all(10),
                      foregroundDecoration: BoxDecoration(
                        color: AppTheme.softBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    Container(
                        width: 350,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            // SizedBox(
                            //   child: Container(
                            //     width: 300,
                            //     height: 200,
                            //     padding: EdgeInsets.all(3),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5),
                            //     color: AppTheme.softRed),

                            // SizedBox(
                            //   width: 10,
                            //   height: 10,
                            //   child: InkWell(
                            //       onTap: () {
                            //         consumeQuantity - 1;
                            //       },
                            //       child: Icon(
                            //         Icons.remove,
                            //         color: Colors.white,
                            //         size: 16,
                            //       )),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 3),
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 3, vertical: 2),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(3),
                            //       color: Colors.white),
                            //   child: Text(
                            //     "$consumeQuantity",
                            //     style: TextStyle(
                            //         color: Colors.black, fontSize: 16),
                            //   ),
                            // ),
                            //Consume option if Countable show Quantity
                            Visibility(
                              visible: food.isCountable,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    width: 80,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$quantity ',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Pieces',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Consume option if Not Countable show Weight
                            Visibility(
                              visible: !food.isCountable,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$weightConsumeOption',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('grams',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // SizedBox(
                            //   width: 10,
                            //   height: 10,
                            //   child: InkWell(
                            //       onTap: () {
                            //         consumeQuantity + 1;
                            //       },
                            //       child: Icon(
                            //         Icons.add,
                            //         color: Colors.white,
                            //         size: 16,
                            //       )),
                            // ),
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
                                min: 100,
                                max: weight.toDouble(),
                                onChanged: (valueWeightConsumeOption) =>
                                    setState(() {
                                  weightConsumeOption =
                                      valueWeightConsumeOption.toInt();

                                  weightConsumeOption.toStringAsFixed(0);
                                }),
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    completeConsume(context);
                  },
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

  List<ConsumedListItem> consumedItems = [];

  void addToConsumed(BuildContext context) {
    final newItem = ConsumedListItem(
      cID: 1,
      thumbnail: "assets/images/apples.jpg",
      foodname: foodname,
      expiry: "ssss",
      progressbar: 80,
      consuming: "12",
      remaining: "8",
      isCountable: isCountable,
    );

    Provider.of<ConsumedItemsProvider>(context, listen: false)
        .addConsumedItem(newItem);
    // setState(() {
    //   consumedItems.add(newItem);
    // });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Consumed(consumedItems: consumedItems),
    //   ),
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${foodname} added to consumed list',
          style: FontsTheme.hindBold_20(),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.greenMainTheme,
      ),
    );
  }

  void completeConsume(BuildContext context) {
    consumedModal(context);
  }

  void consumedModal(BuildContext context) {
    String foodnameString = foodname;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Dialog.fullscreen(
              child: Stack(
            children: [
              Container(
                  color: AppTheme.lightGreenBackground,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '$foodnameString\n Consummed',
                          style: FontsTheme.mouseMemoirs_64Black(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 400,
                        ),
                        Text(
                          '5 Boxes were consumed\n You get 5 points (+5.0)\n Save 500 baht',
                          style: FontsTheme.mouseMemoirs_30Black(),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Consumed(),
                                ),
                              );
                            },
                            child: Text(
                              'Go to the consuming food',
                              style: FontsTheme.mouseMemoirs_20(),
                            ))
                      ],
                    ),
                  )),
            ],
          )),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _wasteOption(BuildContext context, FoodDetailData food) {
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
                              onPressed: () => _consumeReasons(context),
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
                                    'Waste',
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
                        width: 350,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            // SizedBox(
                            //   child: Container(
                            //     width: 300,
                            //     height: 200,
                            //     padding: EdgeInsets.all(3),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(5),
                            //     color: AppTheme.softRed),

                            // SizedBox(
                            //   width: 10,
                            //   height: 10,
                            //   child: InkWell(
                            //       onTap: () {
                            //         consumeQuantity - 1;
                            //       },
                            //       child: Icon(
                            //         Icons.remove,
                            //         color: Colors.white,
                            //         size: 16,
                            //       )),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 3),
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 3, vertical: 2),
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(3),
                            //       color: Colors.white),
                            //   child: Text(
                            //     "$consumeQuantity",
                            //     style: TextStyle(
                            //         color: Colors.black, fontSize: 16),
                            //   ),
                            // ),
                            //Consume option if Countable show Quantity
                            Visibility(
                              visible: food.isCountable,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    width: 80,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$quantity ',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Pieces',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Consume option if Not Countable show Weight
                            Visibility(
                              visible: !food.isCountable,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Container(
                                    width: 100,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$weightConsumeOption',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 50,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('grams',
                                            style: FontsTheme.hindBold_20()
                                                .copyWith(color: Colors.black)),
                                        //   buildConsumedQuantityUnit(''),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // SizedBox(
                            //   width: 10,
                            //   height: 10,
                            //   child: InkWell(
                            //       onTap: () {
                            //         consumeQuantity + 1;
                            //       },
                            //       child: Icon(
                            //         Icons.add,
                            //         color: Colors.white,
                            //         size: 16,
                            //       )),
                            // ),
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
                                min: 100,
                                max: weight.toDouble(),
                                onChanged: (valueWeightConsumeOption) =>
                                    setState(() {
                                  weightConsumeOption =
                                      valueWeightConsumeOption.toInt();

                                  weightConsumeOption.toStringAsFixed(0);
                                }),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ));
        });
  }

  void _consumeReasons(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext contetxt) {
          return Container(
            child: Transform.translate(
              offset: const Offset(0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 375,
                          width: 350,
                          decoration: BoxDecoration(
                            color: AppTheme.softBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: FontsTheme.mouseMemoirs_40()
                                      .copyWith(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Why is it wasted',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap
                                  print('Leftovers');
                                },
                                child: Container(
                                  height: 44,
                                  width: 252,
                                  decoration: BoxDecoration(
                                    color: AppTheme.softBrightGreen,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: FontsTheme.hind_20()
                                            .copyWith(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'Leftovers',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap
                                  print('Forgotten');
                                },
                                child: Container(
                                  height: 44,
                                  width: 252,
                                  decoration: BoxDecoration(
                                    color: AppTheme.softOrange,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: FontsTheme.hind_20()
                                            .copyWith(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'Forgotten',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap
                                  print('Spoiled');
                                },
                                child: Container(
                                  height: 44,
                                  width: 252,
                                  decoration: BoxDecoration(
                                    color: AppTheme.softRed,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: FontsTheme.hind_20()
                                            .copyWith(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'Spoiled',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap
                                  print('Other');
                                },
                                child: Container(
                                  height: 44,
                                  width: 252,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        style: FontsTheme.hind_20()
                                            .copyWith(color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'Other',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          );
        });
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
                          child: Text(
                            "category",
                            style: FontsTheme.mouseMemoirs_30Black(),
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
                            child: Text(
                              location,
                              style: FontsTheme.mouseMemoirs_30Black(),
                            )

                            // DropdownButtonHideUnderline(
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
                            // ),
                            )),
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget buildExpireField(String label, String date) {
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
                    title: Text(expired, style: FontsTheme.hind_20()),
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
                    title: Text(remind, style: FontsTheme.hind_20()),
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

  bool showQuantity = true;
  Widget buildQuantityWeight() {
    showQuantity = isCountable;
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
                      visible: showQuantity,
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
                                    Text(remaining,
                                        style: FontsTheme.hindBold_20()),
                                    buildQuantityUnit('')
                                  ],
                                ),
                              ),
                              // SliderTheme(
                              //   data: SliderTheme.of(context).copyWith(
                              //     trackHeight: 10.0,
                              //     thumbShape: SliderComponentShape.noThumb,
                              //     overlayShape: RoundSliderOverlayShape(
                              //         overlayRadius: 24.0),
                              //     activeTrackColor: Colors.orange,
                              //     inactiveTrackColor: Colors.orange[100],
                              //     thumbColor: Colors.white,
                              //     overlayColor: Colors.orange.withAlpha(32),
                              //   ),
                              //   child: Slider(
                              //     value: quantity.toDouble(),
                              //     min: 1,
                              //     max: 100,
                              //     divisions: 100,
                              //     onChanged: (value) {
                              //       setState(() {
                              //         quantity = value.toInt();
                              //         _updateAllCost();
                              //         consumeQuantity = quantity;
                              //       });
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                          Row(children: [
                            SizedBox(
                              width: 80,
                            ),
                            // SizedBox(
                            //   height: 60,
                            //   width: 280,
                            //   child: InteractiveSlider(
                            //     focusedHeight: 20,
                            //     backgroundColor: AppTheme.softRed,
                            //     startIcon: const Icon(
                            //       Icons.remove_circle_rounded,
                            //       color: Colors.black,
                            //     ),
                            //     endIcon: const Icon(
                            //       Icons.add_circle_rounded,
                            //       color: Colors.black,
                            //     ),
                            //     min: 1,
                            //     max: 100,
                            //     onChanged: (value) => setState(() {
                            //       quantity = value.toInt();
                            //       _updateAllCost();
                            //       consumeQuantity = quantity;
                            //     }),
                            //   ),
                            // ),
                          ]),
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
                                  Text('$weightReduced',
                                      style: FontsTheme.hindBold_20()),
                                  buildWeightUnit('')
                                ],
                              ),
                            ),
                            // SliderTheme(
                            //   data: SliderTheme.of(context).copyWith(
                            //     trackHeight: 10.0,
                            //     thumbShape: SliderComponentShape.noThumb,
                            //     overlayShape: RoundSliderOverlayShape(
                            //         overlayRadius: 24.0),
                            //     activeTrackColor: Colors.orange,
                            //     inactiveTrackColor: Colors.orange[100],
                            //     thumbColor: Colors.white,
                            //     overlayColor: Colors.orange.withAlpha(32),
                            //   ),
                            //   child: Slider(
                            //     value: weight,
                            //     min: 1,
                            //     max: 10000,
                            //     divisions: 10000,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         weight = value;

                            //         weightReduced = weight.toStringAsFixed(0);
                            //       });
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Row(children: [
                      SizedBox(
                        width: 80,
                      ),
                      // SizedBox(
                      //   height: 60,
                      //   width: 280,
                      //   child: InteractiveSlider(
                      //     focusedHeight: 20,
                      //     backgroundColor: AppTheme.softRed,
                      //     startIcon: const Icon(
                      //       Icons.remove_circle_rounded,
                      //       color: Colors.black,
                      //     ),
                      //     endIcon: const Icon(
                      //       Icons.add_circle_rounded,
                      //       color: Colors.black,
                      //     ),
                      //     min: 1,
                      //     max: 100,
                      //     onChanged: (value) => setState(() {
                      //       weight = value;
                      //       weightReduced = weight.toStringAsFixed(0);
                      //     }),
                      //   ),
                      // ),
                    ]),
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

  bool showEachPiece = true;
  Widget buildEachPieceField() {
    // if (isCountable = true) {
    //   showEachPiece = isCountable;
    // } else {
    //   showEachPiece = isCountable;
    // }
    showEachPiece = isCountable;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        child: Form(
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
                                    Text('All Cost',
                                        style:
                                            FontsTheme.mouseMemoirs_30Black()),
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
                                                  double.tryParse(value) ??
                                                      allCost;
                                              _updateAllCost();
                                            });
                                          },
                                          style: FontsTheme.hindBold_15()),
                                    ),
                                    Icon(Icons.attach_money,
                                        color: Colors.green),
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
                          ),
                        ],
                      ),
                      Visibility(
                        visible: showEachPiece,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //buildQuantityButton(Icons.remove),
                            Text('Each piece',
                                style: FontsTheme.mouseMemoirs_30Black()),

                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
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
                                            costPerPiece =
                                                double.tryParse(value) ??
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
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
                                    Icon(Icons.attach_money,
                                        color: Colors.green),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConsumedQuantityUnit(String value) {
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
            Row(
              children: [
                SizedBox(
                  width: 70,
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
            )
          ],
        ),
      );
    });
  }
}
