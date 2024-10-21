class InventoryFoodData {
  final int foodid;
  final String foodname;
  final String expired;
  final String consuming;
  final String remaining;
  final String url;
  final String category;
  final bool isCountable;

  factory InventoryFoodData.fromJson(Map<String, dynamic> json) {
    return InventoryFoodData(
      foodid: json['Food_ID'],
      foodname: json['FoodName'],
      expired: json['Expired'],
      consuming: json['Consuming'],
      remaining: json['Remaining'],
      url: json['URL'],
      category: json['Category'],
      isCountable: json['isCountable'],
    );
  }

  InventoryFoodData(
      {required this.foodid,
      required this.foodname,
      required this.expired,
      required this.consuming,
      required this.remaining,
      required this.url,
      required this.category,
      required this.isCountable});
}
