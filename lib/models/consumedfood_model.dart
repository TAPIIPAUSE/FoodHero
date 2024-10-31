class ConsumedfoodData {
  final int documentNumber;
  final List<Food> food;

  ConsumedfoodData({
    required this.documentNumber,
    required this.food,
  });

  factory ConsumedfoodData.fromJson(Map<String, dynamic> json) {
    return ConsumedfoodData(
      documentNumber: json['Document_Number'] as int,
      food:
          (json['food'] as List<dynamic>).map((e) => Food.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Document_Number': documentNumber,
      'food': food.map((e) => e.toJson()).toList(),
    };
  }
}

class Food {
  final int consumeId;
  final int foodId;
  final String foodName;
  final DateTime expired;
  final String consuming;
  final String remaining;
  final String url;
  final bool isCountable;

  Food({
    required this.consumeId,
    required this.foodId,
    required this.foodName,
    required this.expired,
    required this.consuming,
    required this.remaining,
    required this.url,
    required this.isCountable,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      consumeId: json['Consume_ID'] as int,
      foodId: json['Food_ID'] as int,
      foodName: json['FoodName'] as String,
      expired: DateTime.parse(json['Expired'] as String),
      consuming: json['Consuming'] as String,
      remaining: json['Remaining'] as String,
      url: json['URL'] as String,
      isCountable: json['isCountable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Consume_ID': consumeId,
      'Food_ID': foodId,
      'FoodName': foodName,
      'Expired': expired.toIso8601String(),
      'Consuming': consuming,
      'Remaining': remaining,
      'URL': url,
      'isCountable': isCountable,
    };
  }
}
