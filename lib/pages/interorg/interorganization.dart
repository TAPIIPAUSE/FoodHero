import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
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
    const totalpoint = 40500;
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
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                            child: Text(
                          "$inter score board",
                          style: FontsTheme.mouseMemoirs_30White()
                              .copyWith(color: Colors.white),
                        )),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          width: screenWidth * 0.9,
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
                              Text(
                                "Thung Khru",
                                style: FontsTheme.mouseMemoirs_25().copyWith(
                                    color: Colors.white, letterSpacing: 1),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.change_circle,
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${NumberFormat('#,###').format(totalpoint)} points score',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const OrgListScore(
                              orgname: 'KMUTT',
                              star: true,
                              point: 55555,
                            ),
                            const OrgListScore(
                              orgname: 'CU',
                              star: false,
                              point: 5555555555,
                            ),
                            const OrgListScore(
                              orgname: 'MU',
                              star: false,
                              point: 5,
                            ),
                            const OrgListScore(
                              orgname: 'KMUTL',
                              star: false,
                              point: 5,
                            ),
                          ],
                        ),
                      ),
                    ])),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'We have saved food',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter'),
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
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                            child: Text(
                          "$hh score board",
                          style: FontsTheme.mouseMemoirs_30White()
                              .copyWith(color: Colors.white),
                        )),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          width: screenWidth * 0.9,
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
                              Text(
                                "Thung Khru",
                                style: FontsTheme.mouseMemoirs_25().copyWith(
                                    color: Colors.white, letterSpacing: 1),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.change_circle,
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${NumberFormat('#,###').format(totalpoint)} points score',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const OrgListScore(
                              orgname: 'You',
                              star: true,
                              point: 55555,
                            ),
                            const OrgListScore(
                              orgname: 'Member',
                              star: false,
                              point: 5555555555,
                            ),
                            const OrgListScore(
                              orgname: 'Member',
                              star: false,
                              point: 5,
                            ),
                          ],
                        ),
                      ),
                    ])),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your household have saved food',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter'),
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
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                            child: Text(
                          "$org score board",
                          style: FontsTheme.mouseMemoirs_30White()
                              .copyWith(color: Colors.white),
                        )),
                      ),
                      Container(
                          padding: const EdgeInsets.all(10),
                          width: screenWidth * 0.9,
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
                              Text(
                                "Thung Khru",
                                style: FontsTheme.mouseMemoirs_25().copyWith(
                                    color: Colors.white, letterSpacing: 1),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.change_circle,
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: screenWidth * 0.9,
                        decoration: const BoxDecoration(
                          color: AppTheme.mainBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${NumberFormat('#,###').format(totalpoint)} points score',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const OrgListScore(
                              orgname: 'You',
                              star: true,
                              point: 55555,
                            ),
                            const OrgListScore(
                              orgname: 'Member#1',
                              star: false,
                              point: 5555555555,
                            ),
                            const OrgListScore(
                              orgname: 'Member#2',
                              star: false,
                              point: 5,
                            ),
                            const OrgListScore(
                              orgname: 'Member#3',
                              star: false,
                              point: 5,
                            ),
                          ],
                        ),
                      ),
                    ])),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  width: screenWidth * 0.9,
                  decoration: const BoxDecoration(
                    color: AppTheme.mainBlue,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your organization have saved food',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(wastedpoint)} grams',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // pie chart
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: AppTheme.softBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => context.push('/dashboard_inter'),
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
