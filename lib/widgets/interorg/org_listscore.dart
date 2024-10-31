import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:foodhero/theme.dart';

class ListScore extends StatelessWidget {
  const ListScore({
    super.key,
    required this.name,
    required this.star,
    required this.point,
    required this.rank,
  });

  final String name;
  final bool star;
  final double point;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  rank.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (star == true)
                      const Icon(Icons.star_rate_rounded,
                          color: AppTheme.softOrange),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: AppTheme.softGreen,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            point == 0
                                ? '0'
                                : NumberFormat('#,##0.00').format(point),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
