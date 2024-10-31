import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/pages/login_regis.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AuthService _authService = AuthService();
  // late String _email;
  // late String _password;
  // late String _name;

  void _register() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    print("Attempting login with Username: $username, Password: $password");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    print("Username: $username");
    print("Password: $password");
    bool success = await _authService.register(username, email, password);
    print("Registered: $username");
    if (success) {
      // Navigate to login or dashboard page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login_regis()),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final GlobalKey<FormState> _formKeyUser = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKeyEmail = GlobalKey<FormState>();
  // final GlobalKey<FormState> _formKeyPass = GlobalKey<FormState>();

  Widget _buildName() {
    return //Form(
        //key: _formKeyUser,
        // child:
        TextFormField(
      controller: _usernameController,
      style: FontsTheme.hindBold_20(),
      decoration: InputDecoration(
        hintText: 'Enter your user name',
        hintStyle: FontsTheme.hindBold_15(),
        border: InputBorder.none,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your user name';
        }
        return null;
      },
      // onSaved: (String? value) {
      //   _name = value ?? '';
      // },
      //  ),
    );
  }

  Widget _buildEmail() {
    return //Form(
        //key: _formKeyEmail,
        //child:
        TextFormField(
      controller: _emailController,
      style: FontsTheme.hindBold_20(),
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: FontsTheme.hindBold_15(),
        border: InputBorder.none,
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      // onSaved: (String? value) {
      //   _email = value ?? '';
      // },
      //   ),
    );
  }

  Widget _buildPassword() {
    bool _obscureText = true;
    void _togglePasswordVisibility() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return
        //Form(
        //key: _formKeyPass,
        //  child:
        TextFormField(
      controller: _passwordController,
      style: FontsTheme.hindBold_20(),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: FontsTheme.hindBold_15(),
        border: InputBorder.none,
        //  obscureText:  _obscureText,

        // suffixIcon: IconButton(
        //   icon: Icon(
        //     _obscureText ? Icons.visibility : Icons.visibility_off,
        //     color: Colors.grey,
        //   ),
        //   onPressed: _togglePasswordVisibility, // Toggle visibility
        // ),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
      // onSaved: (String? value) {
      //   _password = value ?? '';
      // },
      //    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: AppTheme.softRed,
        foregroundColor: Colors.black,
        textStyle: FontsTheme.hindBold_20());
    final ButtonStyle backButtonStyle = IconButton.styleFrom(
        backgroundColor: AppTheme.greenMainTheme,
        foregroundColor: Colors.white);

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
                  child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      height: 530,
                      decoration: const BoxDecoration(
                        color: AppTheme.softBlue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      child: Center(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Create an Account',
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
                                  'Username',
                                  style: FontsTheme.hindBold_20(),
                                ),
                                Container(
                                  width: 300,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.greenMainTheme),
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppTheme.softGreen,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: _buildName(),

                                  // child: Center(
                                  //   child: TextFormField(
                                  //     controller: _emailController,
                                  //     style: FontsTheme.hindBold_20(),
                                  //     textAlign: TextAlign.center,
                                  //     decoration: InputDecoration(
                                  //       contentPadding:
                                  //           EdgeInsets.symmetric(
                                  //         horizontal: 0,
                                  //       ),
                                  //       hintText:
                                  //           'Enter your Username or Email ',
                                  //       hintStyle:
                                  //           FontsTheme.hind_20(),
                                  //       border: InputBorder.none,
                                  //     ),
                                  //     maxLines: 1,
                                  //   ),
                                  // ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Email',
                                  style: FontsTheme.hindBold_20(),
                                ),
                                Container(
                                  width: 300,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.greenMainTheme),
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppTheme.softGreen,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: _buildEmail(),
                                    // child: TextFormField(
                                    //   controller: _passwordController,
                                    //   style: FontsTheme.hindBold_20(),
                                    //   obscureText:
                                    //       _obscureText, // Toggle password visibility
                                    //   textAlign: TextAlign.center,
                                    //   decoration: InputDecoration(
                                    //     contentPadding:
                                    //         EdgeInsets.symmetric(
                                    //             horizontal: 30,
                                    //             vertical: 0),
                                    //     hintText:
                                    //         'Enter your Email',
                                    //     hintStyle:
                                    //         FontsTheme.hind_20(),
                                    //     border: InputBorder.none,
                                    //     suffixIcon: IconButton(
                                    //       icon: Icon(
                                    //         _obscureText
                                    //             ? Icons.visibility
                                    //             : Icons
                                    //                 .visibility_off,
                                    //         color: Colors.grey,
                                    //       ),
                                    //       onPressed:
                                    //           _togglePasswordVisibility, // Toggle visibility
                                    //     ),
                                    //   ),
                                    // ),
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
                                        color: AppTheme.greenMainTheme),
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppTheme.softGreen,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: _buildPassword(),
                                    // child: TextFormField(
                                    //   controller: _passwordController,
                                    //   style: FontsTheme.hindBold_20(),
                                    //   obscureText:
                                    //       _obscureText, // Toggle password visibility
                                    //   textAlign: TextAlign.center,
                                    //   decoration: InputDecoration(
                                    //     contentPadding:
                                    //         EdgeInsets.symmetric(
                                    //             horizontal: 30,
                                    //             vertical: 0),
                                    //     hintText:
                                    //         'Enter your password',
                                    //     hintStyle:
                                    //         FontsTheme.hind_20(),
                                    //     border: InputBorder.none,
                                    //     suffixIcon: IconButton(
                                    //       icon: Icon(
                                    //         _obscureText
                                    //             ? Icons.visibility
                                    //             : Icons
                                    //                 .visibility_off,
                                    //         color: Colors.grey,
                                    //       ),
                                    //       onPressed:
                                    //           _togglePasswordVisibility, // Toggle visibility
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 55,
                              width: 300,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    _formKey.currentState?.save();
                                    _register();
                                    print(_emailController);
                                    print('ddd');
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: AppTheme.greenMainTheme),
                                  child: Center(
                                    child: Text(
                                      'Create an Account',
                                      style: FontsTheme.hindBold_30()
                                          .copyWith(color: Colors.black),
                                    ),
                                  )),
                            ),
                            // Add
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

                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                // Navigate to another page (replace 'AnotherPage' with your actual page name)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => login_regis()),
                                );
                              },
                              child:
                                  Image.asset('assets/images/BackButton.png'),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                ],
              ))),
        ],
      ),
      // body: SafeArea(
      //   child: Center(
      //     child: SingleChildScrollView(
      //       child: Form(
      //         key: _formKey,
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               "Food Hero",
      //               style: FontsTheme.mouseMemoirs_64Black(
      //                   // fontSize: isKeyboardOpen ? 0 : 64
      //                   ),
      //             ),
      //             const SizedBox(
      //               height: 20,
      //             ),
      //             Image.asset(
      //               'assets/images/fhlogo.png',
      //               height: isKeyboardOpen ? 0 : 150,
      //               width: isKeyboardOpen ? 0 : 150,
      //             ),
      //             const SizedBox(
      //               height: 20,
      //             ),
      //             Container(
      //               padding: const EdgeInsets.symmetric(horizontal: 24),
      //               width: screenWidth,
      //               height: screenHeight * 0.6,
      //               decoration: const BoxDecoration(
      //                 color: AppTheme.softBlue,
      //                 borderRadius: BorderRadius.only(
      //                   topLeft: Radius.circular(30),
      //                   topRight: Radius.circular(30),
      //                 ),
      //               ),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Column(
      //                     children: [
      //                       _buildName(),
      //                       _buildEmail(),
      //                       _buildPassword(),
      //                     ],
      //                   ),
      //                   ElevatedButton(
      //                     onPressed: () {
      //                       if (!_formKey.currentState!.validate()) {
      //                         return;
      //                       }
      //                       _formKey.currentState?.save();
      //                       // print(_name);
      //                       // print(_email);
      //                       // print(_password);

      //                       _register();
      //                     },
      //                     style: buttonStyle,
      //                     child: const Text("Register"),
      //                   ),
      //                   if (!isKeyboardOpen)
      //                     IconButton(
      //                       onPressed: () => context.push('/inter_org'),
      //                       icon: const Icon(Icons.arrow_back_ios_new),
      //                       style: backButtonStyle,
      //                     ),
      //                 ],
      //               ),
      //             )
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
