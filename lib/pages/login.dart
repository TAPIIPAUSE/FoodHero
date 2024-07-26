import 'package:flutter/material.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              left: -1,
              top: 0,
              child: Container(
                width: 412,
                height: 823,
                decoration: BoxDecoration(
                  color: AppTheme.greenMainTheme, // Example color usage
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 21, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(3.9, 0, 0, 311),
                    child: Text(
                      'Food Hero',
                      style: FontsTheme.mouseMemoirs_64Black(
                        fontWeight: FontWeight.w400,
                        fontSize: 64,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.softOrange, // Example color usage
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 101, 0, 216.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF43BDAE)),
                              borderRadius: BorderRadius.circular(40),
                              color: Color(0xFFCAFFC9),
                            ),
                            child: Container(
                              width: 300,
                              padding: EdgeInsets.fromLTRB(1, 4, 0, 2.7),
                              child: Text(
                                'Log in',
                                style: FontsTheme.hindBold_15(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFCAFFC9)),
                              borderRadius: BorderRadius.circular(40),
                              color: Color(0xFF3667BB),
                            ),
                            child: Container(
                              width: 300,
                              padding: EdgeInsets.fromLTRB(0.8, 5.3, 0, 1.5),
                              child: Text(
                                'Create Account',
                                style: FontsTheme.hindBold_15(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
