import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/api/dashboardapi.dart';
import 'package:foodhero/pages/interorg/interorganization.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/interorg/barchart.dart';
import 'package:foodhero/widgets/interorg/foodtype_piechart.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:foodhero/widgets/interorg/price_piechart.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InterDashboard extends StatefulWidget {
  const InterDashboard({super.key, required this.page});
  final String page;

  @override
  State<InterDashboard> createState() => _InterDashboardState();
}

class _InterDashboardState extends State<InterDashboard> {
  final cs.CarouselSliderController buttonCarouselController =
      cs.CarouselSliderController();

  late String currentPage = widget.page;
  late Future<dynamic> apiWasteData;
  late Future<dynamic> apiWasteByTyepData;
  late Future<dynamic> apiExpenseData;
  late Future<dynamic> apiBarChartData;

  @override
  void initState() {
    super.initState();
    apiWasteData = _fetchWasteData(currentPage);
    apiWasteByTyepData = _fetchWasteByTypeData(currentPage);
    apiExpenseData = _fetchExpenseData(currentPage);
    apiBarChartData = _fetchBarChartData(currentPage);
  }

  Future<dynamic> _fetchWasteData(String page) async {
    try {
      if (page == 'hh') {
        return await DashboardApi().getHHWastePie(); // Call HH API
      } else if (page == 'org') {
        return await DashboardApi().getOrgWastePie(); // Call Org API
      } else if (page == 'inter') {
        return await DashboardApi().getInterWastePie(); // Call Inter Org API
      } else {
        throw Exception('Invalid page type: $page');
      }
    } catch (e) {
      print('Error loading waste data: $e');
      return Future.error(e); // Return the error message
    }
  }

  Future<dynamic> _fetchExpenseData(String page) async {
    try {
      if (page == 'hh') {
        return await DashboardApi().getHHExpensePie(); // Call HH API
      } else if (page == 'org') {
        return await DashboardApi().getOrgExpensePie(); // Call Org API
      } else {
        throw Exception('Invalid page type: $page');
      }
    } catch (e) {
      print('Error loading expense data: $e');
      return Future.error(e); // Return the error message
    }
  }

  Future<dynamic> _fetchWasteByTypeData(String page) async {
    try {
      if (page == 'hh') {
        return await DashboardApi().getHHWasteTypePie();
      } else if (page == 'org') {
        return await DashboardApi().getOrgWasteTypePie(); // Call Org API
      }
    } catch (e) {
      print('Error loading waste type data: $e');
      return Future.error(e);
    }
  }

  Future<dynamic> _fetchBarChartData(String page) async {
    try {
      if (page == 'hh') {
        return await DashboardApi().getHHBar();
        // } else if (page == 'org') {
        //   return await DashboardApi().getOrgWasteBarChart();
      }
    } catch (e) {
      print('Error loading bar chart data: $e');
      return Future.error(e);
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
  // void _changePage(String page) {
  //   setState(() {
  //     currentPage = page;
  //     apiData = _fetchData(currentPage); // Fetch new data when page changes
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    List<Widget> carouselItems = [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppTheme.softBlue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Heatmap calendar"),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeatMapChart(),
              ],
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppTheme.softBlue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: FutureBuilder<dynamic>(
          future: apiWasteData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!;

              // Safely handle null values with null-aware operators and provide defaults
              final double wastePercent =
                  data.statistic.percentWaste ?? 0; // Fetch waste percentage
              final double eatenPercent =
                  data.statistic.percentConsume ?? 0; // Fetch eaten percentage

              // If both percentages are 0, show a message instead of an empty chart
              if (wastePercent == 0 && eatenPercent == 0) {
                return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                        child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 20),
                    )));
              }

              return Container(
                // padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Consumption vs Waste',
                      style: TextStyle(fontSize: 20),
                    ),
                    WastePiechart(
                      wastepercent: wastePercent,
                      eatenpercent: eatenPercent,
                    ),
                    BuildWastePieLegend(
                      wastepercent: wastePercent,
                      eatenpercent: eatenPercent,
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppTheme.softBlue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: FutureBuilder<dynamic>(
          future: apiBarChartData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            } else {
              final data =
                  (snapshot.data!.weekList as List<dynamic>).map((stat) {
                return BarData(
                  label: stat.date,
                  percent: stat.percent,
                );
              }).toList();

              // Parse and sort the data by date
              data.sort((a, b) {
                DateTime dateA = DateFormat('EEE MMM dd yyyy').parse(a.label);
                DateTime dateB = DateFormat('EEE MMM dd yyyy').parse(b.label);
                return dateA.compareTo(dateB);
              });

              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Daily Food Consumption",
                        style: TextStyle(fontSize: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("%",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
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
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text('Statistics'),
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
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Amount of food waste",
              style: FontsTheme.mouseMemoirs_30Black(),
            ),
            cs.CarouselSlider(
              items: carouselItems,
              options: cs.CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                aspectRatio: 1,
                initialPage: 1,
                onPageChanged: (index, reason) {},
              ),
            ),
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
                  Text(
                    "Type of food waste",
                    style: FontsTheme.mouseMemoirs_30Black(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: FutureBuilder<dynamic>(
                      future: apiWasteByTyepData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('No data available'),
                          );
                        } else {
                          final data =
                              (snapshot.data!.statistic as List<dynamic>)
                                  .map((stat) {
                            return ChartData(
                              name: _getFoodTypeName(stat.category),
                              value: stat.percentWaste,
                              color: _getFoodTypeColor(stat.category),
                              category: stat.category,
                            );
                          }).toList();

                          return Column(
                            children: [
                              WasteTypePiechart(
                                chartData: data,
                              ),
                              BuildPieLegend(
                                chartData: data,
                                title: "Food type",
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                width: screenWidth * 0.95,
                decoration: const BoxDecoration(
                  color: AppTheme.softBlue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(children: [
                  Text(
                    "Price of food waste",
                    style: FontsTheme.mouseMemoirs_30Black(),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: FutureBuilder<dynamic>(
                      future: apiExpenseData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('No data available'),
                          );
                        } else {
                          final data = snapshot.data!;
                          final double savedPercent =
                              data.statistic.percentSaved ?? 0;
                          final double lostPercent =
                              data.statistic.percentLost ?? 0;

                          if (savedPercent == 0 && lostPercent == 0) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppTheme.softBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: const Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              PricePiechart(
                                  savedpercent: savedPercent,
                                  lostpercent: lostPercent),
                              BuildExpensePieLegend(
                                  savedpercent: savedPercent,
                                  lostpercent: lostPercent)
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
