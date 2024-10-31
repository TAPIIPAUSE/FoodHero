import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/api/consumedfood_api.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:foodhero/models/consumedfood_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consumed extends StatefulWidget {
  const Consumed({super.key});

  @override
  State<Consumed> createState() => _ConsumedState();
}

class _ConsumedState extends State<Consumed> {
  Future<ConsumedfoodData> _loadConsumedFood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hID = prefs.getInt('hID');
      // if (hID == null) {
      //   throw Exception('hID not found in SharedPreferences');
      // }
      print('hID from SharedPreferences: $hID'); // Debug print
      final data = await ConsumedFood().getConsumedfood(hID!);
      print('Fetched consumed food data: $data'); // Debug print
      // print('Fetched data: ${data.map((item) => item.toString())}');
      return data;
    } catch (e) {
      print('Error loading consumed food: $e'); // Debug print
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      selectedRouteIndex: 1,
      child: Scaffold(
        backgroundColor: AppTheme.lightGreenBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.greenMainTheme,
          toolbarHeight: 90,
          centerTitle: true,
          title: Text(
            "Consumed",
            style: FontsTheme.mouseMemoirs_64Black(),
          ),
          titleTextStyle: FontsTheme.mouseMemoirs_64White(),
          leading: IconButton(
            onPressed: () => context.push(''),
            icon: const Icon(Icons.person),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: FutureBuilder<ConsumedfoodData>(
            future: _loadConsumedFood(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data==null) {
                return const Center(
                    child: Text('No consumed food data available.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.documentNumber,
                  itemBuilder: (context, index) {
                    final item = snapshot.data!.food[index];
                    return ConsumedListItem(
                      cID: item.consumeId,
                      thumbnail: item.url,
                      foodname: item.foodName,
                      expiry: item.expired,
                      progressbar:
                          10, // You might want to calculate this based on item data
                      consuming: item.consuming,
                      remaining: item.remaining,
                      isCountable: item.isCountable,
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
