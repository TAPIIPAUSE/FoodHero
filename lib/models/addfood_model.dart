class AddFood {
  String food_name;
  String img;
  int location;
  int food_category;
  bool isCountable;
  int weight_type;
  int package_type;
  int current_amount;
  int total_amount;
  double consumed_amount;
  int current_quantity;
  int total_quanitity;
  int consumed_quantity;
  double total_price;
  DateTime bestByDate;
  DateTime RemindDate;

//    int package_type;
// int weight_type;
  // int current_amount;
  // //int total_amount;
  // double consumed_amount;
  // double current_quantity;
  //double total_quanitity;
  //double consumed_quantity;
  //double total_price;
  //DateTime bestByDate;
// String mimetype;
  AddFood({
    required this.food_name,
    required this.img,
    required this.location,
    required this.food_category,
    required this.isCountable,
    required this.weight_type,
    required this.package_type,
    required this.current_amount,
    required this.total_amount,
    required this.consumed_amount,
    required this.current_quantity,
    required this.total_quanitity,
    required this.consumed_quantity,
    required this.total_price,
    required this.bestByDate,
    required this.RemindDate,

    // required this.current_amount,
    // required this.consumed_amount,
    // required this.current_quantity,
    //required this.mimetype
  });

  Map<String, dynamic> toJson() {
    return {
      'food_name': food_name,
      'img': img,
      'location': location,
      'food_category': food_category,
      'isCountable': isCountable,
      'weight_type': weight_type,
      'package_type': package_type,
      'current_amount': current_amount,
      'total_amount': total_amount,
      'consumed_amount': consumed_amount,
      'current_quantity': current_quantity,
      'total_quanitity': total_quanitity,
      'consumed_quantity': consumed_quantity,
      'total_price': total_price,
      'bestByDate': bestByDate.toIso8601String(),
      'RemindDate': RemindDate.toIso8601String(),
      //
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
