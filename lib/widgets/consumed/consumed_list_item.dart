// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:foodhero/pages/api/consumedfood_api.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:foodhero/pages/consumed/consumedDetails.dart';
import 'package:foodhero/theme.dart';

class ConsumedListItem extends StatefulWidget {
  const ConsumedListItem({
    super.key,
    required this.thumbnail,
    required this.foodname,
    required this.expiry,
    required this.progressbar,
    required this.consuming,
    required this.remaining,
    required this.cID,
  });

  final String thumbnail;
  final String foodname;
  final String expiry;
  final double progressbar;
  final String consuming;
  final String remaining;
  final int cID;

  @override
  State<ConsumedListItem> createState() => _ConsumedListItemState();
}

class _ConsumedListItemState extends State<ConsumedListItem> {
  // late int cID;

  // @override
  // void initState() {
  //   super.initState();
  //   SharedPreferences.getInstance().then((prefs) {
  //     final cID = prefs.getInt('consume_ID');
  //     setState(() {
  //       this.cID = cID!;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConsumedDetails(
              cID: widget.cID,
            ),
          ),
        );
      },
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
                        child:
                            // Image.network(
                            //   thumbnail,
                            //   errorBuilder: (context, error, stackTrace) {
                            //     return Image.network(
                            //         'https://picsum.photos/250?image=9');
                            //     // return Image.asset('assets/images/fhlogo.png');
                            //   },
                            //   loadingBuilder: (context, child, loadingProgress) {
                            //     if (loadingProgress == null) return child;
                            //     return const Center(
                            //         child: CircularProgressIndicator());
                            //   },
                            //   fit: BoxFit.cover,
                            //   width: MediaQuery.of(context).size.width * 0.1,
                            //   height: MediaQuery.of(context).size.height * 0.12,
                            // ),
                            Image.network(
                          widget.thumbnail,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Could not load image');
                          },
                        )
                        //     CachedNetworkImage(
                        //   imageUrl: thumbnail,
                        //   placeholder: (context, url) =>
                        //       const CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) =>
                        //       const Center(child: Icon(Icons.image)),
                        // )),
                        ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _FoodDetail(
                      foodname: widget.foodname,
                      expiry: DateTime.parse(widget.expiry),
                      progessbar: widget.progressbar,
                      consumeing: widget.consuming,
                      remaining: widget.remaining,
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
      ),
    );
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
  final double progessbar;
  final String consumeing;
  final String remaining;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                foodname,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Remaining',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
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
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 1.0),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                    Text(
                      DateFormat('dd/MM/yyyy').format(expiry),
                      style: const TextStyle(fontSize: 10.0),
                    ),
                    LinearPercentIndicator(
                      padding: const EdgeInsets.only(left: 0),
                      width: MediaQuery.of(context).size.width * 0.3,
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
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppTheme.softRed,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Consuming',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
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
              ]),
        ],
      ),
    );
  }
}
