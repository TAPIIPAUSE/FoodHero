import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/models/chart/bar/orgbar_model.dart';
import 'package:foodhero/models/orgname_mode.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/House&Orga/Join_org.dart';
import 'package:foodhero/pages/api/houseorg_api.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/barchart.dart';
import 'package:foodhero/widgets/interorg/org_listscore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class organization extends StatefulWidget {
  const organization({super.key});

  @override
  _OrganizationState createState() => _OrganizationState();
}

class _OrganizationState extends State<organization> {
  late String _todayDate;
  late String _weekday;
  final cs.CarouselSliderController _controller = cs.CarouselSliderController();
  int _current = 0;
  int _weekdayIndex = 0;
  int touchedIndex = -1;
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final List<String> briefweekdays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  Future<OrgScore> _getOrgScore() async {
    try {
      final data = await HouseOrgApi().getOrgPageScore();
      print('Fetched org score');
      return data;
    } catch (e) {
      print('Error loading house score: $e');
      rethrow; // Return the error message
    }
  }

  Future<OrgFoodSaved> _getOrgBar() async {
    try {
      final data = await HouseOrgApi().getOrgBarChart();
      print('Fetched org bar');
      return data;
    } catch (e) {
      print('Error loading org bar: $e');
      rethrow; // Return the error message
    }
  }

  Future<OrgName?> _getOrgName() async {
    try {
      final data = await HouseOrgApi().getOrgName();
      print('Fetched org name');
      return data;
    } catch (e) {
      print('Error loading org name: $e');
      rethrow; // Return the error message
    }
  }

  @override
  void initState() {
    super.initState();
    _updateDate();
  }

