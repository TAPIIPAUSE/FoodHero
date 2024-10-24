import 'package:dio/dio.dart';
import 'package:foodhero/models/inventoryfood_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
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

class InventoryFood {
  static String baseurl = "http://$myip:3000/api/v1/inventory/getFoodById";
  final authService = AuthService();
  final dio = Dio();

  // get
  Future<List<InventoryFoodData>> getInventoryFood(int hID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      print('token: $token');

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

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        if (res.data is List) {
          List<InventoryFoodData> inventoryFoodList = (res.data as List)
              .map((e) => InventoryFoodData.fromJson(e as Map<String, dynamic>))
              .toList();
          if (inventoryFoodList.isNotEmpty) {
            await prefs.setInt('inventory_id', inventoryFoodList.first.foodid);
          }
          return inventoryFoodList;
        } else {
          throw Exception(
              'Unexpected inventory response format: ${res.data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load inventory food data');
      }
    } catch (error) {
      print("Error during inventory request: $error");
      return [];
    }
  }
}
