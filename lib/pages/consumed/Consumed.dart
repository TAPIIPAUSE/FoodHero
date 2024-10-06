import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/main.dart';
import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
import 'package:foodhero/theme.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Consumed extends StatefulWidget {
  @override
  State<Consumed> createState() => _ConsumedState();
}

class _ConsumedState extends State<Consumed> {
  @override
  Widget build(BuildContext context) {
    final consumedItems =
        Provider.of<ConsumedItemsProvider>(context).consumedItems;
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
              icon: const Icon(
                Icons.person,
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                // Column(
                // children: [
                //   const InventoryListItem(
                //     thumbnail: "assets/images/banana.jpg",
                //     foodname: 'Banana',
                //     expiry: '2 weeks',
                //     progressbar: 40,
                //     consuming: 5,
                //     remaining: 5,
                //   ),
                //   const InventoryListItem(
                //     thumbnail: "assets/images/tomatoes.jpg",
                //     foodname: 'Tomatos',
                //     expiry: '3 days left',
                //     progressbar: 20.3,
                //     consuming: 5,
                //     remaining: 7,
                //   ),
                //   const InventoryListItem(
                //     thumbnail: "assets/images/apples.jpg",
                //     foodname: 'Apple',
                //     expiry: '3 days left',
                //     progressbar: 60.57,
                //     consuming: 5,
                //     remaining: 7,
                //   ),
                //   const InventoryListItem(
                //     thumbnail: "assets/images/banana.jpg",
                //     foodname: 'Banana',
                //     expiry: '2 weeks',
                //     progressbar: 40,
                //     consuming: 5,
                //     remaining: 5,
                //   ),
                // ],

                //  ),

                consumedItems.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                            SizedBox(
                              height: 300,
                            ),
                            Text(
                              'No items consumed yet.',
                              style: FontsTheme.hindBold_30(),
                            ),
                          ])
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: consumedItems.length,
                        itemBuilder: (context, index) {
                          final item = consumedItems[index];
                          return ConsumedListItem(
                              thumbnail: item.thumbnail,
                              foodname: item.foodname,
                              expiry: item.expiry,
                              progressbar: item.progressbar,
                              consuming: item.consuming,
                              remaining: item.remaining);
                        },
                      ),
          ),
        ));
  }
}
