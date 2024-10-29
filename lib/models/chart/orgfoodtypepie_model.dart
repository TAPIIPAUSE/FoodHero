class OrgFoodTypePie {
  final String message;
  final List<Statistic> statistic;

  OrgFoodTypePie({
    required this.message,
    required this.statistic,
  });

  factory OrgFoodTypePie.fromJson(Map<String, dynamic> json) {
    return OrgFoodTypePie(
      message: json['Messages'] ?? '', // Handle null message
      statistic: (json['Statistic'] as List)
          .map((item) => Statistic.fromJson(item))
          .toList()
      // Statistic.fromJson(json['Statistic']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Messages': message,
      'Statistic': statistic.map((item)=>item.toJson()).toList(),
    };
  }
}

class Statistic {
  final int category;
  final int waste;
  final int consume;
  final int total;
  final double percent;

  factory  Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      category: json['Category'],
      waste: json['Waste'],
      consume: json['Consume'],
      total: json['Total'],
      percent: json['Percent'],
    );
  }

  Statistic({required this.category, required this.waste, required this.consume, required this.total, required this.percent});

  Map<String, dynamic> toJson() {
    return {
      'Category': category,
      'Waste': waste,
      'Consume': consume,
      'Total': total,
      'Percent': percent,
    };
  }
}