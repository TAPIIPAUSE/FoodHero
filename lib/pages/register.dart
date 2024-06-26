import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _email;
  late String _password;
  late String _name;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'User name',
        hintText: 'Enter your user name',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
      ),
      // maxLength: 10,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your user name';
        }
        return null;
      },
      onSaved: (String? value) {
        _name = value ?? '';
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (String? value) {
        _email = value ?? '';
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        //! แปลกๆๆ
        if (!RegExp(r'.{8,}').hasMatch(value)) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
      onSaved: (String? value) {
        _password = value ?? '';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if the keyboard is open
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    final ButtonStyle buttonstyle = ElevatedButton.styleFrom(
        backgroundColor: AppTheme.softRed,
        foregroundColor: Colors.black,
        textStyle: FontsTheme.hindBold_20()); // Text color
    final ButtonStyle backbuttonstyle = IconButton.styleFrom(
        backgroundColor: AppTheme.greenMainTheme,
        foregroundColor: Colors.white); // Text color

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground, //!
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Food Hero",
                  style: FontsTheme.mouseMemoirs_64(
                      fontSize: isKeyboardOpen ? 0 : 64), //!app name
                ),
                Image.asset(
                  'assets/fhlogo.png',
                  height: isKeyboardOpen ? 0 : 150,
                  width: isKeyboardOpen ? 0 : 150,
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  width: screenWidth * 1.0, // 100% of screen width
                  height: screenHeight * 0.6, // 50% of screen height
                  decoration: const BoxDecoration(
                    color: AppTheme.softBlue, // Background color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ), // Set rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildName(),
                      _buildEmail(),
                      _buildPassword(),
                      ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState?.save();
                          print(_name);
                          print(_email);
                          print(_password);

                          context.go('/inventory'); //! Navigate to the ???
                        },
                        style: buttonstyle,
                        child: const Text(
                          "Register",
                        ),
                      ),
                      if (!isKeyboardOpen)
                        IconButton(
                            onPressed: () => context
                                .go('/inventory'), //! Navigate to the ???
                            icon: const Icon(Icons.arrow_back_ios_new),
                            style: backbuttonstyle),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
