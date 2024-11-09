import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:foodhero/models/addfood_model.dart';
import 'package:foodhero/pages/api/ApiUserFood.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/widgets/cameraScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:interactive_slider/interactive_slider.dart';
//import 'package:intl/intl.dart';

List<CameraDescription> cameras = [];
// Check if the list is not empty before accessing

Future<void> main() async {
  try {
    cameras = await availableCameras(); //get available caameras
    if (cameras.isEmpty) {
      print('No cameras available');
      return; // Exit if no cameras are found
    }
  } catch (e) {
    print('Error retrieving cameras: $e');
    return; // Handle error appropriately
  }
  runApp(addFoodDetails());
}

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
  int weightInt = 1;
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

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Process the selected file
      print('File selected: ${result.files.single.name}');
    } else {
      // User canceled the picker
      print('No file selected');
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
          child: Center(
            child: Stack(alignment: Alignment.center, children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 0.4,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.mainBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.softBlue,
                        fixedSize: Size(100, 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Image.asset('assets/images/CaameraaIcon.png'),
                          SizedBox(height: 20),
                          Text(
                            'Take',
                            style: FontsTheme.hindBold_20(),
                          ),
                          Text(
                            'Photo',
                            style: FontsTheme.hindBold_20(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add spacing between buttons
                    TextButton(
                      onPressed: _pickImage,
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.softBlue,
                        fixedSize: Size(100, 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Image.asset('assets/images/Photo.png'),
                          SizedBox(height: 20),
                          Text(
                            'Choose',
                            style: FontsTheme.hindBold_20(),
                          ),
                          Text(
                            'Photo',
                            style: FontsTheme.hindBold_20(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Add spacing between buttons
                    TextButton(
                      onPressed: _pickFile,
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.softBlue,
                        fixedSize: Size(100, 130),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Image.asset('assets/images/FileIcon.png'),
                          SizedBox(height: 20),
                          Text(
                            'Choose',
                            style: FontsTheme.hindBold_20(),
                          ),
                          Text(
                            'File',
                            style: FontsTheme.hindBold_20(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
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
    weight = weight;
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
                                    ? Center(
                                        child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ))
                                    : _isLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
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
    "Cooked Food",
    "Fresh Ingredients",
    "Frozen Food",
    "Dried Ingredients",
    "Instant Food"
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
                        width: 215,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                    title: Text(
                        '${expirationDate.toLocal().toString().split(' ')[0]}',
                        style: FontsTheme.hindBold_20()),
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
                    title: Text(
                        '${reminderDate.toLocal().toString().split(' ')[0]}',
                        style: FontsTheme.hindBold_20()),
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
                                  width: 40,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 245,
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
                                          SizedBox(
                                            width: 80,
                                            child: TextField(
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(),
                                                controller: quantityController,
                                                style:
                                                    FontsTheme.hindBold_20()),
                                          ),
                                          buildQuantityUnit('')
                                        ],
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
                              width: 55,
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 245,
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
    String gram = weightDouble == 1 ? "Gram" : "Grams";
    String kilogram = weightDouble == 1 ? "Kilogram" : "Kilograms";
    String milliliter = weightDouble == 1 ? "Milliliter" : "Milliliters";
    String liter = weightDouble == 1 ? "Liter" : "Liters";
    // if (weightDouble == 1.0) {
    //   gram = "Gram";
    //   kilogram = "Kilogram";
    //   milliliter = "Milliliter";
    // } else if (weightDouble > 1.0) {
    //   gram = "Grams";
    //   kilogram = "Kilograms";
    //   milliliter = "Milliliters";
    // }
    List<String> items = [gram, kilogram, milliliter, liter];
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
                                    Text('All Cost',
                                        style:
                                            FontsTheme.mouseMemoirs_30Black()),
                                    SizedBox(width: 20),
                                    SizedBox(
                                      width: 100,
                                      child: TextField(
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
                                      width: 50,
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
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 60,
                                      child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Weight',
                                            labelStyle:
                                                FontsTheme.hindBold_20(),
                                            border: InputBorder.none,
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
                                  // Text(
                                  //   'grams',
                                  //   style: FontsTheme.hindBold_15(),
                                  // )
                                ],
                              ),
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
                                            decoration: InputDecoration(
                                              labelText: 'Cost',
                                              labelStyle:
                                                  FontsTheme.hindBold_20(),
                                              border: InputBorder.none,
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

                                    Text(
                                      '฿',
                                      style: FontsTheme.mouseMemoirs_25(),
                                    ),
                                    Text(
                                      'TH ',
                                      style: FontsTheme.hindBold_20(),
                                    ),
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
