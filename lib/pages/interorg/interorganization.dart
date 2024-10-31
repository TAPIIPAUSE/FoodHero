import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/models/chart/savetypepie/hhfoodtypepie_model.dart';
import 'package:foodhero/models/chart/savetypepie/interorgfoodtypepie_model.dart';
import 'package:foodhero/models/chart/savetypepie/orgfoodtypepie_model.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/interscore_model.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/api/dashboardapi.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/interorg/foodtype_piechart.dart';
import 'package:foodhero/widgets/interorg/org_listscore.dart';
import 'package:go_router/go_router.dart';

class ChartData {
  final String name;
  final double value;
  final Color color;
  final int category;

  ChartData(
      {required this.name,
      required this.value,
      required this.color,
      required this.category});
}

class InterOrganization extends StatefulWidget {
  const InterOrganization({super.key});

  @override
  State<InterOrganization> createState() => _InterOrganizationState();
}

class _InterOrganizationState extends State<InterOrganization> {
  String selectedValue = inter;

  Future<HouseScore> _getHouseScore() async {
    try {
      final data = await DashboardApi().getHouseScore().timeout(
        const Duration(seconds: 60), // Adjust the duration as needed
        onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, please try again later.');
        },
      );
      print('Fetched household score'); // Debug print
      return data;
    } catch (e) {
      if (e is TimeoutException) {
        print('Timeout: ${e.message}');
      } else {
        print('Error loading house score: $e');
      }
      rethrow;
    }
  }

  Future<InterScore> _getInterScore() async {
    try {
      final data = await DashboardApi().getInterScore();
      print('Fetched inter score'); // Debug print
      return data;
    } catch (e) {
      print('Error loading inter score: $e');
      rethrow;
    }
  }

  Future<OrgScore> _getOrgScore() async {
    try {
      final data = await DashboardApi().getOrgScore();
      print('Fetched org score'); // Debug print
      return data;
    } catch (e) {
      print('Error loading org score: $e');
      rethrow;
    }
  }

  Future<InterOrgFoodTypePie> _getInterOrgFoodTypePie() async {
    try {
      final data = await DashboardApi().getInterOrgFoodTypePie();
      print('Fetched inter org food type pie'); // Debug print
      return data;
    } catch (e) {
      print('Error loading inter org food type pie: $e');
      rethrow;
    }
  }

  Future<HHFoodTypePie> _getHHFoodTypePie() async {
    try {
      final data = await DashboardApi().getHHFoodTypePie();
      print('Fetched hh food type pie'); // Debug print
      return data;
    } catch (e) {
      print('Error loading hh food type pie: $e');
      rethrow;
    }
  }

  Future<OrgFoodTypePie> _getOrgFoodTypePie() async {
    try {
      final data = await DashboardApi().getOrgFoodTypePie();
      print('Fetched org food type pie'); // Debug print
      return data;
    } catch (e) {
      print('Error loading org food type pie: $e');
      rethrow;
    }
  }

  String _getFoodTypeName(int category) {
    switch (category) {
      case 1:
        return foodTypeCooked;
      case 2:
        return foodTypeFresh;
      case 3:
        return foodTypeDry;
      case 4:
        return foodTypeInstant;
      case 5:
        return foodTypeFrozen;
      default:
        return 'Unknown';
    }
  }

  Color _getFoodTypeColor(int category) {
    switch (category) {
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.greenAccent.shade400;
      case 3:
        return Colors.brown.shade300;
      case 4:
        return Colors.yellow.shade400;
      case 5:
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }

  // pie data
  // int touchedIndex = -1;
  // final List<ChartData> chartData = [
  //   ChartData(foodTypeCooked, 25, AppTheme.softRedCancleWasted),
  //   ChartData(foodTypeDry, 25, AppTheme.softOrange),
  //   ChartData(foodTypeFresh, 20, AppTheme.softRedBrown),
  //   ChartData(foodTypeFrozen, 15, AppTheme.orangeGray),
  //   ChartData(foodTypeInstant, 15, AppTheme.spoiledBrown),
  // ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      selectedRouteIndex: 2,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140.0),
          child: Container(
            color: AppTheme.greenMainTheme,
            child: Column(
              children: [
                AppBar(
                  toolbarHeight: 90,
                  title: const Text('Dashboard'),
                  centerTitle: true,
                  backgroundColor: AppTheme.greenMainTheme,
                  titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
                  leading: IconButton(
                    onPressed: () => context.push(''),
                    icon: const Icon(
                      Icons.person_sharp,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  // dropdownColor: AppTheme.softYellow,
                  underline: Container(), // Removes the default underline
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: <String>[inter, hh, org]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: FontsTheme.mouseMemoirs_30Black(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    // const wastedpoint = 5000;

    final ButtonStyle buttonStyle = IconButton.styleFrom(
        backgroundColor: AppTheme.greenMainTheme,
        foregroundColor: Colors.white);

    switch (selectedValue) {
      case inter:
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Center(
                    child: Text(
                      inter,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.map_sharp,
                        color: Colors.white,
                      ),
                      const Text(
                        "Thung Khru",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.change_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Score board',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<InterScore>(
                        future: _getInterScore(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('No inter score available');
                          } else {
                            final interScore = snapshot.data!;
                            return SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: interScore.scoreList.length,
                                itemBuilder: (context, index) {
                                  final score = interScore.scoreList[index];
                                  return ListScore(
                                    name: score.orgname,
                                    star: score.rank == 1,
                                    point: score.score,
                                    rank: score.rank,
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
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'We saved food',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      // Text(
                      //   '${NumberFormat('#,###').format(wastedpoint)} grams',
                      //   style:
                      //       const TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                      // Pie chart
                      Container(
                        // height: 800,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child:
                            // const Column(
                            // children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text(week),
                            //     Text(month),
                            //   ],
                            // ),
                            // _buildResponsiveChartLayout(screenWidth),
                            FutureBuilder<InterOrgFoodTypePie>(
                          future: _getInterOrgFoodTypePie(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.statistic.isEmpty) {
                              // Check if the data is null or if the statistic list is empty
                              return const Text('No data available');
                            } else {
                              final data = snapshot.data!;
                              // final statistic = data.statistic;
                              // Assuming you want to loop over each statistic for the pie chart
                              return Column(
                                children: [
                                  // map each statistic to a WasteTypePiechart widget
                                  WasteTypePiechart(
                                    chartData: data.statistic
                                        .map((stat) => ChartData(
                                              category: stat.category,
                                              value: stat.percentConsume,
                                              name: _getFoodTypeName(
                                                  stat.category),
                                              color: _getFoodTypeColor(
                                                  stat.category),
                                            ))
                                        .toList(),
                                  ),
                                  BuildPieLegend(
                                    chartData: data.statistic
                                        .map((stat) => ChartData(
                                              category: stat.category,
                                              value: stat.percentConsume,
                                              name: _getFoodTypeName(
                                                  stat.category),
                                              color: _getFoodTypeColor(
                                                  stat.category),
                                            ))
                                        .toList(),
                                    title: 'Food Type',
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      // ),
                      // const SizedBox(height: 10),
                      // ElevatedButton(
                      //   onPressed: () => context.push('/dashboard_inter/inter'),
                      //   style: buttonStyle,
                      //   child: const Text("see more"),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case hh:
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Center(
                    child: Text(
                      hh,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.map_sharp,
                        color: Colors.white,
                      ),
                      const Text(
                        "Thung Khru",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.change_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Score board',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder<HouseScore>(
                        future: _getHouseScore(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            if (snapshot.error is TimeoutException) {
                              return const Text(
                                  'Connection timed out. Please try again.');
                            } else {
                              return Text('Error: ${snapshot.error}');
                            }
                          } else if (!snapshot.hasData) {
                            return const Text('No house score available');
                          } else {
                            final houseScore = snapshot.data!;
                            return SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: houseScore.scoreList.length,
                                itemBuilder: (context, index) {
                                  final score = houseScore.scoreList[index];
                                  return ListScore(
                                    name: score.username,
                                    star: score.rank == 1,
                                    point: score.score,
                                    rank: score.rank,
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
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your household saved food',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      // Text(
                      //   '${NumberFormat('#,###').format(wastedpoint)} grams',
                      //   style:
                      //       const TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                      // Pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child:
                            // const Column(
                            //   children: [
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(week),
                            //         Text(month),
                            //       ],
                            //     ),
                            //     // _buildResponsiveChartLayout(screenWidth),
                            //     WasteTypePiechart(),
                            //   ],
                            // ),
                            // Column(
                            FutureBuilder<HHFoodTypePie>(
                          future: _getHHFoodTypePie(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.statistic.isEmpty) {
                              return const Text('No data available');
                            } else {
                              final data = snapshot.data!;
                              return Column(
                                children: [
                                  WasteTypePiechart(
                                    chartData: data.statistic
                                        .map((stat) => ChartData(
                                            name:
                                                _getFoodTypeName(stat.category),
                                            value: stat.percentConsume,
                                            color: _getFoodTypeColor(
                                                stat.category),
                                            category: stat.category))
                                        .toList(),
                                  ),
                                  BuildPieLegend(
                                      chartData: data.statistic
                                          .map((stat) => ChartData(
                                              name: _getFoodTypeName(
                                                  stat.category),
                                              value: stat.percentConsume,
                                              color: _getFoodTypeColor(
                                                  stat.category),
                                              category: stat.category))
                                          .toList(),
                                      title: 'Food Type')
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter/hh'),
                        style: buttonStyle,
                        child: const Text("see more"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case org:
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Center(
                    child: Text(
                      org,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.map_sharp,
                        color: Colors.white,
                      ),
                      const Text(
                        "Thung Khru",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.change_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Score board',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
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
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text(
                                'No organization score available');
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
                                    star: score.rank == 1,
                                    point: score.score,
                                    rank: score.rank,
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
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.95,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your organization saved food',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      // Text(
                      //   '${NumberFormat('#,###').format(wastedpoint)} grams',
                      //   style:
                      //       const TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                      // Pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child:
                            // const Column(
                            //   children: [
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(week),
                            //         Text(month),
                            //       ],
                            //     ),
                            //     // _buildResponsiveChartLayout(screenWidth),
                            //     WasteTypePiechart(),
                            //   ],
                            // ),
                            FutureBuilder(
                          future: _getOrgFoodTypePie(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.statistic.isEmpty) {
                              return const Text('No data available');
                            } else {
                              final data = snapshot.data!;
                              return Column(
                                children: [
                                  WasteTypePiechart(
                                    chartData: data.statistic
                                        .map((stat) => ChartData(
                                            name:
                                                _getFoodTypeName(stat.category),
                                            value: stat.percentConsume,
                                            color: _getFoodTypeColor(
                                                stat.category),
                                            category: stat.category))
                                        .toList(),
                                  ),
                                  BuildPieLegend(
                                    chartData: data.statistic
                                        .map((stat) => ChartData(
                                            name:
                                                _getFoodTypeName(stat.category),
                                            value: stat.percentConsume,
                                            color: _getFoodTypeColor(
                                                stat.category),
                                            category: stat.category))
                                        .toList(),
                                    title: 'Food Type',
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter/org'),
                        style: buttonStyle,
                        child: const Text("see more"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return const LinearProgressIndicator();
    }
  }

  // Widget _buildResponsiveChartLayout(double screenWidth) {
  //   if (screenWidth <= 320) {
  //     return Column(
  //       children: [
  //         SizedBox(
  //           height: 200,
  //           child: _buildPie(),
  //         ),
  //         SizedBox(
  //           // height: 150,
  //           child: _buildLegend(),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return SizedBox(
  //       height: 200,
  //       child: Row(
  //         children: [
  //           Expanded(child: _buildPie()),
  //           Expanded(child: _buildLegend()),
  //         ],
  //       ),
  //     );
  //   }
  // }

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

  // List<PieChartSectionData> getPieSections() {
  //   return List.generate(chartData.length, (index) {
  //     final isTouched = index == touchedIndex;
  //     final data = chartData[index];
  //     final double fontSize = isTouched ? 16 : 0;
  //     final double radius = isTouched ? 80 : 70;

  //     return PieChartSectionData(
  //       color: data.color,
  //       value: data.value,
  //       title: '${data.value.toStringAsFixed(0)}%',
  //       radius: radius,
  //       titleStyle: TextStyle(
  //         fontSize: fontSize,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.black,
  //       ),
  //     );
  //   });
  // }

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
}
