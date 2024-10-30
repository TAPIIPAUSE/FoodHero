import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';
import 'package:intl/intl.dart';

class BarData {
  final double percent;
  final String label;

  BarData({required this.percent, required this.label});
}

// class WasteBarchart extends StatelessWidget {
//   // final Color color;
//   final List<BarChart> chartData;
//   const WasteBarchart({
//     super.key,
//     required this.chartData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.95,
//         height: MediaQuery.of(context).size.width * 0.95 * 0.65,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: chart,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class WasteBarChartContent extends StatefulWidget {
  // final List<Map<String, dynamic>> weekData;
  final List<BarData> chartData;
  const WasteBarChartContent({
    super.key,
    required this.chartData,
  });

  @override
  State<WasteBarChartContent> createState() => _WasteBarChartContentState();
}

class _WasteBarChartContentState extends State<WasteBarChartContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      // child: SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      // child: SizedBox(
      // height: 300,
      width: widget.chartData.length *
          50.0, // Adjust width based on the number of bars and desired spacing
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < widget.chartData.length) {
                    DateTime date = DateFormat('EEE MMM dd yyyy')
                        .parse(widget.chartData[index].label);
                    String formattedDate = DateFormat('dd/MM').format(date);
                    return Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 28),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 20,
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() == 0) return const SizedBox.shrink();
                  return Text(
                    // value.toInt().toString(),
                    '${value.toInt()}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
              border: Border.all(color: Colors.black, width: 0.5), show: true),
          alignment: BarChartAlignment.spaceEvenly,
          maxY: 100,
          minY: 0,
          barGroups: widget.chartData.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.percent,
                  color: AppTheme.softBrightGreen,
                  width: 20,
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(
            // show: true,
            drawVerticalLine: true,
            // drawHorizontalLine: true,
            horizontalInterval: 20,
            checkToShowHorizontalLine: (value) =>
                value <= 100, // Only show grid lines up to 100
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black12,
                strokeWidth: 1,
              );
            },
            // getDrawingVerticalLine: (value) {
            //   return FlLine(
            //     color: Colors.black,
            //     strokeWidth: 1,
            //   );
            // },
          ),
          barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
              )),
        ),
      ),
      // ),
      // ),
    );
  }
// class ReasonBarChartContent extends StatelessWidget {
//   const ReasonBarChartContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 return Text(
//                   getTitleText(value),
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               },
//             ),
//           ),
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: false,
//             ),
//           ),
//           rightTitles: const AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: false,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               interval: 25,
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 if (value.toInt() == 0) return const SizedBox.shrink();
//                 return Text(
//                   value.toInt().toString(),
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         borderData: FlBorderData(
//           border: Border.all(color: Colors.black, width: 0.5),
//         ),
//         alignment: BarChartAlignment.spaceEvenly,
//         maxY: 100,
//         barGroups: reasonbarChartGroupData,
//       ),
//     );
//   }

//   String getTitleText(double value) {
//     switch (value.toInt()) {
//       case 1:
//         return january;
//       case 2:
//         return february;
//       case 3:
//         return march;
//       case 4:
//         return april;
//       case 5:
//         return may;
//       case 6:
//         return june;
//       case 7:
//         return july;
//       case 8:
//         return august;
//       case 9:
//         return september;
//       case 10:
//         return october;
//       case 11:
//         return november;
//       case 12:
//         return december;
//       default:
//         return '';
//     }
//   }
// }
}
