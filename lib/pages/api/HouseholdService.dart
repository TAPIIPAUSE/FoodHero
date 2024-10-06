import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HouseholdService {
  //final String baseApiUrl = 'http://192.168.1.34:3000/api/v1/users/create_house';

  // Create a household
  Future<bool> createHousehold(String householdName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.34:3000/api/v1/users/create_house'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': householdName,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('Household created successfully');
        return true;
      } else {
        print("Failed to create household with status code: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error during household creation request: $error");
      return false;
    }
  }

  // Join a household
  Future<bool> joinHousehold(String householdId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.34:3000/api/v1/users/join_house'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'householdId': householdId,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        print('Successfully joined the household');
        return true;
      } else {
        print("Failed to join household with status code: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error during join household request: $error");
      return false;
    }
  }
}