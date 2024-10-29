import 'package:dio/dio.dart';
import 'package:foodhero/models/chart/hhfoodtypepie_model.dart';
import 'package:foodhero/models/chart/interorgfoodtypepie_model.dart';
import 'package:foodhero/models/chart/wastepie/hhwastepie_model.dart';
import 'package:foodhero/models/chart/wastepie/interorgwastepie_model.dart';
import 'package:foodhero/models/chart/wastepie/orgwastepie_model.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/interscore_model.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApi {
  final Dio dio = Dio();
  final String baseurl = '$myip/api/v1/dashboard';
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
      throw Exception('Failed to fetch house score: ${e.toString()}');
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
      throw Exception('Failed to fetch inter score: ${e.toString()}');
    }
  }

  // get org score
  Future<OrgScore> getOrgScore() async {
    try {
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
        // queryParameters: {'hID': hID},
      );

      print("===Org Score===");
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
      throw Exception('Failed to fetch org score: ${e.toString()}');
    }
  }

  // get hh waste pie data
  Future<HouseholdFoodWastePieData> getHHWastePie() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/visualization/fs-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===HH waste pie===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseholdFoodWastePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH waste pie: ${e.toString()}');
    }
  }

  // get org waste pie data
  Future<OrgFoodWastePieData> getOrgWastePie() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/visualization/fs-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===Org waste pie===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgFoodWastePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org waste pie: ${e.toString()}');
    }
  }

  // ! get inter org waste pie data น่าจะไม่มี
  Future<InterFoodWastePieData> getInterWastePie() async {
    try {
      print("===Inter Org waste pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/inter_organization/fs-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return InterFoodWastePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Inter Org waste pie: ${e.toString()}');
    }
  }

  // get food type pie for inter org
  Future<InterOrgFoodTypePie> getInterOrgFoodTypePie() async {
    try {
      print("===Org food type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/inter_organization/foodtype_pie_chart',
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
        return InterOrgFoodTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org food type pie: ${e.toString()}');
    }
  }

  // get food type pie for hh
  Future<HHFoodTypePie> getHHFoodTypePie() async {
    try {
      print("===HH food type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/foodtype_pie_chart',
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
        return HHFoodTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH food type pie: ${e.toString()}');
    }
  }
}
