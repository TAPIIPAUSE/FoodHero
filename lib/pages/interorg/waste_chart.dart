import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/interorg/heatmap.dart';
import 'package:foodhero/widgets/interorg/price_piechart.dart';
import 'package:foodhero/widgets/interorg/reason_piechart.dart';
import 'package:foodhero/widgets/interorg/barchart.dart';
import 'package:foodhero/widgets/interorg/waste_piechart.dart';
import 'package:foodhero/widgets/interorg/wastetype_piechart.dart';
import 'package:go_router/go_router.dart';

class WasteChart extends StatelessWidget {
  const WasteChart({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            title: const Text('Statistics'),
            centerTitle: true,
            backgroundColor: AppTheme.greenMainTheme,
            titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
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
                  // Container(
                  //   padding: const EdgeInsets.all(10),
                  //   decoration: const BoxDecoration(
                  //     color: AppTheme.softBlue,
                  //     borderRadius: BorderRadius.all(Radius.circular(20)),
                  //   ),
                  //   child: const WastePiechart(),
                  // ),
                ],
              ))
        ]),
      ),
    );
  }
}
