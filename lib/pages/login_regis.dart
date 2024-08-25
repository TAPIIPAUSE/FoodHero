import 'package:flutter/material.dart';
import 'package:foodhero/pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

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
        body: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/AllFoodsdecoration.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                child: Image.asset(
                    'assets/images/FoodHeroLogo.png'), // Adjust the image asset path as needed
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 436,
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 436,
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 356,
                  height: 267,
                  child: Image.asset(
                    'assets/images/Superfoodhero&background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child:
                            Container(), // Empty container to push the first InkWell to the right
                      ),
                      InkWell(
                        onTap: () {
                          // Navigate to another page (replace 'AnotherPage' with your actual page name)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        child: Container(
                          width: 223,
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.greenMainTheme),
                            borderRadius: BorderRadius.circular(40),
                            color: AppTheme.softGreen,
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Log in',
                              style: GoogleFonts.getFont(
                                'Hind',
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: 20), // Add some spacing between the buttons
                      InkWell(
                        onTap: () {
                          // Navigate to another page (replace 'AnotherPage' with your actual page name)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => login()),
                          );
                        },
                        child: Container(
                          width: 300,
                          height: 54.74,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFCAFFC9)),
                            borderRadius: BorderRadius.circular(40),
                            color: Color(0xFF3667BB),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.getFont(
                                'Hind',
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
