class IdconsumedfoodModel {
  final int foodID; // food_ID is an integer
  final int userID; // user_ID is an integer
  final int hID; // h_ID is an integer
  final double currentAmount; // current_amount as double
  final double currentQuantity; // current_quantity as double
  final double saved; // saved as double
  final double lost; // lost as double
  final double consumed; // consumed as double
  final double wasted; // wasted as double
  final double score; // score as double
  final DateTime createdAt; // createdAt as DateTime
  final int assignedID; // assigned_ID as integer

  IdconsumedfoodModel({
    required this.foodID,
    required this.userID,
    required this.hID,
    required this.currentAmount,
    required this.currentQuantity,
    required this.saved,
    required this.lost,
    required this.consumed,
    required this.wasted,
    required this.score,
    required this.createdAt,
    required this.assignedID,
  });

  factory IdconsumedfoodModel.fromJson(Map<String, dynamic> json) {
    return IdconsumedfoodModel(
      foodID: json['food_ID'] as int,
      userID: json['user_ID'] as int,
      hID: json['h_ID'] as int,
      currentAmount: _getDecimalValue(json['current_amount']),
      currentQuantity: _getDecimalValue(json['current_quantity']),
      saved: _getDecimalValue(json['saved']),
      lost: _getDecimalValue(json['lost']),
      consumed: _getDecimalValue(json['consumed']),
      wasted: _getDecimalValue(json['wasted']),
      score: _getDecimalValue(json['score']),
      createdAt: DateTime.parse(json['createdAt']),
      assignedID: json['assigned_ID'] as int,
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

  @override
  String toString() {
    return 'IdconsumedfoodModel{foodID: $foodID, userID: $userID, hID: $hID, '
        'currentAmount: $currentAmount, currentQuantity: $currentQuantity, '
        'saved: $saved, lost: $lost, consumed: $consumed, wasted: $wasted, '
        'score: $score, createdAt: $createdAt, assignedID: $assignedID}';
  }
}
