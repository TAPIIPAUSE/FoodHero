class HHExpensePieData {
  final String message;
  final Statistic statistic;

  HHExpensePieData({
    required this.message,
    required this.statistic,
  });

  factory HHExpensePieData.fromJson(Map<String, dynamic> json) {
    return HHExpensePieData(
      message: json['Messages'] ?? '', // Handle null message
      statistic: Statistic.fromJson(json['Statistic']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Messages': message,
      'Statistic': statistic.toJson(),
    };
  }
}

class Statistic {
  final int lost;
  final int saved;
  final int total;
  final double? percentSaved;
  final double? percentLost;

  Statistic({
    required this.lost,
    required this.saved,
    required this.total,
    this.percentSaved,
    this.percentLost,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      lost: json['Lost'],
      saved: json['Saved'],
      total: json['Total'],
      percentSaved: json['Percent_Saved'] != null
          ? (json['Percent_Saved'] as num).toDouble()
          : null,
      percentLost: json['Percent_Lost'] != null
          ? (json['Percent_Lost'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Lost': lost,
      'Saved': saved,
      'Total': total,
      'Percent_Saved': percentSaved,
      'Percent_Lost': percentLost,
    };
  }
}
