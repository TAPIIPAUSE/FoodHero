// import 'package:flutter/material.dart';
// import 'package:foodhero/fonts.dart';
// import 'package:foodhero/main.dart';
// import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
// import 'package:foodhero/theme.dart';
// import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class Consumed extends StatefulWidget {
//   @override
//   State<Consumed> createState() => _ConsumedState();
// }

// class _ConsumedState extends State<Consumed> {
//   @override
//   Widget build(BuildContext context) {
//     final consumedItems =
//         Provider.of<ConsumedItemsProvider>(context).consumedItems;
//     return MainScaffold(
//         selectedRouteIndex: 1,
//         child: Scaffold(
//           backgroundColor: AppTheme.lightGreenBackground,
//           appBar: AppBar(
//             backgroundColor: AppTheme.greenMainTheme,
//             toolbarHeight: 90,
//             centerTitle: true,
//             title: Text(
//               "Consumed",
//               style: FontsTheme.mouseMemoirs_64Black(),
//             ),
//             titleTextStyle: FontsTheme.mouseMemoirs_64White(),
//             leading: IconButton(
//               onPressed: () => context.push(''),
//               icon: const Icon(
//                 Icons.person,
//               ),
//             ),
//             actions: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.notifications,
//                 ),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child:
//                 // Column(
//                 // children: [
//                 //   const InventoryListItem(
//                 //     thumbnail: "assets/images/banana.jpg",
//                 //     foodname: 'Banana',
//                 //     expiry: '2 weeks',
//                 //     progressbar: 40,
//                 //     consuming: 5,
//                 //     remaining: 5,
//                 //   ),
//                 //   const InventoryListItem(
//                 //     thumbnail: "assets/images/tomatoes.jpg",
//                 //     foodname: 'Tomatos',
//                 //     expiry: '3 days left',
//                 //     progressbar: 20.3,
//                 //     consuming: 5,
//                 //     remaining: 7,
//                 //   ),
//                 //   const InventoryListItem(
//                 //     thumbnail: "assets/images/apples.jpg",
//                 //     foodname: 'Apple',
//                 //     expiry: '3 days left',
//                 //     progressbar: 60.57,
//                 //     consuming: 5,
//                 //     remaining: 7,
//                 //   ),
//                 //   const InventoryListItem(
//                 //     thumbnail: "assets/images/banana.jpg",
//                 //     foodname: 'Banana',
//                 //     expiry: '2 weeks',
//                 //     progressbar: 40,
//                 //     consuming: 5,
//                 //     remaining: 5,
//                 //   ),
//                 // ],

//                 //  ),

