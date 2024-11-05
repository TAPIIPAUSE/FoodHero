class FoodDetailData {
  final int Food_ID;
  final String FoodName;
  final String Category;
  final String Location;
  final DateTime Expired;
  final DateTime Remind;
  final int QuantityCountable;
  final String Package;
  final double WeightCountable;
  final double WeightUncountable;
  final String Unit;
  final double TotalCost;
  final double IndividualWeight;
  final double IndividualCost;

  final String Remaining;
  final String Remaining_amount;
  final String URL;
  final bool isCountable;
  final int scoreGained;
  final int save;
  final double total_amount;

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

  FoodDetailData(
      {required this.Food_ID,
      required this.FoodName,
      required this.Category,
      required this.Location,
      required this.Expired,
      required this.Remind,
      required this.QuantityCountable,
      required this.Package,
      required this.WeightCountable,
      required this.WeightUncountable,
      required this.Unit,
      required this.TotalCost,
      required this.IndividualWeight,
      required this.IndividualCost,
      required this.Remaining,
      required this.Remaining_amount,
      required this.URL,
      required this.isCountable,
      required this.scoreGained,
      required this.save,
      required this.total_amount

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
      'Package': Package, 
      'WeightCountable': WeightCountable,
      'WeightUncountable': WeightUncountable,
      'TotalCost': TotalCost,
      'IndividualWeight': IndividualWeight,
      'IndividualCost': IndividualCost,
      'Remaining': Remaining,
      'Remaining_amount': Remaining_amount,
      'URL': URL,
      'isCountable': isCountable,
      'scoreGained': scoreGained,
      'save': save,
      'total_amount': total_amount,
    };
  }

  // Create Food instance from a Map
  factory FoodDetailData.fromJson(Map<String, dynamic> json) {
    return FoodDetailData(
        Food_ID: json['Food_ID'] ?? 0, // Default value if null
        FoodName: json['FoodName'] ?? 'Unknown', // Provide a default string
        Category: json['Category'] ?? 'Uncategorized',
        Location: json['Location'] ?? 'Unknown Location',
        Expired: DateTime.tryParse(json['Expired']) ??
            DateTime.now(), // Default to now if parsing fails
        Remind: DateTime.tryParse(json['Remind']) ?? DateTime.now(),
        QuantityCountable: json['quantityCountable'],
        Package: json['package'] ?? 'Unknown Package',
        WeightCountable: (json['weightCountable'] as num?)?.toDouble() ?? 0,
        WeightUncountable: (json['weightUncountable'] as num?)?.toDouble() ?? 0,
        Unit: json['unit'] ?? 'Unknown Unit',
        TotalCost: (json['TotalCost'] as num?)?.toDouble() ?? 0,
        IndividualWeight: (json['IndividualWeight'] as num?)?.toDouble() ?? 0.0,
        IndividualCost: (json['IndividualCost'] as num?)?.toDouble() ?? 0.0,
        Remaining: json['Remaining'] ?? '0',
        Remaining_amount: json['Remaining_amount'] ?? '0',
        URL: json['URL'] ?? '',
        isCountable: json['isCountable'] ?? false,
        scoreGained: json['scoreGained'] ?? 0,
        save: json['save'] ?? 0,
        total_amount: json['total_amount'] ?? 0

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
    int? QuantityCountable,
    String? Package,
    double? WeightCountable,
    double? WeightUncountable,
    String? Unit,
    double? TotalCost,
    double? IndividualWeight,
    double? IndividualCost,
    String? Remaining,
    String? Remaining_amount,
    String? URL,
    bool? isCountable,
    double? total_amount,
    int? scoreGained,
    int? save,
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
        QuantityCountable: QuantityCountable ?? this.QuantityCountable,
        Package: Package ?? this.Package,
        WeightCountable: WeightCountable ?? this.WeightCountable,
        WeightUncountable: WeightUncountable ?? this.WeightUncountable,
        Unit: Unit ?? this.Unit,
        TotalCost: TotalCost ?? this.TotalCost,
        IndividualWeight: IndividualWeight ?? this.IndividualWeight,
        IndividualCost: IndividualCost ?? this.IndividualCost,
        Remaining: Remaining ?? this.Remaining,
        Remaining_amount: Remaining_amount ?? this.Remaining_amount,
        URL: URL ?? this.URL,
        isCountable: isCountable ?? this.isCountable,
        scoreGained: scoreGained ?? this.scoreGained,
        save: save ?? this.save,
        total_amount: total_amount ?? this.total_amount
        // current_quantity: current_quantity ?? this.current_quantity
        //  total_price: total_price ?? this.total_price
        );
  }

  @override
  String toString() {
    return 'Food(Food_ID: $Food_ID, FoodName: $FoodName, Category: $Category, '
        'Location: $Location, Expired: $Expired, Remind: $Remind, '
        'TotalCost: $TotalCost, IndividualWeight: $IndividualWeight, '
        'IndividualCost: $IndividualCost, WeightCountable: $WeightCountable, '
        'WeightUncountable: $WeightUncountable, Remaining_amount: $Remaining_amount, '
        'URL: $URL, isCountable: $isCountable,)';
    // current_quantity: $current_quantity
    // total_price: $total_price
  }
}
