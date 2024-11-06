import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodhero/models/addfood_model.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interactive_slider/interactive_slider.dart';
//import 'package:intl/intl.dart';

class addFoodDetails extends StatefulWidget {
  @override
  _AddFoodDetailsPageState createState() => _AddFoodDetailsPageState();
}

// For countable uncountable option
const double width = 300.0;
const double height = 60.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;

class _AddFoodDetailsPageState extends State<addFoodDetails> {
  FileImage? _image;
  // Image provider for the selected image
  bool _isLoading = false; // Flag to indicate image loading state
  bool _showImageOption = false;
  DateTime expirationDate = DateTime.now();
  DateTime reminderDate = DateTime.now();
  int quantity = 1;
  TextEditingController quantityController = TextEditingController();
  int sendQuantity = 0;
  double weightDouble = 1; // in grams
  String weight = ''; //make it proper for the decimals
  TextEditingController weightController = TextEditingController();
  int sendWeight = 0;
  double allCost = 0;
  double costPerPiece = 0;
  double updateAllCost = 0;
  int consumeQuantity = 0;
  int current_amount = 0;
  //double consumed_amount = //
  final TextEditingController foodname = TextEditingController();
  late String selectedCategory = '';
  int selectedCategoryIndex = 0;
  String selectedLocation = '';
  int selectedLocationIndex = 0;
  bool isCountable = true;
  int selectedQuantityUnit = 0;
  int selectedWeightUnit = 0;