//                 consumedItems.isEmpty
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                             SizedBox(
//                               height: 300,
//                             ),
//                             Text(
//                               'No items consumed yet.',
//                               style: FontsTheme.hindBold_30(),
//                             ),
//                           ])
//                     : ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemCount: consumedItems.length,
//                         itemBuilder: (context, index) {
//                           final item = consumedItems[index];
//                           return ConsumedListItem(
//                               thumbnail: item.thumbnail,
//                               foodname: item.foodname,
//                               expiry: item.expiry,
//                               progressbar: item.progressbar,
//                               consuming: item.consuming,
//                               remaining: item.remaining);
//                         },
//                       ),
//           ),
//         ));
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:foodhero/fonts.dart';
// import 'package:foodhero/main.dart';
// import 'package:foodhero/pages/api/consumedfood_api.dart';
// // import 'package:foodhero/pages/consumed/consumedItemsProvider.dart';
// import 'package:foodhero/theme.dart';
// import 'package:foodhero/widgets/consumed/consumed_list_item.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:provider/provider.dart';
// import 'package:foodhero/models/consumedfood_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Consumed extends StatefulWidget {
//   const Consumed({super.key});

//   @override
//   State<Consumed> createState() => _ConsumedState();
// }

// class _ConsumedState extends State<Consumed> {
//   @override
//   Widget build(BuildContext context) {
//     return MainScaffold(
//       selectedRouteIndex: 1,
//       child: Scaffold(
//         backgroundColor: AppTheme.lightGreenBackground,
//         appBar: AppBar(
//           backgroundColor: AppTheme.greenMainTheme,
//           toolbarHeight: 90,
//           centerTitle: true,
//           title: Text(
//             "Consumed",
//             style: FontsTheme.mouseMemoirs_64Black(),
//           ),
//           titleTextStyle: FontsTheme.mouseMemoirs_64White(),
//           leading: IconButton(
//             onPressed: () => context.push(''),
//             icon: const Icon(
//               Icons.person,
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.notifications,
//               ),
//             ),
//           ],
//         ),
//         body: FutureBuilder(
//           future: ConsumedFood().getConsumedfood(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             // Add the rest of your FutureBuilder logic here
//             return Container(); // Placeholder, replace with your actual widget
//           },
//         ),
//       ),
//     );
//   }
// } // late int hID;
// // late Future<ConsumedfoodData?> consumed;

// // @override
// // void initState() {
// //   super.initState();
// //   SharedPreferences.getInstance().then((prefs) {
// //     final hID = prefs.getInt('hID');
// //     this.hID = hID!;
// //     // consumed = getConsumedFood(hID);
// //   });

// @override
// Widget build(BuildContext context) {
//   return MainScaffold(
//       selectedRouteIndex: 1,
//       child: Scaffold(
//         backgroundColor: AppTheme.lightGreenBackground,
//         appBar: AppBar(
//           backgroundColor: AppTheme.greenMainTheme,
//           toolbarHeight: 90,
//           centerTitle: true,
//           title: Text(
//             "Consumed",
//             style: FontsTheme.mouseMemoirs_64Black(),
//           ),
//           titleTextStyle: FontsTheme.mouseMemoirs_64White(),
//           leading: IconButton(
//             onPressed: () => context.push(''),
//             icon: const Icon(
//               Icons.person,
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.notifications,
//               ),
//             ),
//           ],
//         ),
//         body: FutureBuilder(
//           future: ConsumedFood().getConsumedfood(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//               List<ConsumedfoodData> dataList = snapshot.data;
//               return Column(
//                   children: dataList.map(
//                 (item) {
//                   return Column(
//                     children: [
//                       const Text("เห็นไหม???"),
//                       ConsumedListItem(
//                           thumbnail: item.url,
//                           foodname: item.foodName,
//                           expiry: item.expired,
//                           progressbar: 10,
//                           consuming: item.consuming,
//                           remaining: item.remaining),
//                     ],
//                   );
//                 },
//               ).toList());
//             } else {
//               return const Text("No data available");
//             }
//             // {
//             //   List<ConsumedfoodData> dataList = snapshot.data;
//             //   return Column(
//             //       children: dataList.map(
//             //     (item) {
//             //       return Column(
//             //         children: [
//             //           Text("เห็นไหม???"),
//             //           ConsumedListItem(
//             //               thumbnail: item.url,
//             //               foodname: item.foodName,
//             //               expiry: item.expired,
//             //               progressbar: 10,
//             //               consuming: item.consuming,
//             //               remaining: item.remaining),
//             //         ],
//             //       );
//             //     },
//             //   ).toList());
//             // }
//           },
//         ),
//       ));
// }

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
  Future<List<ConsumedfoodData>> _loadConsumedFood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hID = prefs.getInt('hID');
      // if (hID == null) {
      //   throw Exception('hID not found in SharedPreferences');
      // }
      print('hID from SharedPreferences: $hID'); // Debug print
      final data = await ConsumedFood().getConsumedfood(hID!);
      // print('Fetched data: $data'); // Debug print
      print('Fetched data: ${data.map((item) => item.toString())}');
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
        body: FutureBuilder<List<ConsumedfoodData>>(
          future: _loadConsumedFood(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No consumed food data available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return ConsumedListItem(
                    thumbnail: item.url ?? 'assets/images/fhlogo.png',
                    foodname: item.foodName,
                    expiry: item.expired ?? '',
                    progressbar:
                        10, // You might want to calculate this based on item data
                    consuming: item.consuming,
                    remaining: item.remaining,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

}