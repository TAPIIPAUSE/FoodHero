import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';

class PricePiechart extends StatefulWidget {
  final double savedpercent;
  final double lostpercent;

  const PricePiechart(
      {super.key, required this.savedpercent, required this.lostpercent});

  @override
  State<PricePiechart> createState() => _PricePiechartState();
}

class _PricePiechartState extends State<PricePiechart> {
  int touchedIndex = -1;
  late List<PieData> chartData;

  @override
  void initState() {
    super.initState();
    chartData = [
      PieData(saved, widget.savedpercent, AppTheme.softBrightGreen),
      PieData(lost, widget.lostpercent, AppTheme.softRedCancleWasted),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return
        // SizedBox(
        //   height: 400,
        //   child: DefaultTabController(
        //       length: 2,
        //       child: Scaffold(
        //           appBar: AppBar(
        //             automaticallyImplyLeading: false,
        //             // backgroundColor: AppTheme.softBlue,
        //             bottom: PreferredSize(
        //               preferredSize: const Size.fromHeight(10),
        //               child: ClipRRect(
        //                 borderRadius: const BorderRadius.all(Radius.circular(10)),
        //                 child: Container(
        //                     height: 40,
        //                     margin: const EdgeInsets.symmetric(horizontal: 20),
        //                     decoration: const BoxDecoration(
        //                       borderRadius: BorderRadius.all(
        //                         Radius.circular(10),
        //                       ),
        //                     ),
        //                     child: const TabBar(
        //                       indicatorSize: TabBarIndicatorSize.tab,
        //                       dividerColor: AppTheme.softBlue,
        //                       indicatorColor: AppTheme.mainBlue,
        //                       indicator: BoxDecoration(
        //                         color: AppTheme.mainBlue,
        //                         borderRadius: BorderRadius.all(
        //                           Radius.circular(10),
        //                         ),
        //                       ),
        //                       labelColor: Colors.white,
        //                       tabs: [
        //                         Tab(text: week),
        //                         Tab(text: month),
        //                       ],
        //                     )),
        //               ),
        //             ),
        //           ),
        //           body: TabBarView(
        //             children: [
        //               SizedBox(
        //                 height: 200,
        //                 child: Column(
        //                   children: [
        //                     const SizedBox(height: 50),
        //                     Expanded(child: _buildPie()),
        //                     const SizedBox(height: 50),
        //                     Expanded(child: _buildLegend()),
        //                   ],
        //                 ),
        //               ),
        SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: getPieSections(),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
              ),
            )
            // Column(
            //   children: [
            //     const SizedBox(height: 50),
            //     Expanded(child: _buildPie()),
            //     const SizedBox(height: 50),
            //     Expanded(child: _buildLegend()),
            //   ],
            // ),
            //               ),
            //             ],
            //           ))),
            );
  }

  // Widget _buildPie() {
  //   return PieChart(
  //     PieChartData(
  //       pieTouchData: PieTouchData(
  //         touchCallback: (FlTouchEvent event, pieTouchResponse) {
  //           setState(() {
  //             if (!event.isInterestedForInteractions ||
  //                 pieTouchResponse == null ||
  //                 pieTouchResponse.touchedSection == null) {
  //               touchedIndex = -1;
  //               return;
  //             }
  //             touchedIndex =
  //                 pieTouchResponse.touchedSection!.touchedSectionIndex;
  //           });
  //         },
  //       ),
  //       sections: getPieSections(),
  //       sectionsSpace: 0,
  //       centerSpaceRadius: 0,
  //     ),
  //   );
  // }

  // Widget _buildLegend() {
  //   return Row(
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
  //             const SizedBox(width: 16),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  List<PieChartSectionData> getPieSections() {
    return List.generate(chartData.length, (index) {
      final isTouched = index == touchedIndex;
      final data = chartData[index];
      final double fontSize = isTouched ? 24 : 16;
      final double radius = isTouched ? 120 : 100;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title: '${data.value.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }
}

// class TabItem extends StatelessWidget {
//   const TabItem({super.key, required this.title, required this.count});
//   final String title;
//   final int count;

//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             title,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

class BuildExpensePieLegend extends StatefulWidget {
  final double savedpercent;
  final double lostpercent;

  const BuildExpensePieLegend(
      {super.key, required this.savedpercent, required this.lostpercent});

  @override
  State<BuildExpensePieLegend> createState() => _BuildExpensePieLegend();
}

class _BuildExpensePieLegend extends State<BuildExpensePieLegend> {
  late List<PieData> chartData;

  @override
  void initState() {
    super.initState();
    chartData = [
      PieData(saved, widget.savedpercent, AppTheme.softBrightGreen),
      PieData(lost, widget.lostpercent, AppTheme.softRedCancleWasted),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                '${data.name}: ${data.value.toString()}%',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(width: 16),
            ],
          ),
        );
      }).toList(),
    );
  }
}
