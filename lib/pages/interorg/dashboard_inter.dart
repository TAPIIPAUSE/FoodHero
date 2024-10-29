import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/pages/api/dashboardapi.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/barchart.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';
import 'package:go_router/go_router.dart';

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
  late Future<dynamic> apiData;

  @override
  void initState() {
    super.initState();
    apiData = _fetchData(currentPage);
  }

  Future<dynamic> _fetchData(String page) async {
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
      print('Error loading data: $e');
      return Future.error(e); // Return the error message
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
      FutureBuilder<dynamic>(
        future: apiData,
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
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppTheme.softBlue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: WastePiechart(
                wastepercent: wastePercent,
                eatenpercent: eatenPercent,
              ),
            );
          }
        },
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: AppTheme.softBlue,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Bar chart"),
            WasteBarchart(
                color: AppTheme.softBlue, chart: WasteBarChartContent()),
          ],
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
                autoPlay: false, // Enable auto-play
                enlargeCenterPage: true, // Increase the size of the center item
                enableInfiniteScroll: false, // Enable infinite scroll
                aspectRatio: 1,
                initialPage: 1, // Set the initial page index
                onPageChanged: (index, reason) {
                  // Optional callback when the page changes
                  // You can use it to update any additional UI components
                },
              ),
            ),
            // IconButton(
            //   onPressed: () => context.push('/waste_chart'),
            //   icon: const Icon(
            //     Icons.keyboard_arrow_down_rounded,
            //     color: AppTheme.mainBlue,
            //   ),
            // ),
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
                  Text(
                    "Type of food waste",
                    style: FontsTheme.mouseMemoirs_30White(),
                  ),
                  // const WasteTypePiechart(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Price of food waste",
                    style: FontsTheme.mouseMemoirs_30White(),
                  ),
                  // const PricePiechart(),
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
                color: AppTheme.mainBlue,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    "Reason of food waste",
                    style: FontsTheme.mouseMemoirs_30White(),
                  ),
                  // const ReasonPiechart(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Reason trends",
                    style: FontsTheme.mouseMemoirs_30White(),
                  ),
                  const WasteBarchart(
                      color: Colors.white, chart: ReasonBarChartContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
