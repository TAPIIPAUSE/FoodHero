import 'package:flutter/material.dart';
import 'package:foodhero/fonts.dart';
import 'package:foodhero/models/fooddetail_model.dart';
import 'package:foodhero/pages/foodDetails.dart';

import 'package:foodhero/theme.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class InventoryListItem extends StatelessWidget {
  //final FoodDetailData item;
  // final int hID;
  final int foodid;
  final String foodname;
  final String img;
  //  final String location;
  // // final String food_category;
  //  final bool isCountable;
  // final String weight_type;
  // final String package_type;
  // final int current_amount;
  // final int total_amount;
  // final int consumed_amount;
  // final int current_quantity;
  // final int total_quanitity;
  // final int consumed_quantity;
  // final int total_price;
  // final String bestByDate;
  final String consuming;
  final String remaining;
  final DateTime expired;
  // final String remind;
  // final int TotalCost;
  // final int IndividualWeight;
  // final int IndividualCost;

  // final String thumbnail;
  // final String foodname;
  //final String expiry;
  final double progressbar;
  // final int consuming;
  // final int remaining;
  const InventoryListItem({
    //required this.item,
    // super.key,
    //required this.hID,
    required this.foodid,
    required this.foodname,
    required this.img,
    //  required this.location,
    //   // required this.food_category,
    //    required this.isCountable,
    // required this.weight_type,
    // required this.package_type,
    // required this.current_amount,
    // required this.total_amount,
    // required this.consumed_amount,
    // required this.current_quantity,
    // required this.total_quanitity,
    // required this.consumed_quantity,
    // required this.total_price,
    // required this.bestByDate,
    required this.expired,
    // // required this.remind,
    required this.progressbar,
    required this.consuming,
    required this.remaining,
    // required this.location,
    // required this.isCountable,
    // required this.TotalCost, required this.IndividualWeight, required this.IndividualCost,
  });

//  factory InventoryListItem.fromJson(Map<String, dynamic> json) {
//     return InventoryListItem(

//       hID: json['hID'],
//       img: json['img'],
//       food_name: json['food_name'],
//       location: json['location'],
//       food_category: json['food_category'],
//       weight_type: json['weight_type'],
//       package_type: json['package_type'],
//       isCountable: json['isCountable'],
//       current_amount: json['current_amount'],
//       total_amount: (json['total_amount']),
//       consumed_amount: (json['consumed_amount']),
//       current_quantity: (json['current_quantity']),
//       total_quanitity: (json['total_quanitity']),
//       consumed_quantity: (json['consumed_quantity']),
//       total_price: (json['total_price']),
//       bestByDate: (json['bestByDate']),
//       RemindDate: (json['RemindDate']),
//       progressbar: (json['']),
//       consuming: (json['consumed_quantity']),
//       remaining: (json['']),
//     );
//   }
  // DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return //Blue Food banner
        Padding(
            padding: EdgeInsets.only(right: 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the value as needed
                            child: Image.network(
                              img.toString(),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.12,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTKrjn08eRggR5MYJ-xIoB_bIv0Rlb8PjpKKZal_Vw6y7Yb-Ayz&usqp=CAU");
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: _FoodDetail(
                            foodname: foodname,
                            expiry: expired,
                            progessbar: 10,
                            consumeing: consuming,
                            remaining: remaining,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ));
  }
}

class _FoodDetail extends StatelessWidget {
  const _FoodDetail({
    required this.foodname,
    required this.expiry,
    required this.progessbar,
    required this.consumeing,
    required this.remaining,
  });

  final String foodname;
  final DateTime expiry;
  final int progessbar;
  final String consumeing;
  final String remaining;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 1.0),
              ),
              Text(foodname,
                  style: FontsTheme.mouseMemoirs_30Black()
                      .copyWith(letterSpacing: 1)),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Remaining', style: FontsTheme.hind_15()),
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: AppTheme.softGreen,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              remaining.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: AppTheme.softRed,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Text('Consuming', style: FontsTheme.hind_15()),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            consumeing.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0)),
                        Text(
                          'Expired ${DateFormat('dd/MM/yyyy').format(expiry)}',
                          // expiry,
                          style: FontsTheme.hind_15(),
                        ),
                        LinearPercentIndicator(
                          padding: const EdgeInsets.only(left: 0),
                          width: MediaQuery.of(context).size.width * 0.5,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2000,
                          percent: progessbar / 100,
                          center: Text('${progessbar.toString()}%'),
                          barRadius: const Radius.circular(10.0),
                          progressColor: AppTheme.softOrange,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ]),
            ],
          ),
        ],
      ),
    );
  }
}
