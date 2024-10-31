import 'package:dio/dio.dart';
import 'package:foodhero/models/completeconsume_model.dart';
import 'package:foodhero/models/getModalCompleteConsume.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consumefromfooddetail {
  static String baseurl = "http://$myip:3000/api/v1/inventory";
  final dio = Dio();
  Future<void> completeConsume(CompleteConsume food) async {
    try {
      final response =
          await dio.post('$baseurl/consume/all', data: food.toJson());

      if (response.statusCode == 200) {
        print('Complete consumed successfully: ${response.data}');
      } else {
        print('Failed complete food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error complete food: $e');
    }
  }

  Future<GetModalCompleteConsume?> getFoodDetail(int foodId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print(
          'Getting food modal for fID: $foodId with token: $token'); // Debug log

      final res = await dio.get(
        "$baseurl/consume/all",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          // validateStatus: (status) {
          //   return status! < 500; // Accept all responses below 500
          // },
        ),
        data: {'fID': foodId},
      );
      print("Request URL: $baseurl/consume/all");
      print("Respon: $res.data");

      if (res.statusCode == 200) {
        final foodModal = GetModalCompleteConsume.fromJson(res.data);
        print("Parsed food score data: ${foodModal.scoreGained}"); // Debug log
        return foodModal;
      } else {
        print("Failed to load food modal: Status ${res.statusCode}");
        //return null;
        throw Exception(
            'Failed to load food modal, status code: ${res.statusCode}');
      }
    } catch (error) {
      print("Error during food modal request: $error"); // Debug log
      if (error is DioException) {
        print("Dio error: ${error.message}");
      }
      return null;
    }
  }
}
