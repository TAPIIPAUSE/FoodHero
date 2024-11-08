class IdconsumedfoodModel {
  final int cID;
  // final int food_ID; // food_ID is an integer
  // final int userID; // user_ID is an integer
  // final int hID; // h_ID is an integer
  // final double currentAmount; // current_amount as double
  // final double currentQuantity; // current_quantity as double
  // final double saved; // saved as double
  // final double lost; // lost as double
  // final double consumed; // consumed as double
  // final double wasted; // wasted as double
  // final double score; // score as double
  // final DateTime createdAt; // createdAt as DateTime
  // final int assignedID; // assigned_ID as integer

  IdconsumedfoodModel({
    required this.cID,
    // required this.food_ID,
    // required this.userID,
    // required this.hID,
    // required this.currentAmount,
    // required this.currentQuantity,
    // required this.saved,
    // required this.lost,
    // required this.consumed,
    // required this.wasted,
    // required this.score,
    // required this.createdAt,
    // required this.assignedID,
  });

  // Convert Food instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'cID': cID,
      //'food_ID': food_ID,
      // 'FoodName': FoodName,
      // 'Category': Category,
      // 'Location': Location,
      // 'Expired': Expired.toIso8601String(),
      // 'Remind': Remind.toIso8601String(),
      // 'WeightCountable': WeightCountable,
      // 'WeightUncountable': WeightUncountable,
      // 'TotalCost': TotalCost,
      // 'IndividualWeight': IndividualWeight,
      // 'IndividualCost': IndividualCost,
      // 'Remaining': Remaining,
      // 'Remaining_amount': Remaining_amount,
      // 'URL': URL,
      // 'isCountable': isCountable,
      // 'scoreGained': scoreGained,
      // 'save': save,
      // 'total_amount': total_amount,
    };
  }

  factory IdconsumedfoodModel.fromJson(Map<String, dynamic> json) {
    return IdconsumedfoodModel(
      cID: json['cID'] as int,
      // food_ID: json['food_ID'] as int,
      // userID: json['user_ID'] as int,
      // hID: json['h_ID'] as int,
      // currentAmount: _getDecimalValue(json['current_amount']),
      // currentQuantity: _getDecimalValue(json['current_quantity']),
      // saved: _getDecimalValue(json['saved']),
      // lost: _getDecimalValue(json['lost']),
      // consumed: _getDecimalValue(json['consumed']),
      // wasted: _getDecimalValue(json['wasted']),
      // score: _getDecimalValue(json['score']),
      // createdAt: DateTime.parse(json['createdAt']),
      // assignedID: json['assigned_ID'] as int,
    );
  }

  static double _getDecimalValue(dynamic value) {
    // Check if the value is a Map with the '$numberDecimal' key
    if (value is Map<String, dynamic> && value.containsKey('\$numberDecimal')) {
      return double.parse(value['\$numberDecimal'].toString());
    } else {
      // If the value isn't in the expected format, throw an error or return a default
      throw Exception('Unexpected value format: $value');
    }
  }

  IdconsumedfoodModel copyWith({
    int? cID,
    // int? food_ID,
    // String? FoodName,
    // String? Category,
    // String? Location,
    // DateTime? Expired,
    // DateTime? Remind,
    // int? QuantityCountable,
    // String? Package,
    // double? WeightCountable,
    // double? WeightUncountable,
    // String? Unit,
    // double? TotalCost,
    // double? IndividualWeight,
    // double? IndividualCost,
    // String? Remaining,
    // String? Remaining_amount,
    // String? URL,
    // bool? isCountable,
    // double? total_amount,
    // int? scoreGained,
    // int? save,
    //int? current_quantity,
    // int? total_price
  }) {
    return IdconsumedfoodModel(
      cID: cID ?? this.cID,
        //food_ID: food_ID ?? this.food_ID,
        // FoodName: FoodName ?? this.FoodName,
        // Category: Category ?? this.Category,
        // Location: Location ?? this.Location,
        // Expired: Expired ?? this.Expired,
        // Remind: Remind ?? this.Remind,
        // QuantityCountable: QuantityCountable ?? this.QuantityCountable,
        // Package: Package ?? this.Package,
        // WeightCountable: WeightCountable ?? this.WeightCountable,
        // WeightUncountable: WeightUncountable ?? this.WeightUncountable,
        // Unit: Unit ?? this.Unit,
        // TotalCost: TotalCost ?? this.TotalCost,
        // IndividualWeight: IndividualWeight ?? this.IndividualWeight,
        // IndividualCost: IndividualCost ?? this.IndividualCost,
        // Remaining: Remaining ?? this.Remaining,
        // Remaining_amount: Remaining_amount ?? this.Remaining_amount,
        // URL: URL ?? this.URL,
        // isCountable: isCountable ?? this.isCountable,
        // scoreGained: scoreGained ?? this.scoreGained,
        // save: save ?? this.save,
        // total_amount: total_amount ?? this.total_amount
        // current_quantity: current_quantity ?? this.current_quantity
        //  total_price: total_price ?? this.total_price
        );
  }

  @override
  String toString() {
    return 'IdconsumedfoodModel(cID: $cID)';
       }
}
    // food_ID: $food_ID, userID: $userID, hID: $hID, '
       // 'currentAmount: $currentAmount, currentQuantity: $currentQuantity, '
       // 'saved: $saved, lost: $lost, consumed: $consumed, wasted: $wasted, '
        //'score: $score, createdAt: $createdAt, assignedID: $assignedID}';

