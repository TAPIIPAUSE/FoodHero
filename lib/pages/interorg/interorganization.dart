import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/interscore_model.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/api/dashboardapi.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/interorg/org_listscore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChartData {
  final String name;
  final double value;
  final Color color;

  ChartData(this.name, this.value, this.color);
}

class InterOrganization extends StatefulWidget {
  const InterOrganization({super.key});

  @override
  State<InterOrganization> createState() => _InterOrganizationState();
}

class _InterOrganizationState extends State<InterOrganization> {
  String selectedValue = inter;
  // pie data
  int touchedIndex = -1;
  final List<ChartData> chartData = [
    ChartData(foodTypeCooked, 25, AppTheme.softRedCancleWasted),
    ChartData(foodTypeDry, 25, AppTheme.softOrange),
    ChartData(foodTypeFresh, 20, AppTheme.softRedBrown),
    ChartData(foodTypeFrozen, 15, AppTheme.orangeGray),
    ChartData(foodTypeInstant, 15, AppTheme.spoiledBrown),
  ];

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
    const wastedpoint = 5000;

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
                        style: TextStyle(color: Colors.white, fontSize: 24),
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
                                  return OrgListScore(
                                    orgname: score.orgname,
                                    star: score.rank == 1,
                                    point: score.score,
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
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // Pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(week),
                                Text(month),
                              ],
                            ),
                            _buildResponsiveChartLayout(screenWidth),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter/inter'),
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
                        style: TextStyle(color: Colors.white, fontSize: 24),
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
                                  return OrgListScore(
                                    orgname: score.username,
                                    star: score.rank == 1,
                                    point: score.score,
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
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // Pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(week),
                                Text(month),
                              ],
                            ),
                            _buildResponsiveChartLayout(screenWidth),
                          ],
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
                        style: TextStyle(color: Colors.white, fontSize: 24),
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
                                  return OrgListScore(
                                    orgname: score.housename,
                                    star: score.rank == 1,
                                    point: score.score!,
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
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      // Pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(week),
                                Text(month),
                              ],
                            ),
                            _buildResponsiveChartLayout(screenWidth),
                          ],
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

  Widget _buildResponsiveChartLayout(double screenWidth) {
    if (screenWidth <= 320) {
      return Column(
        children: [
          SizedBox(
            height: 200,
            child: _buildPie(),
          ),
          SizedBox(
            // height: 150,
            child: _buildLegend(),
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(child: _buildPie()),
            Expanded(child: _buildLegend()),
          ],
        ),
      );
    }
  }

  Widget _buildPie() {
    return PieChart(
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
    );
  }

  List<PieChartSectionData> getPieSections() {
    return List.generate(chartData.length, (index) {
      final isTouched = index == touchedIndex;
      final data = chartData[index];
      final double fontSize = isTouched ? 16 : 0;
      final double radius = isTouched ? 80 : 70;

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

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chartData.map((data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                color: data.color,
              ),
              const SizedBox(width: 4),
              Text(
                '${data.name}: ${data.value.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
