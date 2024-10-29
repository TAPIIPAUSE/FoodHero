import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';

class WasteTypePiechart extends StatefulWidget {
  final List<ChartData> chartData;
  const WasteTypePiechart({super.key, required this.chartData});

  @override
  State<WasteTypePiechart> createState() => _WasteBarPieState();
}

class _WasteBarPieState extends State<WasteTypePiechart> {
  // int touchedIndex = -1;

  // @override
  // void initState() {
  //   super.initState();

  //   // Initialize `chartData` with dynamic data based on widget's `percent` and `category`
  //   // final List<ChartData> chartData = [
  //   //   ChartData(foodTypeCooked, widget.chartData==1?widget.percent:0, AppTheme.softRedCancleWasted),
  //   //   ChartData(foodTypeDry, 30, AppTheme.softOrange),
  //   //   ChartData(foodTypeFresh, 25, AppTheme.softRedBrown),
  //   //   ChartData(foodTypeFrozen, 20, AppTheme.orangeGray),
  //   //   ChartData(foodTypeInstant, 5, AppTheme.spoiledBrown),
  //   // ];
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: PieChart(
        PieChartData(
          sections: widget.chartData.asMap().entries.map(
            (e) {
              return PieChartSectionData(
                radius: 100,
                color: e.value.color,
                value: e.value.value,
                title: '${e.value.value}%',
                titleStyle: const TextStyle(
                  fontSize: 24,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
  // Widget _buildLegend() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: chartData.map((data) {
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 15,
  //               height: 15,
  //               color: data.color,
  //             ),
  //             const SizedBox(width: 4),
  //             Text(
  //               '${data.name}: ${data.value.toStringAsFixed(0)}%',
  //               style: const TextStyle(fontSize: 14, color: Colors.black),
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
} //         // SizedBox(
//         // height: 400,
//         // child: DefaultTabController(
//         // length: 2,
//         // child:
//         // Scaffold(
//         // appBar: AppBar(
//         //   // title: const Text("Bar chart"),
//         //   // centerTitle: true,
//         //   automaticallyImplyLeading: false,
//         //   backgroundColor: Colors.white,
//         //   bottom: PreferredSize(
//         //     preferredSize: const Size.fromHeight(10),
//         //     child: ClipRRect(
//         //       borderRadius: const BorderRadius.all(Radius.circular(10)),
//         //       child: Container(
//         //           height: 40,
//         //           margin: const EdgeInsets.symmetric(horizontal: 20),
//         //           decoration: const BoxDecoration(
//         //             borderRadius: BorderRadius.all(
//         //               Radius.circular(10),
//         //             ),
//         //           ),
//         //           child: const TabBar(
//         //             indicatorSize: TabBarIndicatorSize.tab,
//         //             dividerColor: AppTheme.softBlue,
//         //             indicatorColor: AppTheme.mainBlue,
//         //             indicator: BoxDecoration(
//         //               color: AppTheme.mainBlue,
//         //               borderRadius: BorderRadius.all(
//         //                 Radius.circular(10),
//         //               ),
//         //             ),
//         //             labelColor: Colors.white,
//         //             tabs: [
//         //               Tab(text: week),
//         //               Tab(text: month),
//         //             ],
//         //           )),
//         //     ),
//         //   ),
//         // ),
//         // body:
//         // TabBarView(
//         // children: [
//         SizedBox(
//       height: 500,
//       child: Column(
//         children: [
//           // const SizedBox(height: 50),
//           Expanded(child: _buildPie()),
//           const SizedBox(height: 50),
//           Expanded(child: _buildLegend()),
//         ],
//       ),
//       // )
//       // SizedBox(
//       //   height: 200,
//       //   child: Row(
//       //     children: [
//       //       Expanded(child: _buildPie()),
//       //       Expanded(child: _buildLegend()),
//       //     ],
//       //   ),
//       // ),
//       // ],
//       // ),
//       // ),
//       // ),
//     );
//   }

//   Widget _buildPie() {
//     return PieChart(
//       PieChartData(
//         pieTouchData: PieTouchData(
//           touchCallback: (FlTouchEvent event, pieTouchResponse) {
//             setState(() {
//               if (!event.isInterestedForInteractions ||
//                   pieTouchResponse == null ||
//                   pieTouchResponse.touchedSection == null) {
//                 touchedIndex = -1;
//                 return;
//               }
//               touchedIndex =
//                   pieTouchResponse.touchedSection!.touchedSectionIndex;
//             });
//           },
//         ),
//         sections: getPieSections(),
//         sectionsSpace: 0,
//         centerSpaceRadius: 0,
//       ),
//     );
//   }

//   List<PieChartSectionData> getPieSections() {
//     return List.generate(chartData.length, (index) {
//       final isTouched = index == touchedIndex;
//       final data = chartData[index];
//       final double fontSize = isTouched ? 16 : 0;
//       final double radius = isTouched ? 70 : 60;

//       return PieChartSectionData(
//         color: data.color,
//         value: data.value,
//         title: '${data.value.toStringAsFixed(0)}%',
//         radius: radius,
//         titleStyle: TextStyle(
//           fontSize: fontSize,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       );
//     });
//   }
// }

// // class TabItem extends StatelessWidget {
// //   const TabItem({super.key, required this.title, required this.count});
// //   final String title;
// //   final int count;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Tab(
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(
// //             title,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

class BuildPieLegend extends StatelessWidget {
  final List<ChartData> chartData;
  final String title;
  const BuildPieLegend(
      {super.key, required this.chartData, required this.title});

  // final List<ChartData> chartData = [
  //   ChartData(foodTypeCooked, 20, AppTheme.softRedCancleWasted),
  //   ChartData(foodTypeDry, 30, AppTheme.softOrange),
  //   ChartData(foodTypeFresh, 25, AppTheme.softRedBrown),
  //   ChartData(foodTypeFrozen, 20, AppTheme.orangeGray),
  //   ChartData(foodTypeInstant, 5, AppTheme.spoiledBrown),
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: chartData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: data.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    // '${data.name}: ${data.value.toStringAsFixed(0)}%',
                    '${data.name}: ${data.value}%',
                    // data.name,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
