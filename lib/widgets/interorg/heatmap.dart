import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapChart extends StatefulWidget {
  const HeatMapChart({super.key});

  @override
  State<HeatMapChart> createState() => _HeatMapChartState();
}

class _HeatMapChartState extends State<HeatMapChart> {
  Map<DateTime, int> dateMap = {};
  Random random = Random();
  // Define the start and end dates
  DateTime startDate = DateTime(2024, 1, 1);
  DateTime endDate = DateTime(2024, 12, 31);
  void addDateMap() {
    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      // Randomly decide whether to skip this date
      bool shouldAdd = random.nextBool(); // 50% chance to skip or add
      if (shouldAdd) {
        // Assign a random value between 1 and 3 (inclusive)
        int randomValue = random.nextInt(13) + 1;
        dateMap[date] = randomValue;
      }
    }
  }

  @override
  void initState() {
    addDateMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeatMapCalendar(
      defaultColor: Colors.white,
      flexible: true,
      colorMode: ColorMode.color,
      datasets: dateMap,
      textColor: Colors.white,
      weekTextColor: Colors.black,
      colorsets: const {
        1: Colors.red,
        3: Colors.orange,
        5: Colors.yellow,
        7: Colors.green,
        9: Colors.blue,
        11: Colors.indigo,
        13: Colors.purple,
      },
      // onClick: (value) {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(value.toString())));
      // },
    );
  }
}
