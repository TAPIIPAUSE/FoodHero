class HHWasteTypePie {
  final String message;
  final List<Statistic> statistic;

  HHWasteTypePie({
    required this.message,
    required this.statistic,
  });

  factory HHWasteTypePie.fromJson(Map<String, dynamic> json) {
    return HHWasteTypePie(
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
      'Statistic': statistic.map((item) => item.toJson()).toList(),
    };
  }
}

class Statistic {
  final int category;
  final int waste;
  final int consume;
  final int total;
  final double percentConsume;
  final double percentWaste; //ues this

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      category: json['Category'],
      waste: json['Waste'] ?? 0,
      consume: json['Consume'] ?? 0,
      total: json['Total'] ?? 0,
      percentConsume: (json['Percent_Consume'] ?? 0).toDouble(),
      percentWaste: (json['Percent_Waste'] ?? 0).toDouble(),
    );
  }

  Statistic(
      {required this.category,
      required this.waste,
      required this.consume,
      required this.total,
      required this.percentConsume,
      required this.percentWaste});

  Map<String, dynamic> toJson() {
    return {
      'Category': category,
      'Waste': waste,
      'Consume': consume,
      'Total': total,
      'Percent_Consume': percentConsume,
      'Percent_Waste': percentWaste
    };
  }
}
