import 'package:flutter/material.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/House&Orga/Organization/organization.dart';
import 'package:foodhero/pages/api/createAndjoinHousehold.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<join> {
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
          .showSnackBar(SnackBar(content: Text('Please enter a name')));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter a household ID')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      selectedRouteIndex: 3,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.greenMainTheme,
          toolbarHeight: 90,
          centerTitle: true,
          title: Text('Join'),
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
          child: Padding(
              padding: const EdgeInsets.all(80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Household",
                    style: FontsTheme.mouseMemoirs_40(),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextButton(
                          onPressed: () => CreateHouse(context),
                          style: TextButton.styleFrom(
                              backgroundColor: AppTheme.greenMainTheme,
                              foregroundColor: Colors.white),
                          child: Text('Create'),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextButton(
                          onPressed: () => JoinHouse(context),
                          style: TextButton.styleFrom(
                              backgroundColor: AppTheme.mainBlue,
                              foregroundColor: Colors.white),
                          child: Text(
                            'Join',
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 120,
                  ),
                  Text(
                    "Organization",
                    style: FontsTheme.mouseMemoirs_40(),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextButton(
                          onPressed: () => CreateOrga(context),
                          style: TextButton.styleFrom(
                              backgroundColor: AppTheme.greenMainTheme,
                              foregroundColor: Colors.white),
                          child: Text('Create'),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: TextButton(
                          onPressed: () => JoinOrga(context),
                          style: TextButton.styleFrom(
                              backgroundColor: AppTheme.mainBlue,
                              foregroundColor: Colors.white),
                          child: Text('Join'),
                        ),
                      ),
                    ],
                  )

                  // Members section
                ],
              )),
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
              child: const Text("Create"),
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
              child: const Text("Join"),
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
              child: const Text("Create"),
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
