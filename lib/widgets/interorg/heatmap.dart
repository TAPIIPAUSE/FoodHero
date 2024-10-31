import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

// class HMData {
//   final DateTime date;
//   final int count;

//   HMData({required this.date, required this.count});
// }

class HeatMapChart extends StatefulWidget {
  final Map<DateTime, int> dataMap;
  const HeatMapChart({
    super.key,
    required this.dataMap,
  });

  @override
  State<HeatMapChart> createState() => _HeatMapChartState();
}

class _HeatMapChartState extends State<HeatMapChart> {
  // Map<DateTime, int> dateMap = {

  // };
  // Random random = Random();
  // Define the start and end dates
  DateTime startDate = DateTime(2024, 10, 1);
  DateTime endDate = DateTime(2024, 12, 31);
  // void addDateMap() {
  //   for (DateTime date = startDate;
  //       date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
  //       date = date.add(const Duration(days: 1))) {

  //     // Randomly decide whether to skip this date
  //     // bool shouldAdd = random.nextBool(); // 50% chance to skip or add
  //     // if (shouldAdd) {
  //       // Assign a random value between 1 and 3 (inclusive)
  //       // int randomValue = random.nextInt(100) + 1;
  //       // dateMap[date] = randomValue;
  //     }
  //   }
  // }

  @override
  void initState() {
    // addDateMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: HeatMap(
            defaultColor: Colors.grey[300],
            startDate: startDate,
            endDate: endDate,
            // flexible: true,
            colorMode: ColorMode.color,
            showColorTip: false,
            datasets: widget.dataMap,
            textColor: Colors.black,
            // weekTextColor: Colors.black,

            // colorMode: ColorMode.opacity,
            colorsets: {
              0: Color(0xFF33A64C),
              25: Color(0xFF8DC437),
              50: Color(0xFFFFD301),
              75: Color(0xFFFF8C01),
              100: Color(0xFFCC3232),
              // 10: Color(0xFF64DD17),
              // 20: Color(0xFF3CB371),
              // 30: Color(0xFFFFE860),
              // 40: Color(0xFFFFFF00),
              // 50: Color(0xFFFF8040),
              // 25: Colors.redAccent,
              // // 3: Colors.orange,
              // // 5: Colors.yellow,
              // 50: Colors.greenAccent,
              // 75: Colors.green,
              // 100: Colors.red,
              // 9: Colors.blue,
              // 11: Colors.indigo,
              // 13: Colors.purple,
            },
            onClick: (value) {
              final count = widget.dataMap[value] ?? 0;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Date Information"),
                    content: Text(
                      'Date: ${value.toString().split(' ')[0]}\nWasted: $count%',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // actions: [
                    //   TextButton(
                    //     child: Text("OK"),
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //   ),
                    // ],
                  );
                },
              );
            },

            // onClick: (value) {
            //   ScaffoldMessenger.of(context)
            //       .showSnackBar(SnackBar(content: Text(value.toString())));
            // },
          ),
        ),
        SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Color(0xFF33A64C), '0%: Green (Best)'),
            _buildLegendItem(Color(0xFF8DC437), '25%: Yellow-Green (Good)'),
            _buildLegendItem(Color(0xFFFFD301), '50%: Yellow (Medium)'),
            _buildLegendItem(Color(0xFFFF8C01), '75%: Orange (Poor)'),
            _buildLegendItem(Color(0xFFCC3232), '100%: Red (Worst)'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            // color: color,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
          ),
          SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
