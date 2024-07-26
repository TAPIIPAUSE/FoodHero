import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class household extends StatefulWidget {
  @override
  _HouseholdState createState() => _HouseholdState();
}

class _HouseholdState extends State<household> {
  late String _todayDate;
  late String _weekday;
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _updateDate();
  }

  void _updateDate() {
    final now = DateTime.now();
    _todayDate = DateFormat('EEEE d MMMM yyyy').format(now); // Full format
    _weekday = weekdays[now.weekday - 1]; // Adjust for index starting from 0
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Map<String, dynamic>> members = [
    {"name": "You", "score": 24058},
    {"name": "Dad", "score": 24024},
    {"name": "Mom", "score": 18547},
    {"name": "Brother", "score": 17245},
  ];

  List<Widget> generateBarChart() {
    // Generate bar chart data dynamically
    return List.generate(3, (index) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (barIndex) {
          return Column(
            children: [
              Container(
                height: 100, // height of the bar
                width: 20, // width of the bar
                color: barIndex == _current ? Colors.orange : Colors.grey,
              ),
              SizedBox(height: 5),
              Text('Day ${barIndex + 1}'),
            ],
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreenBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.greenMainTheme,
        toolbarHeight: 90,
        centerTitle: true,
        title: Text('Household'),
        titleTextStyle: FontsTheme.mouseMemoirs_64Black(),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Date and Day
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Today $_todayDate', style: FontsTheme.hindBold_20()),
                  SizedBox(width: 10),
                  Chip(
                    label:
                        Text(_weekday, style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Bar chart with carousel
              CarouselSlider(
                items: generateBarChart(),
                carouselController: _controller,
                options: CarouselOptions(
                  height: 150,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Text(
                'Statistics',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: generateBarChart().map((widget) {
                  int index = generateBarChart().indexOf(widget);
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(index),
                    child: Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? Colors.orange : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              // Members section

              Card(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: members.map((member) {
                      return ListTile(
                        title: Text(
                          member["name"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          member["score"].toString(),
                          style:
                              TextStyle(fontSize: 20, color: Colors.blueAccent),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Progress bar
              LinearPercentIndicator(
                lineHeight: 20.0,
                percent: 0.32,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.orange,
              ),
              Text("Reached 32% this month"),
              SizedBox(height: 20),
              // Create a goal button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.greenMainTheme,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                child: Text('Create a goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
