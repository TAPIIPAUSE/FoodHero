import 'dart:convert';
import 'package:foodhero/widgets/inventory/inventory_list_item.dart';
import 'package:http/http.dart' as http;

Future<List<InventoryListItem>> fetchUserFood(int hID) async {
  try {
    print("Attempting to log in with username: $hID");
    final response = await http.get(
      Uri.parse('http://10.4.152.33:3000/api/v1/inventory/getFoodByHouse'),
      headers: {
        'Content-Type': 'application/json',
        // Add other headers if necessary, like authentication tokens
      },
    );

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