  void _updateDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('EEEE d MMMM yyyy').format(now); // Full format
    _weekday = weekdays[now.weekday - 1]; // Adjust for index starting from 0
    _weekdayIndex = now.weekday - 1;
    log(_weekdayIndex);
  }

  // List<Map<String, dynamic>> members = [
  //   {"name": "You", "score": 24058},
  //   {"name": "Dad", "score": 24024},
  //   {"name": "Mom", "score": 18547},
  //   {"name": "Brother", "score": 17245},
  // ];

  // Dummy briefweekdays list for example purposes

  // List<Widget> generateCharts() {
  //   // Generate bar chart data dynamically
  //   Widget barChart = Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: List.generate(7, (index) {
  //       int currentIndex = index;
  //       while (currentIndex >= briefweekdays.length) {
  //         currentIndex -= briefweekdays.length; // Wrap around to beginning
  //       }
  //       final weekday = briefweekdays[currentIndex];
  //       final currentDate = index == _weekdayIndex;
  //       return Column(
  //         children: [
  //           Container(
  //             height: 100, // height of the bar
  //             width: 20, // width of the bar
  //             color: currentDate ? Colors.orange : Colors.grey,
  //           ),
  //           const SizedBox(height: 5),
  //           Text(weekday),
  //         ],
  //       );
  //     }),
  //   );

  //   // Generate pie chart with fixed size using SizedBox
  //   Widget pieChart = SizedBox(
  //     width: 150, // Fixed width
  //     height: 150, // Fixed height
  //     child: PieChart(
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
  //         borderData: FlBorderData(show: false),
  //         sectionsSpace: 0,
  //         centerSpaceRadius: 0,
  //         sections: showingSections(),
  //       ),
  //     ),
  //   );

  //   return [barChart, pieChart];
  // }

  // List<PieChartSectionData> showingSections() {
  //   // Your logic to generate pie chart sections...
  //   return [
  //     PieChartSectionData(color: Colors.red, value: 40, title: '40%'),
  //     PieChartSectionData(color: Colors.green, value: 30, title: '30%'),
  //     PieChartSectionData(color: Colors.blue, value: 20, title: '20%'),
  //     PieChartSectionData(color: Colors.yellow, value: 10, title: '10%'),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MainScaffold(
      selectedRouteIndex: 3,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.greenMainTheme,
          toolbarHeight: 100,
          centerTitle: true,
          title: Column(
            children: [
              const Text('Organization'),
              FutureBuilder(
                  future: _getOrgName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'You are not part of any organization',
                        style: TextStyle(fontSize: 18),
                      );
                    } else if (!snapshot.hasData) {
                      return Text('No organization name');
                    } else {
                      final name = snapshot.data!.name;
                      return Text("🏢 $name 🏢",
                          style: FontsTheme.mouseMemoirs_30Black());
                    }
                  })
            ],
          ),
          titleTextStyle: FontsTheme.mouseMemoirs_50Black(),
          leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Text('Today $_todayDate', style: FontsTheme.hindBold_20()),

                    const SizedBox(height: 10),

                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      width: screenWidth * 0.95,
                      decoration: const BoxDecoration(
                        color: AppTheme.softBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          FutureBuilder<OrgFoodSaved>(
                            future: _getOrgBar(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const Center(
                                    child: Text('No data available'));
                              } else {
                                final data =
                                    (snapshot.data!.weekList as List<dynamic>)
                                        .map((stat) {
                                  return BarData(
                                    label: stat.date,
                                    wastePercent: stat.wastePercent,
                                    consumePercent: stat.consumePercent,
                                    total: stat.total,
                                    consume: stat.consume,
                                    waste: stat.waste,
                                  );
                                }).toList();

                                data.sort((a, b) {
                                  DateTime dateA = DateFormat('EEE MMM dd yyyy')
                                      .parse(a.label);
                                  DateTime dateB = DateFormat('EEE MMM dd yyyy')
                                      .parse(b.label);
                                  return dateA.compareTo(dateB);
                                });

                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Stack(
                                        children: [
                                          Center(
                                            child: const Text(
                                                "Daily Food Consumption",
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          // title: Text(
                                                          // "Information"),
                                                          content: Text(
                                                            'The height of each bar represents the percentage of food that you consumed on a particular day, while the colors represent the completed consumed and wasted of food. The percentage of consumed and wasted is represented by the height of the corresponding color in the bar. The total height of the bar always adds up to 100%, which represents your total daily food consumption.',
                                                            // style:
                                                            // const TextStyle(
                                                            // fontSize:
                                                            // 16),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons
                                                      .info_outline_rounded))
                                            ],
                                          )
                                        ],
                                      ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   children: [
                                      //     Text("%",
                                      //         style: TextStyle(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.bold)),
                                      //   ],
                                      // ),
                                      WasteBarChartContent(
                                        chartData: data,
                                        // color: AppTheme.softBlue,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          ElevatedButton(
                              onPressed: () =>
                                  context.push('/dashboard_inter/org'),
                              style: IconButton.styleFrom(
                                  backgroundColor: AppTheme.mainBlue,
                                  foregroundColor: Colors.white),
                              child: Text("see more"))
                        ],
                      ),
                    ),

                    // TextButton.icon(
                    //   onPressed: () => context.push('/dashboard_inter/org'),
                    //   icon: Icon(
                    //     Icons.expand_circle_down_rounded,
                    //     size: 32,
                    //     color: Colors.orange,
                    //   ),
                    //   label: Text(''),
                    // )
                  ],
                ),
                // ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: generateCharts().map((widget) {
                //     int index = generateCharts().indexOf(widget);
                //     return GestureDetector(
                //       onTap: () => _controller.animateToPage(index),
                //       child: Container(
                //         width: 8.0,
                //         height: 8.0,
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 10.0, horizontal: 2.0),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color:
                //               _current == index ? Colors.orange : Colors.grey,
                //         ),
                //       ),
                //     );
                //   }).toList(),
                // ),
                const SizedBox(height: 20),
                // Members section

                // const Text(
                //   'Score board',
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const Text(
                            'Score board',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          // title: Text("Information"),
                                          content: SizedBox(
                                        width: double.maxFinite,
                                        child: Markdown(
                                            data:
                                                "### Scoring calculation from Food Consumption \n**If food quantity greater or equal to 1000 grams** \n* If 90% to 100% of the food is consumed, The consumed portion is multiplied by 5 to receive a **positive score** between 4.5 and 5 \n* If 70% to 90% of the food is consumed, The consumed portion is multiplied by 3 to receive a **positive score** between 2.1 and 2.7 \n* If less than 70% of the food is consumed, The consumed portion is multiplied by -5, resulting in a **negative score** between -3.5 and -5 \n\n**If food quantity less than 1000 grams** \n* If more than 80% of the food is consumed, The consumed portion is multiplied by 2 to receive a **positive score** between 1.6 and 2 \n* If 80% or less of the food is consumed, The consumed portion is multiplied by -2, resulting in a **negative score** between -1.6 and -2 \n### How to receive a Star? \nA star is awarded to the top-ranking member in this organization who has a score more than 0"),
                                      )
                                          // Text(
                                          // 'information about this chart',
                                          // style: const TextStyle(fontSize: 16),
                                          // ),
                                          );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FutureBuilder<OrgScore>(
                        future: _getOrgScore(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return const Text("You're not in any organization");
                          } else if (!snapshot.hasData) {
                            return const Text(
                                'No oraganization score available');
                          } else {
                            final orgScore = snapshot.data!;
                            return SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: orgScore.scoreList.length,
                                itemBuilder: (context, index) {
                                  final score = orgScore.scoreList[index];
                                  return ListScore(
                                    name: score.housename,
                                    star: score.rank == 1 && score.score > 0,
                                    point: score.score,
                                    rank: score.rank,
                                    isMember: score.isCurrentUser,
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Card(
                //   margin:
                //       const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: members.map((member) {
                //         return ListTile(
                //           title: Text(
                //             member["name"],
                //             style: const TextStyle(
                //                 fontSize: 20, fontWeight: FontWeight.bold),
                //           ),
                //           trailing: Text(
                //             member["score"].toString(),
                //             style: const TextStyle(
                //                 fontSize: 20, color: Colors.blueAccent),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // // Progress bar
                // LinearPercentIndicator(
                //   lineHeight: 20.0,
                //   percent: 0.32,
                //   linearStrokeCap: LinearStrokeCap.roundAll,
                //   progressColor: Colors.orange,
                // ),
                // const Text("Reached 32% this month"),
                // const SizedBox(height: 20),
                // // Create a goal button
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppTheme.greenMainTheme,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 50, vertical: 20),
                //     textStyle: const TextStyle(
                //         fontSize: 20, fontWeight: FontWeight.bold),
                //   ),
                //   child: const Text('Create a goal'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
