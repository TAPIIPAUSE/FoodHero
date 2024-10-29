class HouseholdFoodWastePieData {
  final String message;
  final Statistic statistic;

  HouseholdFoodWastePieData({
    required this.message,
    required this.statistic,
  });

  factory HouseholdFoodWastePieData.fromJson(Map<String, dynamic> json) {
    return HouseholdFoodWastePieData(
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
  final int waste;
  final int consume;
  final int total;
  final double? percentConsume;
  final double? percentWaste;

  Statistic({
    required this.waste,
    required this.consume,
    required this.total,
    this.percentConsume,
    this.percentWaste,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      waste: json['Waste'],
      consume: json['Consume'],
      total: json['Total'],
      percentConsume: json['Percent_Consume'] != null
          ? (json['Percent_Consume'] as num).toDouble()
          : null,
      percentWaste: json['Percent_Waste'] != null
          ? (json['Percent_Waste'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Waste': waste,
      'Consume': consume,
      'Total': total,
      'Percent_Consume': percentConsume,
      'Percent_Waste': percentWaste,
    };
  }
}
