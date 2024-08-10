import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/data/chartdata/reason_barchart_data.dart';
import 'package:foodhero/data/chartdata/waste_barchart_data.dart';
import 'package:foodhero/utils/constants.dart';

class WasteBarchart extends StatelessWidget {
  final Color color;
  final Widget chart;
  const WasteBarchart({super.key, required this.color, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 0.95 * 0.65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: chart,
            ))
          ],
        ),
      ),
    );
  }
}

class WasteBarChartContent extends StatelessWidget {
  const WasteBarChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  getTitleText(value),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 4,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() == 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: BarChartAlignment.spaceEvenly,
        maxY: 16,
        barGroups: wastebarChartGroupData,
      ),
    );
  }

  String getTitleText(double value) {
    switch (value.toInt()) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return '';
    }
  }
}

class ReasonBarChartContent extends StatelessWidget {
  const ReasonBarChartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  getTitleText(value),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 4,
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() == 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          border: Border.all(color: Colors.black, width: 0.5),
        ),
        alignment: BarChartAlignment.spaceEvenly,
        maxY: 16,
        barGroups: reasonbarChartGroupData,
      ),
    );
  }

  String getTitleText(double value) {
    switch (value.toInt()) {
      case 1:
        return january;
      case 2:
        return february;
      case 3:
        return march;
      case 4:
        return april;
      case 5:
        return may;
      case 6:
        return june;
      case 7:
        return july;
      case 8:
        return august;
      case 9:
        return september;
      case 10:
        return october;
      case 11:
        return november;
      case 12:
        return december;
      default:
        return '';
    }
  }
}
