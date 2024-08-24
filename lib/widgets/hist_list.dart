import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({
    super.key,
    required this.message,
    required this.date,
  });
  final String message;
  final DateTime date;
  // final DateTime time;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(children: [
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: screenWidth * 0.9,
        decoration: const BoxDecoration(
          color: AppTheme.mainBlue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${date.year}-${date.month}-${date.day}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '${date.hour}:${date.minute}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
