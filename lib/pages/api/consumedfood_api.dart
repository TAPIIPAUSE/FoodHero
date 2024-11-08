import 'dart:convert';
import 'package:foodhero/models/consumedfood_model.dart';
import 'package:foodhero/models/idconsumedfood_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumedFood {
  static String baseurl = "http://$myip:3000/api/v1/consume";
  final authService = AuthService();
  final dio = Dio();
  //get
  Future<ConsumedfoodData> getConsumedfood(int hID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');

      print('login success $token');

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
      // ConsumedfoodData consumedfood = ConsumedfoodData.fromJson(res.data);

      // await prefs.setInt('consume_id', consumedfood.consumeId);
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        ConsumedfoodData consumedFood = ConsumedfoodData.fromJson(data);
        await prefs.setInt('consume_id', consumedFood.food.first.consumeId);
        return consumedFood;
        // if (res.data is List) {
        // List<ConsumedfoodData> consumedFoodList = (res.data as List)
        //     .map((e) => ConsumedfoodData.fromJson(e as Map<String, dynamic>))
        //     .toList();

        // } else if (res.data is List) {
        //   List<ConsumedfoodData> consumedFoodList = (res.data as List)
        //       .map((e) => ConsumedfoodData.fromJson(e as Map<String, dynamic>))
        //       .toList();

        //   if (consumedFoodList.isNotEmpty) {
        //     await prefs.setInt(
        //         'consume_id', consumedFoodList.first.food.first.consumeId);
        //     return consumedFoodList.first;
        //   } else {
        // throw Exception('No consumed food data found');
        // }

        // return consumedFoodList;
        // return (res.data as List)
        //     .map((e) => ConsumedfoodData.fromJson(e as Map<String, dynamic>))
        //     .toList();
        // } else {
        //   throw Exception(
        //       'Unexpected response format: ${res.data.runtimeType}');
        // }
      } else {
        throw Exception('Failed to load consumed food data');
      }
    } on DioException catch (e) {
      print('Error fetching consumed food: ${e.toString()}');
      rethrow;
    }
  }

  //get
  Future<IdconsumedfoodModel?> getConsumedfoodById(int? cID) async {
    print('cID: $cID');

    if (cID == null) {
      throw ArgumentError('cID cannot be null');
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      if (token == null) {
        throw Exception('User token is null');
      }

      print('Getting food consumed details for cID: $cID with token: $token');

      final res = await dio.get(
        "$baseurl/getConsumeById",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: {'cID': cID},
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200 && res.data != null) {
        try {
          final consumedFoodDetail = IdconsumedfoodModel.fromJson(res.data);
          print("Parsed food detail data: ${consumedFoodDetail.foodName}");
          return consumedFoodDetail;
        } catch (e) {
          print("Error parsing JSON to model: $e");
          return null;
        }
      } else {
        print("Failed to load consumed food details: Status ${res.statusCode}");
        return null; // Handle accordingly
      }
    } catch (error) {
      print("Error during consumed food detail request: $error");
      return null;
    }
  }
}
