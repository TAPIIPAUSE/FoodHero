import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:go_router/go_router.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
  });
  static const String username = "username";
  static const String userid = "123";
  static const String userpoint = "123456789";
  static const String usersave = "123456789";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final ButtonStyle buttonStyle = IconButton.styleFrom(
        backgroundColor: AppTheme.greenMainTheme,
        foregroundColor: Colors.white);

    return Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: AppTheme.greenMainTheme,
            child: Column(
              children: [
                AppBar(
                    title: const Text(username),
                    centerTitle: true,
                    backgroundColor: AppTheme.greenMainTheme,
                    titleTextStyle: FontsTheme.mouseMemoirs_64White(),
                    automaticallyImplyLeading: false),
                Text("#$userid", style: FontsTheme.mouseMemoirs_20()),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: screenWidth * 0.9,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: screenWidth * 0.5,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: AppTheme.softBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("id : $userid"),
                                const Text("name : $username"),
                                Center(
                                    child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Edit profile"),
                                )),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: AppTheme.softBlue,
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.softBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Column(
                                  children: [
                                    Text(userpoint == "0" ? "0" : userpoint),
                                    Text(userpoint == "0" ? "point" : "points"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.softBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: const Column(
                                  children: [
                                    Text(usersave == "0"
                                        ? "0 ฿"
                                        : "$usersave ฿"),
                                    Text("save"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screenWidth * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonBar(
                        buttonPadding: const EdgeInsets.all(10),
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push('/history');
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppTheme.softBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(child: Text("History")),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push('/setting');
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppTheme.softBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Center(child: Text("Setting")),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.softBlue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Heatmap calendar"),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HeatMapChart(),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/user_dashboard'),
                      style: buttonStyle,
                      child: const Text("see more"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
