import 'package:dio/dio.dart';
import 'package:foodhero/models/conpletewaste_model.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Wastefromfooddetail {
  static String baseurl = "$myip/api/v1/inventory";
  final dio = Dio();
  Future<void> completeWaste(CompleteWaste food) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print('Adding food details for: $food with token: $token');
      final response = await dio.post(
        '$baseurl/complete_waste',
        data: food.toJson(), // Data directly passed here
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Complete wasted successfully: ${response.data}');
      } else {
        print('Failed complete waste food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error complete waste food: $e');
    }
  }

  void main() {
    String jsonResponse =
        '{"message": "Food item consumed successfully", "scoreGained": 2, "Lost": 50}';
    Map<String, dynamic> data = json.decode(jsonResponse);

    int scoreGained = data['scoreGained'];
    int lost = data['Lost'];

    print('Score Gained: $scoreGained, Lost: $lost');
  }
}
