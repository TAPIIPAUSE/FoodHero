import 'package:flutter/material.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.lightGreenBackground,
          toolbarHeight: 90,
          centerTitle: true,
          title: Text(
            "Food Hero",
            style: FontsTheme.mouseMemoirs_64Black(),
          ),
          automaticallyImplyLeading: false, //hide back button
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/AllFoodsdecoration.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                  'assets/images/FoodHeroLogo.png'), // Adjust the image asset path as needed
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 436,
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                ),
              ),
            ),
            Form(
              child: Padding(
                  padding: const EdgeInsets.only(top: 400),
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Login',
                              style: FontsTheme.hindBold_30(),
                            ),
                            Container(
                              width: 300,
                              height: 55,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.greenMainTheme),
                                borderRadius: BorderRadius.circular(40),
                                color: AppTheme.softGreen,
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                child: TextField(
                                  style: FontsTheme.hindBold_30(),
                                  scrollPadding: EdgeInsets.only(bottom: 100),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email ',
                                    hintStyle: FontsTheme.hind_20(),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
                                ),
                                //     ListView(
                                //   reverse: false,
                                //   children: <Widget>[

                                //   ].reversed.toList(),
                                // )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              'Password',
                              style: FontsTheme.hindBold_30(),
                            ),
                            Container(
                              width: 300,
                              height: 55,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.greenMainTheme),
                                borderRadius: BorderRadius.circular(40),
                                color: AppTheme.softGreen,
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                child: TextField(
                                  style: FontsTheme.hindBold_30(),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    hintStyle: FontsTheme.hind_20(),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), // Add some spacing between the buttons

                        SizedBox(height: 10), //
                        InkWell(
                            onTap: () {
                              // Navigate to another page (replace 'AnotherPage' with your actual page name)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login_regis()),
                              );
                            },
                            child: Text(
                              'Forgot account',
                              style: FontsTheme.hind_15(),
                            )),

                        SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            // Navigate to another page (replace 'AnotherPage' with your actual page name)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login_regis()),
                            );
                          },
                          child: Image.asset('assets/images/BackButton.png'),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
