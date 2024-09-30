import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/theme.dart';
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
      Navigator.pushReplacementNamed(context, '/inventory/:foodCategory');
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed')),
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'User name',
        hintText: 'Enter your user name',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
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
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      controller: _emailController,
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
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      // onSaved: (String? value) {
      //   _email = value ?? '';
      // },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
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
      backgroundColor: AppTheme.lightGreenBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Food Hero",
                    style: FontsTheme.mouseMemoirs_64Black(
                        // fontSize: isKeyboardOpen ? 0 : 64
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/fhlogo.png',
                    height: isKeyboardOpen ? 0 : 150,
                    width: isKeyboardOpen ? 0 : 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: screenWidth,
                    height: screenHeight * 0.6,
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            _buildName(),
                            _buildEmail(),
                            _buildPassword(),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            _formKey.currentState?.save();
                            // print(_name);
                            // print(_email);
                            // print(_password);

                            _register();
                          },
                          style: buttonStyle,
                          child: const Text("Register"),
                        ),
                        if (!isKeyboardOpen)
                          IconButton(
                            onPressed: () => context.push('/inter_org'),
                            icon: const Icon(Icons.arrow_back_ios_new),
                            style: backButtonStyle,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
