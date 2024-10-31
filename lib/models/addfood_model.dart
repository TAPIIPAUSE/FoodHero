class AddFood {
  String foodName;
  int category;
  int location;
  DateTime expired;
  DateTime remind;
  double totalCost;
  double individualWeight;
  double individualCost;
  String remaining;
  String url;
  bool isCountable;
  int weight_type;
  int package_type;
  //int current_amount;
  //int total_amount;
  //double consumed_amount;
  //double current_quantity;
  //double total_quanitity;
  //double consumed_quantity;
  //double total_price;
  //DateTime bestByDate;

  AddFood({
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
    required this.weight_type,
    required this.package_type,
  });

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'category': category,
      'location': location,
      'expired': expired.toIso8601String(),
      'remind': remind.toIso8601String(),
      'totalCost': totalCost,
      'individualWeight': individualWeight,
      'individualCost': individualCost,
      'remaining': remaining,
      'url': url,
      'isCountable': isCountable,
      'weight_type': weight_type,
      'package_type': package_type,
      // 'current_amount': current_amount,
      // 'total_amount': total_amount,
      // 'consumed_amount': consumed_amount,
      // 'current_quantity': current_quantity,
      // 'total_quanitity': total_quanitity,
      // 'consumed_quantity': consumed_quantity,
      // 'total_price': total_price,
      // 'bestByDate': bestByDate,
    };
  }
}
