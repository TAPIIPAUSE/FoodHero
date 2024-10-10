class Consumedfood {
  final int consumeId;
  final int foodId;
  final String foodName;
  final String expired;
  final String consuming;
  final String remaining;
  final String url;

  factory Consumedfood.fromJson(Map<String, dynamic> json) {
    return Consumedfood(
      url: json['url'],
      foodName: json['foodName'],
      expired: json['expired'],
      consuming: json['consuming'],
      remaining: json['remaining'],
      foodId: json['foodId'],
      consumeId: json['consumeId'],
    );
  }

  Consumedfood(
      {required this.consumeId,
      required this.foodId,
      required this.foodName,
      required this.expired,
      required this.consuming,
      required this.remaining,
      required this.url});
}
