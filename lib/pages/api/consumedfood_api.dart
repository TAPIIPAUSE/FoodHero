import 'dart:convert';
import 'package:foodhero/models/consumedfood_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumedFood {
  static String baseurl = "http://$myip:3000/api/v1/consume";
  final authService = AuthService();
  final dio = Dio();
  //get
  Future<List<ConsumedfoodData>> getConsumedfood(int hID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      print('login success $token');
      // print('login success ${prefs.getString('user_token')}');
      // if (token == null) {
      //   // Token is missing or expired, need to re-login
      //   throw Exception('Authentication required');
      // }

      final res = await dio.get(
        "$baseurl/showConsumedFood",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {'hID': hID},
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        if (res.data is List) {
          return (res.data as List)
              .map((e) => ConsumedfoodData.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              'Unexpected response format: ${res.data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load consumed food data');
      }
    } on DioException catch (e) {
      print('Error fetching consumed food: ${e.toString()}');
      return [];
    }
  }
}
