import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/models/completeconsume_model.dart';
import 'package:foodhero/models/conpletewaste_model.dart';
import 'package:foodhero/models/fooddetail_model.dart';
import 'package:foodhero/models/someconsume_model.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/api/consumeFromFoodDetail.dart';
import 'package:foodhero/pages/api/wasteFromFoodDetails.dart';
import 'package:foodhero/pages/consumed/Consumed.dart';
import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:interactive_slider/interactive_slider.dart';

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
  //From API
  int foodID = 0;
  String imageURL = '';
  DateTime expirationDate = DateTime(2024);
  String expireString = '';
  String expireDate = '';
  DateTime reminderDate = DateTime(2024);
  String remindString = '';
  String remindDate = '';
  //String apiQuantity = '';
  late int showQuantity = 0;
  String apiPackage = '';
  String showPackage = '';
  double weightCountable = 0;
  String showUnit = '';
  double weightUncountable = 0;
  double allCostString = 0;
  double eachPieceWeight = 0;
  double eachPieceCost = 0;
  int? intQuantity = 0;
  int weightUnit = 0;
  String showConsumeOptUnit = '';
  //
  String expired = '';
  String remind = '';
  String remaining = '';
  int quantity = 1;
  int weight = 1; // in grams
  String weightReduced = ''; //make it proper for the decimals
  double allCost = 0;
  double costPerPiece = 0;
  double updateAllCost = 0;
  double consumeQuantity = 0;
  int selectedConsumeQuantityModal = 0;
  late String foodname = '';
  String category = '';
  String location = '';
  late bool isCountable;
  int weightConsumeOption = 1;
  String consumeOptionUnit = '';

  // For countable uncountable option
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  //
  String foodNameModal = '';
  String consumeQuantityModal = '';

  int scoreGained = 0; //from a backend response
  int save = 0; //from a backend response

  int lost = 0; //from a backend response

  Future<FoodDetailData?> _loadFoodDetail() async {
    try {
      // Debug log
      print('Loading food details for ID: ${widget.FoodID}');
      final data = await APIFood().getFoodDetail(widget.FoodID);
      print(data);
      if (data != null) {
        print(
            'Successfully loaded food details: ${data.FoodName}'); // Debug log
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

  final Consumefromfooddetail APIConsume = Consumefromfooddetail();
  final Consumefromfooddetail APICompleteConsume = Consumefromfooddetail();
  final Wastefromfooddetail APICompleteWaste = Wastefromfooddetail();
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

  void updateModalScores(String jsonResponse) {
    // Parse JSON response
    final Map<String, dynamic> data = jsonDecode(jsonResponse);
    setState(() {
      scoreGained = data['scoreGained'];
      save = data['save'];
    });
  }

  void updateWasteModalScores(String jsonResponse) {
    // Parse JSON response
    final Map<String, dynamic> data = jsonDecode(jsonResponse);
    setState(() {
      scoreGained = data['scoreGained'];
      lost = data['Lost'];
    });
  }

  late Future<FoodDetailData?> foodDetailFuture;
  @override
  void initState() {
    super.initState();
    foodDetailFuture = _loadFoodDetail();
    //foodname = widget.item.foodname;
    //isCountable = isCountable;
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
    consumeOptionUnit = consumeOptionUnit;
    String completeConsumeRes =
        '{"message": "Food item consumed successfully", "scoreGained": 2, "save": 50}';
    updateModalScores(completeConsumeRes);
    String completeWasteRes =
        '{"message": "Food item Waste successfully", "scoreGained": 2, "Lost": 50}';
    updateWasteModalScores(completeWasteRes);
  }

  //double screenHeight = 950;

  // Function to handle pluralization
  String _getConsumeOptionUnit(double consumeUnit, String unit) {
    if (consumeUnit == 0 || consumeUnit <= 1.99) {
      return unit; // Singular form
    } else {
      // Pluralize based on the unit
      switch (unit) {
        case 'Piece':
          return 'Pieces';
        case 'Box':
          return 'Boxes';
        case 'Bottle':
          return 'Bottles';
        case 'Gram':
          return 'Grams';
        case 'Kilogram':
          return 'Kilograms';
        case 'Milliliter':
          return 'Milliliters';
        case 'Liter':
          return 'Liters';
        default:
          return unit; // Fallback to original unit if no match
      }
    }
  }

  bool _howMuchConsumedVisible = false;
  void _showHowMuchConsumed() {
    setState(() {
      _howMuchConsumedVisible = true;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _howMuchConsumedVisible = false;
      });
    });
  }

  void _consumeOption(BuildContext context, int getQuantity, double getWeight,
      Function refreshData) {
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

    double consumeQuantity = getQuantity.toDouble();
    double consumeWeight = getWeight;
    //double consumeQuantity = 5;
    String weightConsumeOptionString = "";

    SizedBox(width: _howMuchConsumedVisible ? 60 : 0);
    showDialog(
        context: context,
        builder: (BuildContext contetxt) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pop(); // Close the dialog when tapping outside
            },
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    // Prevent closing when tapping inside the dialog content
                  },
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
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
                                  onPressed: () async {
                                    addToConsumed(context);

                                    int fID = foodID;
                                    SomeConsume addSomeConsume = SomeConsume(
                                        fID: fID,
                                        retrievedQuantity:
                                            consumeQuantity.toInt(),
                                        retrievedAmount: consumeQuantity.toInt()
                                        //consume values
                                        );

                                    try {
                                      await APIConsume.someConsume(
                                          addSomeConsume);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          //width:screen - 20,
                                          margin: EdgeInsets.only(bottom: 500),
                                          padding: EdgeInsets.all(20),
                                          content: Text(
                                            "$selectedConsumeQuantityModal $foodname Consumed!",
                                            style: FontsTheme.hindBold_20(),
                                          ),
                                          duration: const Duration(seconds: 6),
                                          backgroundColor:
                                              AppTheme.greenMainTheme,
                                          shape: RoundedRectangleBorder(
                                            //side: BorderSide(color: Colors.red, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      refreshData();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(bottom: 300),
                                        content: Text(
                                          'Failed to complete food: $e',
                                          style: FontsTheme.hindBold_20(),
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor:
                                            AppTheme.greenMainTheme,
                                      ));
                                    }
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
                            Visibility(
                                visible: isCountable,
                                child: Container(
                                  width: 350,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "${consumeQuantity.toInt()}",
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(consumeOptionUnit,
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                //   buildConsumedQuantityUnit(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                            max: showQuantity.toDouble(),
                                            onChanged:
                                                (double valueConsumeOption) {
                                              setState(
                                                () {
                                                  //Countable
                                                  consumeQuantity =
                                                      valueConsumeOption;

                                                  consumeOptionUnit =
                                                      _getConsumeOptionUnit(
                                                          consumeQuantity,
                                                          showConsumeOptUnit);
                                                  selectedConsumeQuantityModal =
                                                      consumeQuantity.toInt();

                                                  //weightConsumeOption.toStringAsFixed(0);
                                                },
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                )),
                            Visibility(
                                visible: !isCountable,
                                child: Container(
                                  width: 350,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("${consumeWeight.toInt()}",
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(consumeOptionUnit,
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                //   buildConsumedQuantityUnit(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                          max: weightUncountable.toDouble(),
                                          onChanged:
                                              (double valueConsumeOption) =>
                                                  setState(() {
                                            //unCountable
                                            consumeWeight = valueConsumeOption;

                                            consumeOptionUnit =
                                                _getConsumeOptionUnit(
                                                    consumeWeight,
                                                    showConsumeOptUnit);
                                            selectedConsumeQuantityModal =
                                                consumeWeight.toInt();

                                            //weightConsumeOption.toStringAsFixed(0);
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            completeConsume(context);

                            int fID = foodID;
                            CompleteConsume addCompleteConsume =
                                CompleteConsume(
                              fID: fID,
                            );
                            try {
                              await APICompleteConsume.completeConsume(
                                  addCompleteConsume);
                              Navigator.of(context).pop();
                              _showHowMuchConsumed();
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 300),
                                content: Text(
                                  'Failed to complete consume food: $e',
                                  style: FontsTheme.hindBold_20(),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: AppTheme.greenMainTheme,
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.consumedOrange,
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              side: const BorderSide(
                                color: AppTheme.softRedCancleWasted,
                                width: 5,
                              )),
                          child: Text(
                            'Cancle',
                            style: FontsTheme.hindBold_20()
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        });

    if (_howMuchConsumedVisible) {
      Positioned(
        top: 0,
        left: 20, // Padding from the left
        right: 20, // Padding from the right
        child: Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue,
          child: Text(
            'This is your custom SnackBar!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  List<ConsumedListItem> consumedItems = [];

  void addToConsumed(BuildContext context) {
    // final newItem = ConsumedListItem(
    //   cID: 1,
    //   thumbnail: "assets/images/apples.jpg",
    //   foodname: foodname,
    //   expiry: "ssss",
    //   progressbar: 80,
    //   consuming: "12",
    //   remaining: "8",
    //   isCountable: isCountable,
    // );

    // Provider.of<ConsumedItemsProvider>(context, listen: false)
    //     .addConsumedItem(newItem);
    // setState(() {
    //   consumedItems.add(newItem);
    // });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Consumed(consumedItems: consumedItems),
    //   ),
    // );
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 600),
      content: Text(
        '$selectedConsumeQuantityModal ${foodname} added to consumed list',
        style: FontsTheme.hindBold_20(),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: AppTheme.greenMainTheme,
    );
  }

  void completeConsume(BuildContext context) {
    consumedModal(context);
  }

  void consumedModal(BuildContext context) {
    // String tellScore = ' ';
    // if (score > 0) {
    //   score = score;
    // } else {
    //   tellScore = 'You loss $score points\n Your loss $save';
    // }
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            '$foodNameModal\n Consummed',
                            style: FontsTheme.mouseMemoirs_64Black(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 400,
                          ),
                          Text(
                            '$consumeQuantityModal were consumed\n You get $scoreGained points\n Save $lost ฿ Baht',
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

  void _wasteOption(BuildContext context, int getQuantity, double getWeight,
      Function refreshData) {
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

    double consumeQuantity = getQuantity.toDouble();
    double consumeWeight = getWeight;
    showDialog(
        context: context,
        builder: (BuildContext contetxt) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pop(); // Close the dialog when tapping outside
            },
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () {
                    // Prevent closing when tapping inside the dialog content
                  },
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Column(
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
                                color: AppTheme.spoiledBrown,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: TextButton(
                                  onPressed: () async {
                                    addToConsumed(context);
                                    int fID = foodID;
                                    SomeConsume addSomeConsume = SomeConsume(
                                        fID: fID,
                                        retrievedQuantity:
                                            consumeQuantity.toInt(),
                                        retrievedAmount: consumeQuantity.toInt()
                                        //consume values
                                        );

                                    try {
                                      await APIConsume.someConsume(
                                          addSomeConsume);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          //width:screen - 20,
                                          margin: EdgeInsets.only(bottom: 500),
                                          padding: EdgeInsets.all(20),
                                          content: Text(
                                            "$selectedConsumeQuantityModal $foodname Wasted!",
                                            style: FontsTheme.hindBold_20(),
                                          ),
                                          duration: const Duration(seconds: 6),
                                          backgroundColor:
                                              AppTheme.greenMainTheme,
                                          shape: RoundedRectangleBorder(
                                            //side: BorderSide(color: Colors.red, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      refreshData();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(bottom: 300),
                                        content: Text(
                                          'Failed to waste food: $e',
                                          style: FontsTheme.hindBold_20(),
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor:
                                            AppTheme.greenMainTheme,
                                      ));
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppTheme.spoiledBrown,
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
                              alignment: Alignment.topCenter,
                              height: 175,
                              width: 355,
                              margin: EdgeInsets.all(10),
                              foregroundDecoration: BoxDecoration(
                                color: AppTheme.softBlue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            Visibility(
                                visible: isCountable,
                                child: Container(
                                  width: 350,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("${consumeWeight.toInt()}",
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(consumeOptionUnit,
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                //   buildConsumedQuantityUnit(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                          max: weightUncountable.toDouble(),
                                          onChanged:
                                              (double valueConsumeOption) =>
                                                  setState(() {
                                            //unCountable
                                            consumeWeight = valueConsumeOption;

                                            consumeOptionUnit =
                                                _getConsumeOptionUnit(
                                                    consumeQuantity,
                                                    showConsumeOptUnit);
                                            selectedConsumeQuantityModal =
                                                consumeQuantity.toInt();

                                            //weightConsumeOption.toStringAsFixed(0);
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Visibility(
                                visible: !isCountable,
                                child: Container(
                                  width: 350,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Row(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("${consumeWeight.toInt()}",
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(consumeOptionUnit,
                                                    style:
                                                        FontsTheme.hindBold_20()
                                                            .copyWith(
                                                                color: Colors
                                                                    .black)),
                                                //   buildConsumedQuantityUnit(''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                          max: weightUncountable.toDouble(),
                                          onChanged:
                                              (double valueConsumeOption) =>
                                                  setState(() {
                                            //unCountable
                                            consumeWeight = valueConsumeOption;

                                            consumeOptionUnit =
                                                _getConsumeOptionUnit(
                                                    consumeWeight,
                                                    showConsumeOptUnit);
                                            selectedConsumeQuantityModal =
                                                consumeWeight.toInt();

                                            //weightConsumeOption.toStringAsFixed(0);
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        )),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            completeWaste(context);

                            int fID = foodID;
                            CompleteWaste postCompleteWaste = CompleteWaste(
                              fID: fID,
                            );
                            try {
                              await APICompleteWaste.completeWaste(
                                  postCompleteWaste);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(bottom: 300),
                                  content: Text(
                                    "All $foodname Wasted!",
                                    style: FontsTheme.hindBold_20(),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppTheme.greenMainTheme,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(bottom: 300),
                                content: Text(
                                  'Failed to complete waste food: $e',
                                  style: FontsTheme.hindBold_20(),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: AppTheme.greenMainTheme,
                              ));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.softRedCancleWasted,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Complete Waste',
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: const BorderSide(
                                color: AppTheme.softRedCancleWasted,
                                width: 5,
                              )),
                          child: Text(
                            'Cancle',
                            style: FontsTheme.hindBold_20()
                                .copyWith(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ),
              ),
            ),
          );
        });
  }

  void completeWaste(BuildContext context) {
    wastedModal(context);
  }

  void wastedModal(BuildContext context) {
    // String tellScore = ' ';
    // if (score > 0) {
    //   score = score;
    // } else {
    //   tellScore = 'You loss $score points\n Your loss $save';
    // }
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            '$foodNameModal\n Wasted',
                            style: FontsTheme.mouseMemoirs_64Black(),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 400,
                          ),
                          Text(
                            '$consumeQuantityModal were wasted\n You get $scoreGained points\n Save $save ฿ Baht',
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

  void refreshData() {
    setState(() {
      // Call your method to fetch fresh data here, e.g., _loadFoodDetail();
      foodDetailFuture = _loadFoodDetail(); // Assuming you have this method
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
                  color: AppTheme.pastelSoftBlue,
                ),
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: FontsTheme.mouseMemoirs_30Black(),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: AppTheme.greenMainTheme,
                                width: 2.0), // Set border color and width
                          ),
                          child: Text(
                            category,
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
                  color: AppTheme.pastelSoftBlue,
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
                        width: MediaQuery.of(context).size.width * 0.4,
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
              color: AppTheme.softRedBrown,
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
                    title: Text(expireDate, style: FontsTheme.hind_20()),
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
              color: AppTheme.softRed,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Remind on',
                      style: FontsTheme.mouseMemoirs_30Black()),
                ),
                Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.softRedCancleWasted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ImageIcon(
                        AssetImage("assets/images/Alarm.png"),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: ListTile(
                    title: Text(remindDate, style: FontsTheme.hind_20()),
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

  String _getQuantityPackage(int showQuantity, String package) {
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

  String _getWeightUnit(int weightCountable, String unit) {
    if (weightCountable == 0 || weightCountable <= 1.99) {
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
    // showPackage = showQuantity == 1 ? showPackage : "${showPackage}s";
    // showUnit = weightCountable == 1 ? showUnit : "${showUnit}s";

    showPackage = _getQuantityPackage(showQuantity, showPackage);
    showUnit = _getWeightUnit(weightCountable.toInt(), showUnit);

    String boxLabel = quantity == 1 ? "Box" : "Boxes";
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
                      visible: showQuantityField,
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
                          // Row(children: [
                          //   SizedBox(
                          //     width: 80,
                          //   ),
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
                          //  ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
                                  Text(weightCountable.toString(),
                                      style: FontsTheme.hindBold_20()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(showUnit.toString(),
                                      style: FontsTheme.hindBold_20()),
                                  // buildWeightUnit('')
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
                        child: Container(
                          child: Text(''),
                        )
                        // DropdownButtonHideUnderline(
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
                    color: AppTheme.softBlue,
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
                                    Text(
                                      'All Cost',
                                      style: FontsTheme.mouseMemoirs_30Black(),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        allCostString.toString(),
                                        style: FontsTheme.hindBold_20(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      '฿',
                                      style: FontsTheme.mouseMemoirs_25(),
                                    ),
                                    Text(
                                      'TH ',
                                      style: FontsTheme.hindBold_20(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
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
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                  width: 60,
                                  child: TextField(
                                      decoration: const InputDecoration(
                                          labelText: 'Weight',
                                          border: InputBorder.none),
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
                                          text: eachPieceWeight.toString()
                                          // _updateWeight()
                                          //     .toString()
                                          ), // Set initial text

                                      style: FontsTheme.hindBold_15())),
                            ),
                            Container(
                              height: 50,
                              width: 2,
                              decoration:
                                  BoxDecoration(color: AppTheme.greenMainTheme),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 60,
                                        child: TextField(
                                            decoration: const InputDecoration(
                                                labelText: 'Cost',
                                                border: InputBorder.none),
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
                                                text: eachPieceCost.toString()
                                                //_updateCost().toString()
                                                ),
                                            style: FontsTheme.hindBold_15())),
                                    Text(
                                      '฿',
                                      style: FontsTheme.mouseMemoirs_25(),
                                    ),
                                    // Text(
                                    //   'TH ',
                                    //   style: FontsTheme.hindBold_20(),
                                    // ),
                                    // Icon(Icons.attach_money,
                                    //     color: Colors.green),
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

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
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
      body: FutureBuilder<FoodDetailData?>(
          future: foodDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppTheme.greenMainTheme,
              ));
            }

            if (snapshot.hasError) {
              print('Error in FutureBuilder: ${snapshot.error}'); // Debug log
              return Center(child: Text('Error loading food details'));
            }

            if (!snapshot.hasData || snapshot.data == null) {
              print('No data available in snapshot'); // Debug log
              return Center(child: Text('No food details available'));
            }

            final foodDetail = snapshot.data!;
            print(
                'Rendering foodDetail details for: ${foodDetail.FoodName}'); // Debug log
            foodID = foodDetail.Food_ID;
            foodname = foodDetail.FoodName;
            imageURL = foodDetail.URL;
            category = foodDetail.Category;
            location = foodDetail.Location;
            isCountable = foodDetail.isCountable;
            expireString = foodDetail.Expired.toString();
            DateTime expire = DateTime.parse(expireString);
            expireDate = DateFormat('dd-MM-yyyy').format(expire);
            remindString = foodDetail.Remind.toString();
            DateTime remind = DateTime.parse(remindString);
            remindDate = DateFormat('dd-MM-yyyy').format(remind);
            showQuantity = foodDetail.QuantityCountable;
            showPackage = foodDetail.Package;
            //intQuantity = int.tryParse(quantityString.split(' ')[0]);
            weightCountable = foodDetail
                .WeightUncountable; //foodDetail.Remaining_amount(String) //Only double food.WeightCountable;
            weightUncountable = foodDetail.WeightUncountable;
            showUnit = foodDetail.Unit;
            eachPieceWeight = foodDetail.IndividualWeight;
            eachPieceCost = foodDetail.IndividualCost;
            if (isCountable == true) {
              showConsumeOptUnit = foodDetail.Package;
            } else {
              showConsumeOptUnit = foodDetail.Unit;
            }

            // if (isCountable == false) {
            //   weightCountable = foodDetail.total_amount;
            // }
            allCostString = foodDetail.TotalCost;
            // weightUnit = foodDetail.;

            //allCostString = foodDetail.total_price.toString();

            foodNameModal = foodDetail.FoodName;
            consumeQuantityModal = foodDetail.Remaining;
            //  score = foodDetail.scoreGained;
            //  save = foodDetail.save;
            double screenHeight = foodDetail.isCountable ? 1000 : 900;

            print('this is iscountable: $isCountable');
            return Stack(
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
                                        child: imageURL.isEmpty
                                            ? const Center(
                                                child: Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white,
                                              ))
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  imageURL,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                        .expectedTotalBytes ??
                                                                    1)
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                    return const Center(
                                                        child: Icon(Icons.error,
                                                            color: Colors.red));
                                                  },
                                                ),
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
                                        foodDetail.FoodName,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _consumeOption(
                                      context,
                                      showQuantity,
                                      weightUncountable,
                                      refreshData),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.consumedOrange,
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
                                  onPressed: () => _wasteOption(
                                      context,
                                      showQuantity,
                                      weightUncountable,
                                      refreshData),
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
                            const SizedBox(height: 2),
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
}
