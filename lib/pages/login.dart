import 'package:flutter/material.dart';
import 'package:foodhero/models/hhorginfo_model.dart';
import 'package:foodhero/models/loginresult.dart';
import 'package:foodhero/pages/House&Orga/Join_hh.dart';
import 'package:foodhero/pages/House&Orga/Join_org.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/pages/inventory/inventory.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  late final int hID;

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  // late Future<HHOrgInfo?> _hhOrgInfoFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _hhOrgInfoFuture = _getHHOrgInfo();
  // }

  // Future<HHOrgInfo?> _getHHOrgInfo() async {
  //   try {
  //     final data = await AuthService().getHHOrgInfo();
  //     print("Fetching HHOrgInfo");
  //     return data;
  //   } catch (e) {
  //     print('Error fetching HHOrgInfo: $e');
  //     rethrow; // Return the error message
  //   }
  // }

  void _login() async {
    print("Login button tapped"); // Should show in console when you tap

    String username = _emailController.text;
    String password = _passwordController.text;

    //log
    print("Attempting login with Username: $username, Password: $password");

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter both username or email and password',
            style: FontsTheme.hind_15().copyWith(color: Colors.black),
          ),
          backgroundColor: AppTheme.greenMainTheme,
        ),
      );
      return;
    }

     // Add loading indicator dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.greenMainTheme),
        ),
      );
    },
  );

    print("Login button tapped");
    print("Username: $username");
    print("Password: $password");
    Loginresult? result = await _authService.login(username, password);

    Navigator.of(context).pop(); // Remove loading indicator

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }
    if (result.success) {
      // context.push('/consumed');
      // Navigate to inventory

      final data = await AuthService().getHHOrgInfo();
      // _hhOrgInfoFuture.then((hhOrgInfo) {
      if (data?.hId == 0) {
        // Navigate to inventory
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JoinHH(),
          ),
        );
      } else if (data?.orgId == 0 && data?.isFamilyLead == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => JoinOrg()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Inventory(
                    initialFoodCategory: 'all food',
                  )),
        );
      }
      // }
      // );

      print('login succesful');
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Future<void> saveToken(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_token', token);
  // }
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
                child: SingleChildScrollView(
                  child: Form(
                      child: Column(
                    children: [
                      SafeArea(
                        child: Container(
                            height: 460,
                            decoration: const BoxDecoration(
                              color: AppTheme.softBlue,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
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
                                      Form(
                                          child: Column(
                                        children: [
                                          Text(
                                            ' Username or Email',
                                            style: FontsTheme.hindBold_20(),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppTheme.greenMainTheme),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: AppTheme.softGreen,
                                            ),
                                            padding: EdgeInsets.all(10.0),
                                            child: Center(
                                              child: TextFormField(
                                                controller: _emailController,
                                                style: FontsTheme.hindBold_20(),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                  ),
                                                  hintText:
                                                      'Enter your Username or Email ',
                                                  hintStyle:
                                                      FontsTheme.hind_20(),
                                                  border: InputBorder.none,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Password',
                                            style: FontsTheme.hindBold_20(),
                                          ),
                                          Container(
                                            width: 300,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      AppTheme.greenMainTheme),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: AppTheme.softGreen,
                                            ),
                                            padding: EdgeInsets.all(10.0),
                                            child: Center(
                                              child: TextFormField(
                                                controller: _passwordController,
                                                style: FontsTheme.hindBold_20(),
                                                obscureText:
                                                    _obscureText, // Toggle password visibility
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                          vertical: 0),
                                                  hintText:
                                                      'Enter your password',
                                                  hintStyle:
                                                      FontsTheme.hind_20(),
                                                  border: InputBorder.none,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _obscureText
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: Colors.grey,
                                                    ),
                                                    onPressed:
                                                        _togglePasswordVisibility, // Toggle visibility
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        height: 55,
                                        width: 250,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              _login();

                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           Inventory(
                                              //             hID: 0,
                                              //           )),
                                              // );
                                              // print(_emailController);
                                              print('login tapped');
                                            },
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppTheme.greenMainTheme),
                                            child: Center(
                                              child: Text(
                                                'Login',
                                                style: FontsTheme.hindBold_30()
                                                    .copyWith(
                                                        color: Colors.black),
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
                                              builder: (context) =>
                                                  login_regis()),
                                        );
                                      },
                                      child: Text(
                                        'Forgot account',
                                        style: FontsTheme.hind_15(),
                                      )),

                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      // Navigate to another page (replace 'AnotherPage' with your actual page name)
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                login_regis()),
                                      );
                                    },
                                    child: Image.asset(
                                        'assets/images/BackButton.png'),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  )),
                )),
          ],
        ));
  }
}
