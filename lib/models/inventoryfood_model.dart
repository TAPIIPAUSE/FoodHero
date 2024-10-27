class InventoryFoodData {
  int documentNumber;
  List<Food> foodItems;

  InventoryFoodData({
    required this.documentNumber,
    required this.foodItems,
  });

  factory InventoryFoodData.fromJson(Map<String, dynamic> json) {
    return InventoryFoodData(
      documentNumber: json['Document_Number'],
      foodItems:
          (json['food'] as List).map((item) => Food.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Document_Number': documentNumber,
      'food': foodItems.map((item) => item.toJson()).toList(),
    };
  }
}

class Food {
  int foodId;
  String foodName;
  DateTime expired;
  String consuming;
  String remaining;
  String url;
  bool isCountable;

  Food({
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
      foodId: json['Food_ID'],
      foodName: json['FoodName'],
      expired: DateTime.parse(json['Expired']),
      consuming: json['Consuming'],
      remaining: json['Remaining'],
      url: json['URL'],
      isCountable: json['isCountable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
