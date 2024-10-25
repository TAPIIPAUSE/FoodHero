import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';

const dcolor = AppTheme.softRedCancleWasted;

List<BarChartGroupData> reasonbarChartGroupData = [
  BarChartGroupData(x: 1, barRods: [
    BarChartRodData(
        toY: 10,
        color: Colors.amber,
        width: 15,
        borderRadius: BorderRadius.circular(20)),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(toY: 8.5, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(toY: 12.6, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(toY: 11.4, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(toY: 7.5, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(toY: 14, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 7, barRods: [
    BarChartRodData(toY: 12.2, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 8, barRods: [
    BarChartRodData(toY: 12.6, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 9, barRods: [
    BarChartRodData(toY: 11.4, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 10, barRods: [
    BarChartRodData(toY: 7.5, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 11, barRods: [
    BarChartRodData(toY: 14, color: dcolor, width: 15),
  ]),
  BarChartGroupData(x: 12, barRods: [
    BarChartRodData(toY: 12.2, color: dcolor, width: 15),
  ]),
];
