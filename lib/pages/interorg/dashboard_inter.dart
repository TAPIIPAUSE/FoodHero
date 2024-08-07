import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';
import 'package:go_router/go_router.dart';

class InterDashboard extends StatefulWidget {
  const InterDashboard({super.key});

  @override
  State<InterDashboard> createState() => _InterDashboardState();
}

class _InterDashboardState extends State<InterDashboard> {
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    List<Container> carouselItems = [
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
        child: const WasteBarchart(),
      )
    ];

    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text('Statistics'),
            centerTitle: true,
            backgroundColor: AppTheme.greenMainTheme,
            titleTextStyle: FontsTheme.mouseMemoirs_64(color: Colors.white),
            leading: IconButton.filled(
              onPressed: () => context.push(''),
              icon: const Icon(
                Icons.person_sharp,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
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
            const Text("Amount of food waste"),
            CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
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
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.mainBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
