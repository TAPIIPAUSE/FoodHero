import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:foodhero/widgets/interorg/waste_barchart.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';
import 'package:go_router/go_router.dart';

class UserWasteChart extends StatelessWidget {
  const UserWasteChart({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
          title: const Text('Your Statistics'),
          centerTitle: true,
          backgroundColor: AppTheme.greenMainTheme,
          titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          const Text("Amount of food waste"),
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
                  const SizedBox(
                    height: 10,
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
                            color: AppTheme.softBlue,
                            chart: WasteBarChartContent()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppTheme.softBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const WastePiechart(),
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
