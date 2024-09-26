import 'package:flutter/material.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/pages/login.dart';
import 'package:foodhero/pages/register.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_regis extends StatelessWidget {
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 436,
              decoration: const BoxDecoration(
                color: AppTheme.softBlue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 356,
              height: 267,
              child: Image.asset(
                'assets/images/Superfoodhero&background.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 565, left: 60),
              child: Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Container(
                        width: 200,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.greenMainTheme),
                          borderRadius: BorderRadius.circular(40),
                          color: AppTheme.softGreen,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child:
                              Text('Log in', style: FontsTheme.hindBold_30()),
                        ),
                      ),
                    ),

                    SizedBox(
                        height: 10), // Add some spacing between the buttons
                    InkWell(
                      onTap: () {
                        // Navigate to another page (replace 'AnotherPage' with your actual page name)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Container(
                        width: 250,
                        height: 54.74,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.greenMainTheme),
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFF3667BB),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text('Create Account',
                              style: FontsTheme.hindBold_30()
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
        // ),
      ),
    );
  }
}
