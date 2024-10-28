import 'package:dio/dio.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseOrgApi {
  final Dio dio = Dio();
  final String baseurl = '$myip/api/v1/houseorg';
  final authService = AuthService();

  // get house score
  Future<HouseScore> getHousePageScore() async {
    try {
      print("===HousePageScore===");
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
      );

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
      throw Exception('Failed to fetch house page score: ${e.toString()}');
    }
  }

  // get org score
  Future<OrgScore> getOrgPageScore() async {
    try {
      print("===OrgPageScore===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch org page score: ${e.toString()}');
    }
  }
}
