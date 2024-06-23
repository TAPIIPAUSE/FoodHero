import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: AppTheme.lightGreen.primaryColor, //!
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Food Hero",
                style: TextStyle(), //!
              ),
              Image.network(
                'https://i.pinimg.com/564x/d1/ed/60/d1ed607602fa36a4f40873cd3d2bbf5d.jpg',
                height: isKeyboardOpen ? 50 : 100,
                width: isKeyboardOpen ? 50 : 100,
              ),
              Container(
                padding: const EdgeInsets.all(24),
                // color: Colors.amber,
                width: screenWidth * 1.0, // 100% of screen width
                height: screenHeight * 0.5, // 50% of screen height
                decoration: BoxDecoration(
                  color: AppTheme.softBlue.primaryColor, // Background color
                  borderRadius: const BorderRadius.only(
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
                    // const SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState?.save();
                        print(_name);
                        print(_email);
                        print(_password);

                        context.go('/inventory'); //! Navigate to the home route
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                    if (!isKeyboardOpen)
                      IconButton(
                        onPressed: () => context.go('/inventory'),
                        icon: const Icon(Icons.arrow_back),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    // const Scaffold(
    //   backgroundColor: Color.fromRGBO(197, 255, 245, 100),
    //   body: Text("Register"),
    // );
  }
}
