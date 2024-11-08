import 'package:flutter/material.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/House&Orga/Household/household.dart';
import 'package:foodhero/pages/House&Orga/Organization/organization.dart';
import 'package:foodhero/pages/api/createAndjoinHousehold.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final TextEditingController _creatHHController = TextEditingController();
  final TextEditingController _joinHHController = TextEditingController();
  final TextEditingController _joinOrgController = TextEditingController();
  final TextEditingController _creatOrgController = TextEditingController();

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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => household()));
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
    }
    _isCreateHH = false;
  }

  bool _isCreateOrg = false;
  void _createOrg() async {
    if (_isCreateOrg) return; // Prevents multiple submissions
    _isCreateOrg = true;

    String orgName = _creatOrgController.text;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (orgName.isNotEmpty) {
        bool success = await CreateAndJoinHousehold().createOrg(orgName);
        Navigator.of(context).pop(); // Remove loading indicator
        if (success) {
          print("Create org: $orgName");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => organization(
                      // orgName: orgName,
                      )));
        } else {
          // Show message if household name is already taken
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Organization name already taken. Please choose another name.')),
          );
        }
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please enter a name')));
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("Error: $e");
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create Organization failed: $e')),
      );
    }

    _isCreateOrg = false;
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
      //     'householdId123', 'securepassword123');
      if (householdName.isNotEmpty) {
        bool success =
            await CreateAndJoinHousehold().joinHousehold(householdName);

        Navigator.of(context).pop(); // Close the loading indicator
        if (success) {
          print("Join hh: $householdName");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => household()));
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

  bool _isJoinOrg = false;
  void _joinOrg() async {
    if (_isJoinOrg) return; // Prevents multiple submissions
    _isJoinOrg = true;

    String orgName = _joinOrgController.text;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      if (orgName.isNotEmpty) {
        bool success = await CreateAndJoinHousehold().joinOrg(orgName);
        Navigator.of(context).pop(); // Remove loading indicator
        if (success) {
          print("Join org: $orgName");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => organization(
                      // orgName: orgName,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Organization not found')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a organization Name')));
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      print("Error: $e");
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Join Organization failed: $e')),
      );
    }

    _isJoinOrg = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MainScaffold(
      selectedRouteIndex: 3,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.greenMainTheme,
          toolbarHeight: 90,
          centerTitle: true,
          title: const Text('Join'),
          titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenWidth * 0.95,
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
                    children: [
                      Text(
                        "🏡",
                        style: TextStyle(fontSize: 64),
                      ),
                      Text(
                        "Household",
                        style: FontsTheme.mouseMemoirs_40(),
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: AppTheme.mainBlue,
                      //     foregroundColor: Colors.white,
                      //     minimumSize: Size(100, 50), // Set width and height
                      //   ),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const household()));
                      //   },
                      //   child: const Text(
                      //     "Open",
                      //   ),
                      // ),
                      TextButton(
                        onPressed: () => createHouse(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppTheme.greenMainTheme,
                            foregroundColor: Colors.white),
                        child: const Text('Create'),
                      ),
                      TextButton(
                        onPressed: () => joinHouse(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppTheme.greenMainTheme,
                            foregroundColor: Colors.white),
                        child: const Text('Join'),
                      ),
                    ],
                  ),
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

                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenWidth * 0.95,
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
                    children: [
                      Text(
                        "🏢",
                        style: TextStyle(fontSize: 64),
                      ),
                      Text(
                        "Organization",
                        style: FontsTheme.mouseMemoirs_40(),
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: AppTheme.mainBlue,
                      //     foregroundColor: Colors.white,
                      //     minimumSize: Size(100, 50), // Set width and height
                      //   ),
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const organization()));
                      //   },
                      //   child: const Text("Open"),
                      // ),
                      TextButton(
                        onPressed: () => createOrga(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppTheme.greenMainTheme,
                            foregroundColor: Colors.white),
                        child: const Text('Create'),
                      ),
                      TextButton(
                        onPressed: () => joinOrga(context),
                        style: TextButton.styleFrom(
                            backgroundColor: AppTheme.greenMainTheme,
                            foregroundColor: Colors.white),
                        child: const Text('Join'),
                      ),
                    ],
                  ),
                ),

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
          ),
        ),
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

  void createOrga(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppTheme.softRedBrown,
          title: const Text("Create Organization"),
          titleTextStyle:
              FontsTheme.mouseMemoirs_40().copyWith(color: Colors.black),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _creatOrgController,
                    decoration: const InputDecoration(
                      labelText: "Organization name",
                      icon: Icon(Icons.password_rounded),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a org name';
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
                _createOrg();
                print("click create organization");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => organization(),
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

  void joinOrga(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          backgroundColor: AppTheme.softRedBrown,
          title: const Text("Join Organization"),
          titleTextStyle:
              FontsTheme.mouseMemoirs_40().copyWith(color: Colors.black),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _joinOrgController,
                    decoration: const InputDecoration(
                      labelText: "Organization name",
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
              onPressed: () async{
                _joinOrg();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => organization(),
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
