import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/hist_list.dart';
import 'package:go_router/go_router.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final ButtonStyle backButtonStyle = IconButton.styleFrom(
      backgroundColor: AppTheme.greenMainTheme, foregroundColor: Colors.white);
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historys = [
      {
        'message': 'Banana was added to the inventory',
        'dateTime': '2023-12-12 12:00:00',
      },
      {
        'message': 'Apple was retrieved from the inventory',
        'dateTime': '2023-12-12 14:30:00',
      },
      {
        'message': 'Yogurt was expired',
        'dateTime': '2023-12-12 15:45:00',
      },
    ];
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        title: const Text("Item history"),
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
                    for (var history in historys)
                      HistoryList(
                        message: history['message'],
                        date: DateTime.parse(history['dateTime']),
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
