import 'dart:convert';
import 'package:foodhero/models/consumedfood_model.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumedFood {
  static String baseurl = "http://$myip:3000/api/v1/consume";

  final dio = Dio();

  //get
  Future<List<ConsumedfoodData>> getConsumedfood(int hID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      print('login success ${prefs.getString('user_token')}');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final res = await dio.get(
        "$baseurl/showConsumedFood",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('user_token')!}',
          },
        ),
        queryParameters: {'hID': hID},
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      // final res = await http
      //     .get(Uri.parse("http://$myip:3000/api/v1/consume/showConsumedFood"));

      if (res.statusCode == 200) {
        if (res.data is List) {
          return (res.data as List)
              .map((e) => ConsumedfoodData.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              'Unexpected response format: ${res.data.runtimeType}');
        }
        // ConsumedfoodData data = ConsumedfoodData.fromJson(res.data);

        // // SharedPreferences prefs = await SharedPreferences.getInstance();
        // // prefs.getInt('hID');
        // print(data);
        // return data;
      } else {
        throw Exception('Failed to load consumed food data');
      }

      // if (res.statusCode == 200) {
      //   List<dynamic> data = res.data;
      //   return data.map((item) => ConsumedfoodData.fromJson(item)).toList();
      // } else {
      //   throw Exception('Failed to load consumed food data');
      // }
    } on DioException catch (e) {
      // if (e.response?.statusCode == 403) {
      //   print(
      //       '403 Forbidden: This might be due to an invalid or expired token');
      // }
      print('Error fetching consumed food: ${e.toString()}');
      return [];
    }
  }
}
