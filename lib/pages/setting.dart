import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:go_router/go_router.dart';

class UserSetting extends StatelessWidget {
  UserSetting({super.key});
  final ButtonStyle backButtonStyle = IconButton.styleFrom(
      backgroundColor: AppTheme.greenMainTheme, foregroundColor: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        title: const Text("Setting"),
        centerTitle: true,
        backgroundColor: AppTheme.greenMainTheme,
        titleTextStyle: FontsTheme.mouseMemoirs_64White(),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    _buildSettingItem(context, "/", "Terms and conditions"),
                    _buildSettingItem(context, "/", "Privacy policy"),
                    _buildSettingItem(context, "/", "About"),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () => context.push('/user_profile'),
              icon: const Icon(Icons.arrow_back_ios_new),
              style: backButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSettingItem(BuildContext context, String path, String title) {
  final screenWidth = MediaQuery.of(context).size.width;
  return Column(
    children: [
      GestureDetector(
        onTap: () {
          context.push(path);
        },
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppTheme.greenMainTheme,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(title),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}
