import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
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
  int quantity = 8;
  double weight = 400; // in grams
  double costPerPiece = 20;
  double totalCost = 160;

  ImageProvider? _image; // Image provider for the selected image
  bool _isLoading = false; // Flag to indicate image loading state
  bool _chooseImageOption = false;

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
      _chooseImageOption = !_chooseImageOption;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                Container(
                  // add name
                  width: 250,
                  height: 50,
                  margin: const EdgeInsets.only(
                      left: 4, right: 4, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.greenMainTheme),
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        itemName = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Categories', style: FontsTheme.mouseMemoirs_30()),
            DropdownButtonFormField<String>(
              value: category,
              items: ['Fresh Food', 'Frozen Food', 'Pantry']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Add to', style: FontsTheme.mouseMemoirs_30()),
            SizedBox(height: 16),
            Container(
              height: 70,
              child: DropdownButtonFormField<String>(
                value: storageLocation,
                items: [
                  DropdownMenuItem(
                    value: 'Refrigerator',
                    child: Text(
                      'Refrigerator',
                      style: FontsTheme.mouseMemoirs_20(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Freezer',
                    child: Text(
                      'Freezer',
                      style: FontsTheme.mouseMemoirs_20(),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Pantry',
                    child: Text(
                      'Pantry',
                      style: FontsTheme.mouseMemoirs_20(),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    storageLocation = value!;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0), // Adjust padding here
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                  'Expiration date: ${expirationDate.toLocal().toString().split(' ')[0]}',
                  style: FontsTheme.hind_20()),
              trailing: Icon(Icons.calendar_month_rounded),
              onTap: _selectDate,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Quantity: ',
                  style: FontsTheme.mouseMemoirs_30(),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10.0,
                    thumbShape: SliderComponentShape.noThumb,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                    activeTrackColor: Colors.orange,
                    inactiveTrackColor: Colors.orange[100],
                    thumbColor: Colors.white,
                    overlayColor: Colors.orange.withAlpha(32),
                  ),
                  child: Slider(
                    value: quantity.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 99,
                    label: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = value.toInt();
                        _updateTotalCost();
                      });
                    },
                  ),
                ),
                Text(
                  '$quantity Pieces',
                  style: FontsTheme.hind_20(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Weight: ',
                  style: FontsTheme.mouseMemoirs_30(),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10.0,
                    thumbShape: SliderComponentShape.noThumb,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
                    activeTrackColor: Colors.orange,
                    inactiveTrackColor: Colors.orange[100],
                    thumbColor: Colors.white,
                    overlayColor: Colors.orange.withAlpha(32),
                  ),
                  child: Slider(
                    value: weight,
                    min: 50,
                    max: 3000,
                    divisions: 99,
                    label: weight.toString(),
                    onChanged: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ),
                ),
                Text('${weight.toInt()} grams', style: FontsTheme.hind_20()),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Each piece: ',
                  style: FontsTheme.mouseMemoirs_30(),
                ),
                Spacer(),
                Container( // make automatically and edit button for tell user that can edit
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Weight (g)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        costPerPiece = double.tryParse(value) ?? costPerPiece;
                        _updateTotalCost();
                      });
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cost (\$)',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        costPerPiece = double.tryParse(value) ?? costPerPiece;
                        _updateTotalCost();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'All cost: ',
                  style: FontsTheme.mouseMemoirs_30(),
                ),
                Spacer(),
                Text('\$${totalCost.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Done'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateTotalCost() {
    setState(() {
      totalCost = quantity * costPerPiece; 
    });
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
