import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/House&Orga/Household/household.dart';
import 'package:foodhero/pages/House&Orga/Organization/organization.dart';
import 'package:foodhero/theme.dart';

class HHOrg extends StatefulWidget {
  const HHOrg({super.key});

  @override
  _HHOrgState createState() => _HHOrgState();
}

class _HHOrgState extends State<HHOrg> {
  // final TextEditingController _nameController = TextEditingController();

  // final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return MainScaffold(
      selectedRouteIndex: 3,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.greenMainTheme,
          toolbarHeight: 90,
          centerTitle: true,
          title: const Text('House & Org'),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(
              //   height: 10,
              // ),
              Container(
                width: screenWidth * 0.95,
                height: screenHeight * 0.3,
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
              Container(
                width: screenWidth * 0.95,
                height: screenHeight * 0.3,
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
            ],
          ),
        ),
      ),
    );
  }
}
