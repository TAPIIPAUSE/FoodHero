class ConsumedfoodData {
  final int consumeId;
  final int foodId;
  final String foodName;
  final String? expired;
  final String consuming;
  final String remaining;
  final String? url;

  factory ConsumedfoodData.fromJson(Map<String, dynamic> json) {
    return ConsumedfoodData(
      url: json['URL'],
      foodName: json['FoodName'] as String? ?? 'test',
      expired: json['Expired'] as String? ?? 'test',
      consuming: json['Consuming'] as String? ?? 'test',
      remaining: json['Remaining'] as String? ?? 'test',
      foodId: json['Food_ID'] as int? ?? 0,
      consumeId: json['Consume_ID'] as int? ?? 0,
    );
  }

  ConsumedfoodData(
      {required this.consumeId,
      required this.foodId,
      required this.foodName,
      this.expired,
      required this.consuming,
      required this.remaining,
      this.url});
}
