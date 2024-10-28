class FoodDetailData {
  int foodId;
  String foodName;
  int category;
  String location;
  DateTime expired;
  DateTime remind;
  double totalCost;
  double individualWeight;
  double individualCost;
  String remaining;
  String url;
  bool isCountable;

  FoodDetailData({
    required this.foodId,
    required this.foodName,
    required this.category,
    required this.location,
    required this.expired,
    required this.remind,
    required this.totalCost,
    required this.individualWeight,
    required this.individualCost,
    required this.remaining,
    required this.url,
    required this.isCountable,
  });

  factory FoodDetailData.fromJson(Map<String, dynamic> json) {
    print( FoodDetailData(
      foodId: json['Food_ID'],
      foodName: json['FoodName'],
      category: json['Category'],
      location: json['Location'],
      expired: DateTime.parse(json['Expired']),
      remind: DateTime.parse(json['Remind']),
      totalCost: (json['TotalCost'] as num).toDouble(),
      individualWeight: (json['IndividualWeight'] as num).toDouble(),
      individualCost: (json['IndividualCost'] as num).toDouble(),
      remaining: json['Remaining'],
      url: json['URL'],
      isCountable: json['isCountable'],
    ));

    return FoodDetailData(
      foodId: json['Food_ID'],
      foodName: json['FoodName'],
      category: json['Category'],
      location: json['Location'],
      expired: DateTime.parse(json['Expired']),
      remind: DateTime.parse(json['Remind']),
      totalCost: (json['TotalCost'] as num).toDouble(),
      individualWeight: (json['IndividualWeight'] as num).toDouble(),
      individualCost: (json['IndividualCost'] as num).toDouble(),
      remaining: json['Remaining'],
      url: json['URL'],
      isCountable: json['isCountable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Food_ID': foodId,
      'FoodName': foodName,
      'Category': category,
      'Location': location,
      'Expired': expired.toIso8601String(),
      'Remind': remind.toIso8601String(),
      'TotalCost': totalCost,
      'IndividualWeight': individualWeight,
      'IndividualCost': individualCost,
      'Remaining': remaining,
      'URL': url,
      'isCountable': isCountable,
    };
  }
}
