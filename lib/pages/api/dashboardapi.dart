import 'package:dio/dio.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/interscore_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApi {
  final Dio dio = Dio();
  final String baseurl = 'http://$myip:3000/api/v1/dashboard';
  final authService = AuthService();

  // get house score
  Future<HouseScore> getHouseScore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===HouseScore===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch house: ${e.toString()}');
    }
  }

  // get inter score
  Future<InterScore> getInterScore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/inter_organization/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===Inter Score===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return InterScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch house: ${e.toString()}');
    }
  }
}
