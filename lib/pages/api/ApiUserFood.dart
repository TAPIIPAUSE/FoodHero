import 'dart:convert';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:http/http.dart' as http;

Future<int> fetchHId() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/v1/inventory/getFoodByHouse'), // Your endpoint for hID
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
    
    print("Attempting to log in with hID: $hID");
    final response = await http.get(
      Uri.parse('http://192.168.1.34:3000/api/v1/inventory/getFoodByHouse'),
      headers: {
        'Content-Type': 'application/json',
        // Add other headers if necessary, like authentication tokens
      },
    );
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> foodItemsJson = jsonDecode(response.body)['data'];
      return foodItemsJson
          .map((item) => InventoryListItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load inventory');
    }
  } catch (error) {
    print("Error during login request: $error");
    return [];
  }
}
