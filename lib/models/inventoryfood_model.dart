class InventoryFoodData {
  final int foodid;
  final String foodname;
  final String location;
  final String expired;
  final String remind;
  final String consuming;
  final int remaining;
  final String url;
  final String category;
  final bool isCountable;
  final int TotalCost;
  final int IndividualWeight;
  final int IndividualCost;

  factory InventoryFoodData.fromJson(Map<String, dynamic> json) {
    return InventoryFoodData(
      foodid: json['Food_ID'],
      foodname: json['FoodName'],
      location: json['Location'],
      expired: json['Expired'],
      remind: json['Remind'],
      consuming: json['Consuming'],
      remaining: json['Remaining'],
      url: json['URL'],
      category: json['Category'],
      isCountable: json['isCountable'],
      TotalCost: json['TotalCost'],
      IndividualWeight: json['IndividualWeight'],
      IndividualCost: json['IndividualCost'],
    );
  }

  InventoryFoodData({
    required this.foodid,
    required this.foodname,
    required this.location,
    required this.expired,
    required this.remind,
    required this.consuming,
    required this.remaining,
    required this.url,
    required this.category,
    required this.isCountable,
    required this.TotalCost,
    required this.IndividualWeight,
    required this.IndividualCost,
  });
}
