import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarData {
  final double wastePercent;
  final double consumePercent;
  final int total;
  final int consume;
  final int waste;
  final String label;

  BarData(
      {required this.wastePercent,
      required this.consumePercent,
      required this.total,
      required this.consume,
      required this.waste,
      required this.label});
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
  // late SelectionBehavior _selectionBehavior;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    //   _selectionBehavior = SelectionBehavior(
    //     enable: true,
    //     // unselectedColor: Colors.grey,
    //     unselectedOpacity: 1,
    //   );
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        // Customize tooltip content here
        final barData = data as BarData;
        final total = barData.total;
        final consumed = barData.consume;
        final wasted = barData.waste;
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total Consumption: $total",
                  style: const TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Consumed: $consumed",
                      style: const TextStyle(fontSize: 12)),
                  Text("Wasted: $wasted", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showConsumptionDetails(BarData data) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Details for ${data.label}"),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text("Total: ${data.total}"),
  //               Text("Consumption: ${data.consume}"),
  //               Text("Waste: ${data.wastePercent}"),
  //             ],
  //           ),
  //           // actions: [
  //           //   TextButton(
  //           //     onPressed: () {
  //           //       Navigator.pop(context);
  //           //     },
  //           //     child: const Text('Close'),
  //           //   ),
  //           // ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 200,
            width: widget.chartData.length *
                50.0, // Adjust width based on the number of bars and desired spacing
            child: SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              // selectionType: SelectionType.point,
              // onSelectionChanged: (SelectionArgs args) {
              //   final data = widget.chartData[args.pointIndex];
              //   _showConsumptionDetails(data);

              //   // Clear selection after showing details
              //   _selectionBehavior.toggleSelection;
              // },
              series: [
                StackedColumn100Series<BarData, String>(
                  dataSource: widget.chartData,
                  xValueMapper: (BarData data, _) => data.label,
                  yValueMapper: (BarData data, _) =>
                      data.consumePercent.toDouble(),
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    // Optional: customize how zero values are displayed
                    textStyle: TextStyle(fontSize: 10),
                  ),
                  name: 'Food Consumption', // Name for the legend
                  color: AppTheme.softBrightGreen,
                  // selectionBehavior: _selectionBehavior,
                  dataLabelMapper: (BarData data, _) =>
                      '${data.consumePercent.toInt()}%', // Convert to integer
                  // data.consumePercent == 0 ? '' : '${data.consumePercent}%',
                  // dataLabelMapper: (BarData data, _) =>
                  // data.percent == 0 ? 'No data' : '${data.percent}%',
                ),
                StackedColumn100Series<BarData, String>(
                  dataSource: widget.chartData,
                  xValueMapper: (BarData data, _) => data.label,
                  yValueMapper: (BarData data, _) =>
                      data.wastePercent.toDouble(),
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    // Optional: customize how zero values are displayed
                    textStyle: TextStyle(fontSize: 10),
                  ),
                  name: 'Food wasted', // Name for the legend
                  color: AppTheme.softRedCancleWasted,
                  // selectionBehavior: _selectionBehavior,
                  dataLabelMapper: (BarData data, _) =>
                      // '${100 - data.percent.toInt()}%', // Convert to integer
                      // dataLabelMapper: (BarData data, _) =>
                      data.wastePercent == 0
                          ? ''
                          : '${data.wastePercent.toInt()}%',
                ),
              ],
              legend: Legend(
                isVisible: true,
                position: LegendPosition
                    .bottom, // Position the legend below the chart
              ),
              // primaryXAxis: CategoryAxis(), // Explicitly set x-axis type
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(fontSize: 10),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  DateTime date =
                      DateFormat("EEE MMM dd yyyy").parse(details.text);
                  String formattedDate = DateFormat("dd/MM").format(date);
                  return ChartAxisLabel(formattedDate, details.textStyle);
                },
              ),
              primaryYAxis: NumericAxis(),
            )),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Consumption: ", style: const TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Consumed: ", style: const TextStyle(fontSize: 16)),
                Text("Wasted: ", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ],
    );
  }
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
