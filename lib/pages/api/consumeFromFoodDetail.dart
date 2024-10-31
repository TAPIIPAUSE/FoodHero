import 'package:dio/dio.dart';
import 'package:foodhero/models/completeconsume_model.dart';
import 'package:foodhero/utils/constants.dart';

class Consumefromfooddetail {
  static String baseurl = "http://$myip:3000/api/v1/inventory";
  final dio = Dio();
  Future<void> completeConsume(CompleteConsume food) async {
    try {
      final response =
          await dio.post('$baseurl/consume/all', data: food.toJson());

      if (response.statusCode == 200) {
        print('Food added successfully: ${response.data}');
      } else {
        print('Failed to add food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding food: $e');
    }
  }
}
