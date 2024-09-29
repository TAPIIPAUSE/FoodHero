import 'package:flutter/material.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    print("Login button tapped"); // Should show in console when you tap

    String username = _emailController.text;
    String password = _passwordController.text;

    //log
    print("Attempting login with Username: $username, Password: $password");

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    print("Login button tapped");
    print("Username: $username");
    print("Password: $password");
    bool success = await _authService.login(username, password);

    // Navigator.of(context).pop(); // Remove loading indicator

    if (success) {
      // Navigate to inventory
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Inventory(initialFoodCategory: 'all food')),
      );
      print('login succesful');
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  // Future<void> saveToken(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_token', token);
  // }

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
                  padding: const EdgeInsets.only(top: 350),
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Login',
                              style: FontsTheme.mouseMemoirs_40()
                                  .copyWith(fontSize: 50),
                            ),
                            const SizedBox(
                              height: 5,
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
                                  controller: _emailController,
                                  style: FontsTheme.hindBold_30(),
                                  scrollPadding: EdgeInsets.only(bottom: 100),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your email ',
                                    hintStyle: FontsTheme.hind_20(),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Password',
                              style: FontsTheme.hindBold_20(),
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
                                  controller: _passwordController,
                                  style: FontsTheme.hindBold_30(),
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    hintStyle: FontsTheme.hind_20(),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 55,
                              width: 250,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _login();
                                    print(_emailController);
                                    print('ddd');
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: AppTheme.greenMainTheme),
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: FontsTheme.hindBold_30()
                                          .copyWith(color: Colors.black),
                                    ),
                                  )),
                            )
                          ],
                        ), // Add
                        SizedBox(height: 10),

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
