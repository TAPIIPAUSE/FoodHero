import 'package:intl/intl.dart';

class OrgHeatmapData {
  final String message;
  final List<Statistic> statistic;

  OrgHeatmapData({
    required this.message,
    required this.statistic,
  });

  factory OrgHeatmapData.fromJson(Map<String, dynamic> json) {
    return OrgHeatmapData(
      message: json['Messages'] ?? '', // Handle null message
      statistic: (json['Statistic'] as List<dynamic>)
          .map((item) => Statistic.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'Messages': message,
  //     'Statistic': statistic.toJson(),
  //   };
  // }
}

class Statistic {
  final DateTime date;
  final int waste;
  final int total;
  final int? percentWaste;

  Statistic({
    required this.date,
    required this.waste,
    required this.total,
    this.percentWaste,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
        date: DateFormat('EEE MMM dd yyyy').parse(json['Date']),
        waste: json['Waste'],
        total: json['Total'],
        percentWaste: json['Percent_Waste'] != null
            ? (json['Percent_Waste'] as num).toInt()
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'Date': date,
      'Waste': waste,
      'Total': total,
      'Percent_Waste': percentWaste,
    };
  }
}
