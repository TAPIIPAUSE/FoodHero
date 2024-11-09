import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/House&Orga/Join_org.dart';
import 'package:foodhero/pages/api/createAndjoinHousehold.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/theme.dart';

class JoinHH extends StatefulWidget {
  const JoinHH({super.key});

  @override
  _JoinHHState createState() => _JoinHHState();
}

class _JoinHHState extends State<JoinHH> {
  final TextEditingController _creatHHController = TextEditingController();
  final TextEditingController _joinHHController = TextEditingController();

  bool _isCreateHH = false;
  void _createHousehold() async {
    if (_isCreateHH) return; // Prevents multiple submissions
    _isCreateHH = true;

    String householdName = _creatHHController.text;

    // Show loading indicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (householdName.isNotEmpty) {
        bool success =
            await CreateAndJoinHousehold().createHousehold(householdName);

        Navigator.of(context).pop(); // Close the loading indicator

        if (success) {
          print("Create hh: $householdName");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>JoinOrg()),
          );
        } else {
          // Show message if household name is already taken
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Household name already taken. Please choose another name.')));
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a household name')));
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("Error: $e");
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create Household failed: $e')),
      );
    } finally {
      _isCreateHH = false;
    }
    // _isCreateHH = false;
  }

  // final TextEditingController _searchController = TextEditingController();

  bool _isJoinHH = false;
  void _joinHousehold() async {
    if (_isJoinHH) return; // Prevents multiple submissions
    _isJoinHH = true;

    String householdName = _joinHHController.text;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (householdName.isNotEmpty) {
        bool success =
            await CreateAndJoinHousehold().joinHousehold(householdName);

        Navigator.of(context).pop(); // Close the loading indicator
        if (success) {
          print("Join hh: $householdName");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Inventory(
                initialFoodCategory: 'all food',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Household not found')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a household name')));
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("Error: $e");
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Join Household failed: $e')),
      );
    }

    _isJoinHH = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.greenMainTheme,
        toolbarHeight: 90,
        centerTitle: true,
        title: const Text('Join'),
        titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.person),
        //   onPressed: () {},
        // ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.95,
            height: screenHight * 0.3,
            padding: EdgeInsets.symmetric(vertical: 25),
            decoration: const BoxDecoration(
              color: AppTheme.softYellow,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.softBrightGreen,
                  width: 2,
                ),
                top: BorderSide(
                  color: AppTheme.softBrightGreen,
                  width: 2,
                ),
                left: BorderSide(
                  color: AppTheme.softBrightGreen,
                  width: 2,
                ),
                right: BorderSide(
                  color: AppTheme.softBrightGreen,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "🏡",
                  style: TextStyle(fontSize: 64),
                ),
                Text(
                  "Household",
                  style: FontsTheme.mouseMemoirs_40(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () => createHouse(context),
                style: TextButton.styleFrom(
                    backgroundColor: AppTheme.greenMainTheme,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(150, 50)),
                child: const Text('Create'),
              ),
              TextButton(
                onPressed: () => joinHouse(context),
                style: TextButton.styleFrom(
                    backgroundColor: AppTheme.greenMainTheme,
                    foregroundColor: Colors.white,
                    fixedSize: const Size(150, 50)),
                child: const Text('Join'),
              ),
            ],
          ),
          // Row(
          // children: [
          // SizedBox(
          //   width: 100,
          //   height: 50,
          //   child: TextButton(
          //     onPressed: () => CreateHouse(context),
          //     style: TextButton.styleFrom(
          //         backgroundColor: AppTheme.greenMainTheme,
          //         foregroundColor: Colors.white),
          //     child: const Text('Create'),
          //   ),
          // ),
          // const SizedBox(
          //   width: 50,
          // ),
          // SizedBox(
          //   width: 100,
          //   height: 50,
          //   child: TextButton(
          //     onPressed: () => JoinHouse(context),
          //     style: TextButton.styleFrom(
          //         backgroundColor: AppTheme.mainBlue,
          //         foregroundColor: Colors.white),
          //     child: const Text(
          //       'Join',
          //     ),
          //   ),
          // ),
          // ],
          // ),

          // Row(
          //   children: [
          //     SizedBox(
          //       width: 100,
          //       height: 50,
          //       child: TextButton(
          //         onPressed: () => CreateOrga(context),
          //         style: TextButton.styleFrom(
          //             backgroundColor: AppTheme.greenMainTheme,
          //             foregroundColor: Colors.white),
          //         child: const Text('Create'),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 50,
          //     ),
          //     SizedBox(
          //       width: 100,
          //       height: 50,
          //       child: TextButton(
          //         onPressed: () => JoinOrga(context),
          //         style: TextButton.styleFrom(
          //             backgroundColor: AppTheme.mainBlue,
          //             foregroundColor: Colors.white),
          //         child: const Text('Join'),
          //       ),
          //     ),
          //   ],
          // )

          // Members section
        ],
      ),
    );
  }

  void createHouse(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppTheme.softBlue,
          title: const Text("Create Household"),
          titleTextStyle:
              FontsTheme.mouseMemoirs_40().copyWith(color: Colors.black),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _creatHHController,
                    decoration: const InputDecoration(
                      labelText: "Household name",
                      icon: Icon(Icons.password_rounded),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a household name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.greenMainTheme,
                  foregroundColor: Colors.white),
              onPressed: () async {
                _createHousehold();
                print("click create household");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => household(),
                //   ),
                // );
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void joinHouse(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppTheme.softBlue,
          title: const Text("Join Household"),
          titleTextStyle:
              FontsTheme.mouseMemoirs_40().copyWith(color: Colors.black),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _joinHHController,
                    decoration: const InputDecoration(
                      labelText: "Household name",
                      icon: Icon(Icons.password_rounded),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a household name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.mainBlue,
                  foregroundColor: Colors.white),
              onPressed: () async {
                _joinHousehold();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => household(),
                //   ),
                // );
              },
              child: const Text("Join"),
            ),
          ],
        );
      },
    );
  }
}
