class FoodDetailData {
  final int Food_ID;
  final String FoodName;
  final String Category;
  final String Location;
  final DateTime Expired;
  final DateTime Remind;
  final double TotalCost;
  final double IndividualWeight;
  final double IndividualCost;
  final String Remaining;
  final String Remaining_amount;
  final String URL;
  final bool isCountable;

  //final int total_price;
  // final int current_quantity;
  //   "weight_type": 3,
  // "package_type": 2,
  // "current_amount": 500,
  // "total_amount": 500,
  // "consumed_amount": null,
  // "total_quanitity": 5,
  // "consumed_quantity": null,
  // "total_price": 50,
  // "bestByDate": "2024-12-31T00:00:00.000Z",
  // "RemindDate": "2024-12-15T00:00:00.000Z"

  FoodDetailData({
    required this.Food_ID,
    required this.FoodName,
    required this.Category,
    required this.Location,
    required this.Expired,
    required this.Remind,
    required this.TotalCost,
    required this.IndividualWeight,
    required this.IndividualCost,
    required this.Remaining,
    required this.Remaining_amount,
    required this.URL,
    required this.isCountable,

    // required this.total_price,
    // required this.current_quantity,
  });

  // Convert Food instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'Food_ID': Food_ID,
      'FoodName': FoodName,
      'Category': Category,
      'Location': Location,
      'Expired': Expired.toIso8601String(),
      'Remind': Remind.toIso8601String(),
      'TotalCost': TotalCost,
      'IndividualWeight': IndividualWeight,
      'IndividualCost': IndividualCost,
      'Remaining': Remaining,
      'Remaining_amount': Remaining_amount,
      'URL': URL,
      'isCountable': isCountable,
    };
  }

  // Create Food instance from a Map
  factory FoodDetailData.fromJson(Map<String, dynamic> json) {
    return FoodDetailData(
      Food_ID: json['Food_ID'],
      FoodName: json['FoodName'],
      Category: json['Category'],
      Location: json['Location'],
      Expired: DateTime.parse(json['Expired']),
      Remind: DateTime.parse(json['Remind']),
      TotalCost: json['TotalCost'].toDouble(),
      IndividualWeight: json['IndividualWeight'].toDouble(),
      IndividualCost: json['IndividualCost'].toDouble(),
      Remaining: json['Remaining'],
      Remaining_amount: json['Remaining_amount'],
      URL: json['URL'],
      isCountable: json['isCountable'],

      // current_quantity: json['current_quantity']
      // total_price: json['total_price']
    );
  }

  // Create a copy of Food with optional parameter updates
  FoodDetailData copyWith({
    int? Food_ID,
    String? FoodName,
    String? Category,
    String? Location,
    DateTime? Expired,
    DateTime? Remind,
    double? TotalCost,
    double? IndividualWeight,
    double? IndividualCost,
    String? Remaining,
    String? Remaining_amount,
    String? URL,
    bool? isCountable,
    double? total_amount,
    //int? current_quantity,
    // int? total_price
  }) {
    return FoodDetailData(
      Food_ID: Food_ID ?? this.Food_ID,
      FoodName: FoodName ?? this.FoodName,
      Category: Category ?? this.Category,
      Location: Location ?? this.Location,
      Expired: Expired ?? this.Expired,
      Remind: Remind ?? this.Remind,
      TotalCost: TotalCost ?? this.TotalCost,
      IndividualWeight: IndividualWeight ?? this.IndividualWeight,
      IndividualCost: IndividualCost ?? this.IndividualCost,
      Remaining: Remaining ?? this.Remaining,
      Remaining_amount: Remaining_amount ?? this.Remaining_amount,
      URL: URL ?? this.URL,
      isCountable: isCountable ?? this.isCountable,

      // current_quantity: current_quantity ?? this.current_quantity
      //  total_price: total_price ?? this.total_price
    );
  }

  @override
  String toString() {
    return 'Food(Food_ID: $Food_ID, FoodName: $FoodName, Category: $Category, '
        'Location: $Location, Expired: $Expired, Remind: $Remind, '
        'TotalCost: $TotalCost, IndividualWeight: $IndividualWeight, '
        'IndividualCost: $IndividualCost, Remaining: $Remaining, Remaining_amount: $Remaining_amount, '
        'URL: $URL, isCountable: $isCountable,)';
    // current_quantity: $current_quantity
    // total_price: $total_price
  }
}
