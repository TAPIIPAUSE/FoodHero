import 'package:dio/dio.dart';
import 'package:foodhero/models/completeconsumedetail_model.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/models/completeconsume_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consumefromconsumedetail {
  static String baseurl = "http://$myip:3000/api/v1/consume";
  final dio = Dio();
  Future<void> confirmConsumeDetail(ConfirmConsumeDetail food) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print('Adding food details for: $food with token: $token');
      final response = await dio.post(
        '$baseurl/confirmConsume',
        data: food.toJson(), // Data directly passed here
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Complete consumed successfully: ${response.data}');
      } else {
        print('Failed complete food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error complete food: $e');
    }
  }
}
