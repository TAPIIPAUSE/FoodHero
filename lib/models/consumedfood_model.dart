class ConsumedfoodData {
  final int consumeId;
  final int foodId;
  final String foodName;
  final String? expired;
  final String consuming;
  final String remaining;
  final String url;
  final bool isCountable;

  factory ConsumedfoodData.fromJson(Map<String, dynamic> json) {
    // Log the entire JSON object for inspection
    print('ConsumedfoodData.fromJson: $json');

    // Extracting values with logging for specific fields
    var isCountableValue = json['isCountable'];
    print('isCountable value from JSON: $isCountableValue');
    return ConsumedfoodData(
      url: json['URL'],
      foodName: json['FoodName'] as String? ?? 'test',
      expired: json['Expired'] as String? ?? 'test',
      consuming: json['Consuming'] as String? ?? 'test',
      remaining: json['Remaining'] as String? ?? 'test',
      foodId: json['Food_ID'] as int? ?? 0,
      consumeId: json['Consume_ID'] as int? ?? 0,
      isCountable: (isCountableValue != null && isCountableValue is bool)
          ? json['isCountable']
          : true, // Default to false if not present or not a boolean
    );
  }

  ConsumedfoodData({
    required this.consumeId,
    required this.foodId,
    required this.foodName,
    this.expired,
    required this.consuming,
    required this.remaining,
    required this.url,
    required this.isCountable,
  });

  @override
  String toString() {
    return 'ConsumedfoodData(consumeId: $consumeId, foodName: $foodName, expired: $expired, consuming: $consuming, remaining: $remaining, isCountable: $isCountable)';
  }
}
