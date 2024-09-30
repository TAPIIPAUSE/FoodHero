import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiUserFood {
  Future<List<dynamic>> fetchInventory() async {
 final response = await http.get(Uri.parse('http://192.168.1.34:3000/api/v1/inventory'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load inventory');
    }
  }
  }

