import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/noti_list.dart';
import 'package:go_router/go_router.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ButtonStyle backButtonStyle = IconButton.styleFrom(
      backgroundColor: AppTheme.greenMainTheme, foregroundColor: Colors.white);
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {'message': 'Mom joined the household', 'date': '2023-12-12'},
      {'message': 'Dad joined the household', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'Mom joined the household', 'date': '2023-12-12'},
      {'message': 'Dad joined the household', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
      {'message': 'test', 'date': '2023-12-12'},
    ];
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        title: const Text("Notification"),
        centerTitle: true,
        backgroundColor: AppTheme.greenMainTheme,
        titleTextStyle: FontsTheme.mouseMemoirs_64Black(color: Colors.white),
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
                    for (var notification in notifications)
                      NotiList(
                        message: notification['message'],
                        date: DateTime.parse(notification['date']),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: () => context.push('/inventory/All food'),
              icon: const Icon(Icons.arrow_back_ios_new),
              style: backButtonStyle,
            ),
          ),
        ],
      ),
    );
  }
}
