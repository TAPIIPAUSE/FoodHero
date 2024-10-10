import 'package:http/http.dart' as http;
import 'dart:convert';

  //final String baseApiUrl = 'http://192.168.1.34:3000/api/v1/users/create_house';

  // Create a household
  Future<void> createHousehold(String householdName) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.4.152.33:3000/api/v1/users/create_house'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': householdName,
    
        }),
      );

      if (response.statusCode == 201) {
        print('Household created successfully');

      } else {
        print("Failed to create household with status code: ${response.statusCode}");
       
      }
    } catch (error) {
      print("Error during household creation request: $error");
 
    }
  }

  // Join a household
  Future<void> joinHousehold(String householdId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.34:3000/api/v1/users/join_house'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'householdId': householdId,
          
        }),
      );

      if (response.statusCode == 200) {
        print('Successfully joined the household');

      } else {
        print("Failed to join household with status code: ${response.statusCode}");
      
      }
    } catch (error) {
      print("Error during join household request: $error");
     
    }
  }
