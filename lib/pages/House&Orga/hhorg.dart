import 'package:flutter/material.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/House&Orga/Household/household.dart';
import 'package:foodhero/pages/House&Orga/Organization/organization.dart';
import 'package:foodhero/pages/api/createAndjoinHousehold.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class HHOrg extends StatefulWidget {
  const HHOrg({super.key});

  @override
  _HHOrgState createState() => _HHOrgState();
}

class _HHOrgState extends State<HHOrg> {
  final TextEditingController _nameController = TextEditingController();

// Example usage
  void _createHousehold() async {
    String householdName = _nameController.text;

    // bool success = await householdService.createHousehold(
    //     'My Household', 'securepassword123');
    if (householdName.isNotEmpty) {
      await createHousehold(householdName);
      // Handle successful creation
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a name')));
    }
  }

  final TextEditingController _searchController = TextEditingController();

  void _joinHousehold() async {
    String householdId = _searchController.text;
    // bool success = await householdService.joinHousehold(
    //     'householdId123', 'securepassword123');
    if (householdId.isNotEmpty) {
      await joinHousehold(householdId);
      // Handle successful joining
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a household ID')));
    }
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
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.mainBlue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 50), // Set width and height
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const household()));
                        },
                        child: const Text(
                          "Open",
                        ),
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
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.mainBlue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(100, 50), // Set width and height
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const organization()));
                        },
                        child: const Text("Open"),
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

  void CreateHouse(BuildContext context) {
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
                    decoration: const InputDecoration(
                      labelText: "Household name",
                      icon: Icon(Icons.password_rounded),
                    ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => household(),
                  ),
                );
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void JoinHouse(BuildContext context) {
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
                    decoration: const InputDecoration(
                      labelText: "Household name",
                      icon: Icon(Icons.password_rounded),
                    ),
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
              onPressed: () {
                _joinHousehold;
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

  void CreateOrga(BuildContext context) {
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
                    decoration: const InputDecoration(
                      labelText: "Organization name",
                      icon: Icon(Icons.password_rounded),
                    ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => organization(),
                  ),
                );
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void JoinOrga(BuildContext context) {
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
                    decoration: const InputDecoration(
                      labelText: "Organization name",
                      icon: Icon(Icons.password_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Join"),
              style: TextButton.styleFrom(
                  backgroundColor: AppTheme.mainBlue,
                  foregroundColor: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => organization(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