  late double xAlign;
  late Color loginColor;
  late Color signInColor;
  final APIFood addFoodAPI = APIFood();
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
          ),
        );
      },
    );
  }

  void updateQuantityfromSlider() {
    setState(() {
      quantityController.text =
          quantity.toString(); // Update the controller's text
      sendQuantity = quantity;
    });
  }

  void updateWeightfromSlider() {
    setState(() {
      weightController.text = weight.toString(); // Update the controller's text
      sendWeight = weight as int;
    });
  }

  // void currency() {
  //   Locale locale = Localizations.localeOf(context);
  //   var format = NumberFormat.simpleCurrency(locale: locale.toString());
  //   print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
  //   print("CURRENCY NAME ${format.currencyName}"); // USD
  // }

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
    quantity = quantity;
    weightController.text = weight.toString();
    selectedQuantityUnit = selectedQuantityUnit;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
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
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 1200,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 50,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
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
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
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
                                //itemName
                                width: 250,
                                child: TextField(
                                  controller: foodname,
                                  style: FontsTheme.mouseMemoirs_50Black(),
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12)
                                  ],
                                  decoration: InputDecoration(
                                      hintStyle:
                                          FontsTheme.mouseMemoirs_50Black(),
                                      hintText: 'Food name'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        //buildDropdownField('Categories', "value", Icons.local_dining),
                        buildCategoriesField(
                            "Categories", "value", Icons.arrow_drop_down),
                        buildWhereField('Add to', 'value', Icons.kitchen),
                        buildDateField('Expiration date', ''),
                        buildReminderField('30 April 2024'),
                        buildQuantityWeight(),
                        buildEachPieceField(),
                        //buildCostField(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Container(
                                //   width: 120,
                                //   child: ElevatedButton(
                                //     onPressed: () => {},
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: AppTheme.softBlue,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(10)),
                                //     ),
                                //     child: Text(
                                //       'Previous',
                                //       style: FontsTheme.mouseMemoirs_30Black()
                                //           .copyWith(color: Colors.black),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),

                            // ElevatedButton(
                            //   onPressed: () async {},
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: AppTheme.softBlue,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10)),
                            //   ),
                            //   child: Text(
                            //     'Next',
                            //     style: FontsTheme.mouseMemoirs_30Black()
                            //         .copyWith(color: Colors.black),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                        Align(
                          child: Center(
                            child: Container(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (isCountable == true) {
                                      String foodName = foodname.text;
                                      //int category = selectedCategoryIndex;
                                      //String location = selectedLocation;
                                      AddFood addNewFood = AddFood(
                                        food_name: foodName,

                                        img: _image != null
                                            ? base64Encode(
                                                _image!.file.readAsBytesSync())
                                            : '',
                                        location: selectedLocationIndex + 1,
                                        food_category:
                                            selectedCategoryIndex + 1,
                                        isCountable: isCountable,

                                        weight_type: selectedWeightUnit + 1,
                                        package_type: selectedQuantityUnit + 1,

                                        current_amount: 4,
                                        total_amount: sendWeight,
                                        consumed_amount: 2,
                                        current_quantity: 3,
                                        total_quanitity: sendQuantity,
                                        consumed_quantity: 4,
                                        total_price: allCost,
                                        bestByDate: expirationDate,

                                        RemindDate: reminderDate,
                                        // foodName: foodName,
                                        // category: selectedCategoryIndex,
                                        // location: selectedLocationIndex,
                                        // expired: expirationDate,
                                        // remind: reminderDate,
                                        // totalCost: allCost,
                                        // individualWeight: weightDouble,
                                        // individualCost: costPerPiece,
                                        // remaining: "remaining",
                                        // url: _image != null
                                        //     ? base64Encode(
                                        //         _image!.file.readAsBytesSync())
                                        //     : '',
                                        // isCountable: isCountable,

                                        // package_type: selectedQuantityUnit,
                                        // weight_type: selectedWeightUnit,
                                        // // current_amount: current_amount,
                                        // // consumed_amount: null,
                                        // // current_quantity: null,
                                        // mimetype: 'jpeg',
                                      );
                                      try {
                                        await addFoodAPI.addFood(
                                          addNewFood,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Food added successfully!',
                                              style: FontsTheme.hindBold_20(),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor:
                                                AppTheme.greenMainTheme,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to add food: $e',
                                              style: FontsTheme.hindBold_20(),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor:
                                                AppTheme.greenMainTheme,
                                          ),
                                        );
                                      }
                                    } else {
                                      String foodName = foodname.text;
                                      //int category = selectedCategoryIndex;
                                      //String location = selectedLocation;
                                      AddFood addNewFood = AddFood(
                                        food_name: foodName,

                                        img: _image != null
                                            ? base64Encode(
                                                _image!.file.readAsBytesSync())
                                            : '',
                                        location: selectedLocationIndex +
                                            1, //to match with back-end 1 or 2 only
                                        food_category: selectedCategoryIndex +
                                            1, //to match with back-end 1 or 2 only
                                        isCountable: isCountable,

                                        weight_type: selectedWeightUnit + 1,
                                        package_type: selectedQuantityUnit + 1,

                                        current_amount: 4,
                                        total_amount: 8,
                                        consumed_amount: 2,
                                        current_quantity: 3,
                                        total_quanitity: 8,
                                        consumed_quantity: 4,
                                        total_price: allCost,
                                        bestByDate: expirationDate,

                                        RemindDate: reminderDate,

                                        //  current_quantity: "remaining",     individualWeight: weightDouble,
                                        //       individualCost: costPerPiece,
                                      );
                                      try {
                                        await addFoodAPI.addFood(addNewFood);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            margin:
                                                EdgeInsets.only(bottom: 300),
                                            content: Text(
                                              'Food added successfully!',
                                              style: FontsTheme.hindBold_20(),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor:
                                                AppTheme.greenMainTheme,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Failed to add food: $e',
                                              style: FontsTheme.hindBold_20(),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor:
                                                AppTheme.greenMainTheme,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.softOrange,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    'Done',
                                    style: FontsTheme.mouseMemoirs_30Black()
                                        .copyWith(color: Colors.black),
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                ],
              ),
            ),
          ],
        ));
  }

  List<String> itemCategory = [
    "Cooked food",
    "Fresh food",
    "Frozen food",
    "Dried food",
    "Instant food"
  ];

  Widget buildCategoriesField(String label, String value, IconData icon) {
    selectedCategory = itemCategory[0];
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                              value: selectedCategory,
                              isExpanded: true,
                              icon: Icon(icon),
                              items: itemCategory.map((String item) {
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
                                    selectedCategory = newValue;
                                    selectedCategoryIndex =
                                        itemCategory.isNotEmpty
                                            ? itemCategory.indexOf(newValue)
                                            : 0;
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

  List<String> itemLocation = [
    "Refrigerator",
    "Pantry",
  ];
  Widget buildWhereField(String label, String value, IconData icon) {
    selectedLocation = itemLocation[0];
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
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
                              value: selectedLocation,
                              isExpanded: true,
                              icon: Icon(icon),
                              items: itemLocation.map((String item) {
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
                                    selectedLocation = newValue;
                                    selectedLocationIndex =
                                        itemLocation.isNotEmpty
                                            ? itemLocation.indexOf(newValue)
                                            : 0;
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
                    Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                        child: Stack(
                          children: [
                            AnimatedAlign(
                              alignment: Alignment(xAlign, 0),
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                width: 300 * 0.5,
                                height: 60,
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppTheme.softGreen,
                                  border: Border.all(
                                      color: AppTheme.greenMainTheme, width: 4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  xAlign = loginAlign;
                                  loginColor = selectedColor;
                                  signInColor = normalColor;
                                  isVisible = true;
                                  isCountable = true;
                                });
                              },
                              child: Align(
                                alignment: Alignment(-1, 0),
                                child: Container(
                                  width: width * 0.5,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Countable',
                                    style: FontsTheme.mouseMemoirs_30Black()
                                        .copyWith(letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  xAlign = signInAlign;
                                  signInColor = selectedColor;
                                  loginColor = normalColor;
                                  isVisible = false;
                                  isCountable = false;
                                });
                              },
                              child: Align(
                                alignment: Alignment(1, 0),
                                child: Container(
                                  width: width * 0.5,
                                  color: Colors.transparent,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Uncountable',
                                    style: FontsTheme.mouseMemoirs_30Black()
                                        .copyWith(letterSpacing: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Quantity',
                                    style: FontsTheme.mouseMemoirs_30Black()),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              child: TextField(
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(),
                                                  controller:
                                                      quantityController,
                                                  style:
                                                      FontsTheme.hindBold_20()),
                                            ),
                                            buildQuantityUnit('')
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SliderTheme(
                                    //   data: SliderTheme.of(context).copyWith(
                                    //     trackHeight: 10.0,
                                    //     thumbShape:
                                    //         SliderComponentShape.noThumb,
                                    //     overlayShape: RoundSliderOverlayShape(
                                    //         overlayRadius: 24.0),
                                    //     activeTrackColor: Colors.orange,
                                    //     inactiveTrackColor: Colors.orange[100],
                                    //     thumbColor: Colors.white,
                                    //     overlayColor:
                                    //         Colors.orange.withAlpha(32),
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
                              ],
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
                                onChanged: (valueQuantity) => setState(() {
                                  quantity = valueQuantity.toInt();
                                  _updateAllCost();
                                  consumeQuantity = quantity;
                                  updateQuantityfromSlider();
                                }),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    //Weight
                    Column(
                      children: [
                        Row(
                          children: [
                            Text('Weight',
                                style: FontsTheme.mouseMemoirs_30Black()),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(),
                                              controller: weightController,
                                              style: FontsTheme.hindBold_20()),
                                        ),
                                        buildWeightUnit('')
                                      ],
                                    ),
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
                                //     value: weightDouble,
                                //     min: 1,
                                //     max: 10000,
                                //     divisions: 10000,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         weightDouble = value;

                                //         weight =
                                //             weightDouble.toStringAsFixed(0);
                                //       });
                                //     },
                                //   ),
                                // ),
                              ],
                            ),
                          ],
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
                            max: 1000,
                            onChanged: (valueWeight) => setState(() {
                              weightDouble = valueWeight;
                              weight = weightDouble.toStringAsFixed(0);
                              updateWeightfromSlider();
                            }),
                          ),
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
    String pieceLabel = quantity == 1 ? "piece" : "pieces";
    String boxLabel = quantity == 1 ? "box" : "boxes";
    String bottleLabel = quantity == 1 ? "bottle" : "bottles";
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
                                selectedQuantityUnit = items.isNotEmpty
                                    ? items.indexOf(newValue)
                                    : 0;
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
    String gram = "gram";
    String kilogram = "kilogram";
    String milliliter = "milliliter";
    if (weight == 1) {
      gram = "gram";
      kilogram = "kilogram";
      milliliter = "milliliter";
    } else if (weightDouble > 1) {
      gram = "grams";
      kilogram = "kilograms";
      milliliter = "milliliters";
    }
    List<String> items = [gram, kilogram, milliliter];
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
                      width: 120,
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
                                selectedWeightUnit = items.isNotEmpty
                                    ? items.indexOf(newValue)
                                    : 0;
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

  Widget buildEachPieceField() {
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
                                    Text(
                                      '฿',
                                      style: FontsTheme.mouseMemoirs_25(),
                                    ),
                                    Text(
                                      'TH ',
                                      style: FontsTheme.hindBold_20(),
                                    ),
                                    // Icon(Icons.monetization_on_sharp,
                                    //     color: Colors.green),
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
                        visible: isVisible,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
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
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        child: TextField(
                                            decoration: const InputDecoration(
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
                                    Text(
                                      'gram',
                                      style: FontsTheme.hindBold_15(),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 80,
                                          child: TextField(
                                              decoration: const InputDecoration(
                                                labelText: 'Cost',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                if (value.isNotEmpty) {
                                                  setState(() {
                                                    costPerPiece =
                                                        double.tryParse(
                                                                value) ??
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
                                                  text:
                                                      _updateCost().toString()),
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
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectExDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    setState(() {
      expirationDate = picked ?? DateTime.now();
    });
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  Future<void> _selectReDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    double updateWeight = weightDouble / quantity;
    return updateWeight.toStringAsFixed(2);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  Future<void> _remaining() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  @override
  void dispose() {
    foodname.dispose();
    super.dispose();
  }
}
