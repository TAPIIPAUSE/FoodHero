import 'package:flutter/material.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/House&Orga/Household/household.dart';
import 'package:foodhero/pages/House&Orga/Organization/organization.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<join> {
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
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Text("Household"),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => household(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: AppTheme.greenMainTheme),
                        child: Text('Join'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Organization"),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => organization(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: AppTheme.mainBlue),
                        child: Text('Join'),
                      ),
                    ),

                    // Members section
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
