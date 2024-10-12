import 'dart:convert';
import 'package:foodhero/utils/constants.dart';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<int> fetchHId() async {
  try {
    final response = await http.get(
      Uri.parse(
          'http://$myip:3000/api/v1/inventory/getFoodByHouse'), // Your endpoint for hID
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['hID']; // Adjust based on your API response structure
    } else {
      throw Exception('Failed to load hID');
    }
  } catch (error) {
    print("Error fetching hID: $error");
    throw error; // Rethrow the error for handling in the calling code
  }
}

Future<List<InventoryListItem>> fetchUserFood(int hID) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Attempting to log in with hID: $hID");
    final response = await http.get(
      Uri.parse('http://$myip:3000/api/v1/inventory/getFoodByHouse'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('user_token')!}'
        // Add other headers if necessary, like authentication tokens
      },
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      print("check conditiobn");
      final List<dynamic> foodItemsJson = jsonDecode(response.body)['data'];
      print(foodItemsJson);
      return foodItemsJson
          .map((item) => InventoryListItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load inventory');
    }
  } catch (error) {
    print("Error during GetFood request: $error");
    return [];
  }
}
