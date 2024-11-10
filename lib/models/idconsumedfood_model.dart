class IdconsumedfoodModel {
   final int cID;
  final String foodName;
  // final String quantityMessage;
  // final String package;
  // final String location;
  final double totalCost;
  final double individualWeight;
  final double individualCost;
  final String url;
  final bool isCountable;
  final double weightCountable;
  final int quantityCountable;
  final double weightUncountable;
  final String unit;
  final String packageType;

  IdconsumedfoodModel({
     required this.cID,
    required this.foodName,
    // required this.quantityMessage,
    // required this.package,
    // required this.location,
    required this.totalCost,
    required this.individualWeight,
    required this.individualCost,
    required this.url,
    required this.isCountable,
    required this.weightCountable,
    required this.quantityCountable,
    required this.weightUncountable,
    required this.unit,
    required this.packageType,
  });

  // Convert Food instance to a Map
  Map<String, dynamic> toJson() {
    return {
       'cID': cID,
      //'food_ID': food_ID,
      'foodName': foodName,
      'TotalCost': totalCost,
      'IndividualWeight': individualWeight,
      'IndividualCost': individualCost,
      'URL': url,
      'isCountable': isCountable,
      'weightCountable': weightCountable,
      'quantityCountable': quantityCountable,
      'weightUncountable': weightUncountable,
      'unit': unit,
      'package': packageType,
    };
  }

  factory IdconsumedfoodModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? {};
    String parsedUrl = message['URL'] ?? '';
    if (parsedUrl.isEmpty || !Uri.parse(parsedUrl).isAbsolute) {
      parsedUrl = 'https://example.com/default_image.png'; // Fallback image URL
    }
    return IdconsumedfoodModel(
      cID: message['cID'] ?? 'Unknown',
      foodName: message['FoodName'] ?? 'Unknown',
      totalCost: _getDecimalValue(message['TotalCost']),
      individualWeight: _getDecimalValue(message['IndividualWeight']),
      individualCost: _getDecimalValue(message['IndividualCost']),
      url: parsedUrl,
      isCountable: message['isCountable'] ?? true ,
      weightCountable: _getDecimalValue(message['weightCountable']),
      quantityCountable: message['quantityCountable'] ?? 0,
      weightUncountable: _getDecimalValue(message['weightUncountable']),
      unit: message['unit'] ?? 'Unknown',
      packageType: message['package'] ?? 'Unknown',
    );
  }

  static double _getDecimalValue(dynamic value) {
    if (value == null) {
      return 0.0; // Default value for null
    }

    // Check if the value is a Map with the '$numberDecimal' key
    if (value is Map<String, dynamic> && value.containsKey('\$numberDecimal')) {
      return double.parse(value['\$numberDecimal'].toString());
    } else if (value is num) {
      return value.toDouble(); // Handle numeric types directly
    } else {
      throw Exception('Unexpected value format: $value');
    }
  }

  IdconsumedfoodModel copyWith({
    int? cID,
    String? FoodName,
  }) {
    return IdconsumedfoodModel(
       cID: cID ?? this.cID,
      foodName: foodName ?? this.foodName,
      // quantityMessage: quantityMessage ?? this.quantityMessage,
      // package: package ?? this.package,
      // location: location ?? this.location,
      totalCost: totalCost ?? this.totalCost,
      individualWeight: individualWeight ?? this.individualWeight,
      individualCost: individualCost ?? this.individualCost,
      url: url ?? this.url,
      isCountable: isCountable ?? this.isCountable,
      weightCountable: weightCountable ?? this.weightCountable,
      quantityCountable: quantityCountable ?? this.quantityCountable,
      weightUncountable: weightUncountable ?? this.weightUncountable,
      unit: unit ?? this.unit,
      packageType: packageType ?? this.packageType,
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
    return 'IdconsumedfoodModel(cID: $cID, foodName: $foodName)';
  }
}
    // food_ID: $food_ID, userID: $userID, hID: $hID, '
       // 'currentAmount: $currentAmount, currentQuantity: $currentQuantity, '
       // 'saved: $saved, lost: $lost, consumed: $consumed, wasted: $wasted, '
        //'score: $score, createdAt: $createdAt, assignedID: $assignedID}';

