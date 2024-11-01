import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:foodhero/models/addfood_model.dart';
import 'package:foodhero/models/fooddetail_model.dart';
import 'package:foodhero/models/inventoryfood_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/pages/foodDetails.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<int> fetchHId() async {
//   try {
//     final response = await http.get(
//       Uri.parse(
//           'http://$myip:3000/api/v1/inventory/getFoodByHouse'), // Your endpoint for hID
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['hID']; // Adjust based on your API response structure
//     } else {
//       throw Exception('Failed to load hID');
//     }
//   } catch (error) {
//     print("Error fetching hID: $error");
//     throw error; // Rethrow the error for handling in the calling code
//   }
// }

class APIFood {
  static String baseurl = "http://$myip:3000/api/v1/inventory";
  final authService = AuthService();
  final dio = Dio();

  // get
  Future<InventoryFoodData?> getInventoryFood(int hID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print('token: $token');
      print('Getting inventory for hID: $hID');
      // print("Attempting to log in with hID: $hID");
      final res = await dio.get(
        "$baseurl/getFoodByHouse",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {'hID': hID},
      );

      print("Response status inventory: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        // if (res.data is List) {
        //    inventoryFoodList = (res.data as List)
        //       .map((e) => InventoryFoodData.fromJson(e as Map<String, dynamic>))
        //       .toList();
        //   if (inventoryFoodList.isNotEmpty) {
        //     await prefs.setInt('inventory_id', inventoryFoodList.first.foodid);
        //   }
        //   return inventoryFoodList;
        // }
        final inventoryData = InventoryFoodData.fromJson(res.data);
        print(
            "Parsed inventory data: ${inventoryData.foodItems.length} foods"); // Debug log
        return inventoryData;
      } else {
        throw Exception('Failed to load inventory foods');
      }
    } catch (error) {
      print("Error during inventory request: $error"); // Debug log
      return null;
    }
  }

  Future<FoodDetailData?> getFoodDetail(int foodId) async {
    if (foodId == null) {
      throw ArgumentError('foodId cannot be null');
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print(
          'Getting food details for fID: $foodId with token: $token'); // Debug log

      final res = await dio.get(
        "$baseurl/getFoodById",
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
      print("Request URL: $baseurl/getFoodById");
      print("Respon: $res.data");
      print("Food Detail Response status: ${res.statusCode}"); // Debug log
      print("Food Detail Response body: ${res.data}"); // Debug log
      print("Requesting food details with fID: $foodId and token: $token");

      if (res.statusCode == 200) {
        final foodDetail = FoodDetailData.fromJson(res.data);
        print("Parsed food detail data: ${foodDetail.FoodName}"); // Debug log
        return foodDetail;
      } else {
        print("Failed to load food details: Status ${res.statusCode}");
        //return null;
        throw Exception(
            'Failed to load food details, status code: ${res.statusCode}');
      }
    } catch (error) {
      print("Error during food detail request: $error"); // Debug log
      if (error is DioException) {
        print("Dio error: ${error.message}");
      }
      return null;
    }
  }

  Future<void> addFood(AddFood food) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print('Adding food details for: $food with token: $token'); // Debug log

      final response = await dio.post(
        '$baseurl/addFood',
        data: food.toJson(), // Data directly passed here
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

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



  // Future<Type> getFoodDetail(int hID) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('user_token');
  //     print('token: $token');

  //     // print("Attempting to log in with hID: $hID");
  //     final res = await dio.get(
  //       "$foodDetailurl/getFoodByHouse",
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //       queryParameters: {'hID': hID},
  //     );

  //     print("Response status: ${res.statusCode}");
  //     print("Response body: ${res.data}");

  //     if (res.statusCode == 200) {
  //       if (res.data) {

  //         return foodDetails;
  //       } else {
  //         throw Exception(
  //             'Unexpected inventory response format: ${res.data.runtimeType}');
  //       }
  //     } else {
  //       throw Exception('Failed to load inventory food data');
  //     }
  //   } catch (error) {
  //     print("Error during inventory request: $error");

  //   }
  // }

