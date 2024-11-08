import 'package:dio/dio.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

//final String baseApiUrl = 'http://192.168.1.34:3000/api/v1/users/create_house';

class CreateAndJoinHousehold {
  final Dio dio = Dio();
  final authService = AuthService();

  // Create a household
  Future<bool> createHousehold(String householdName) async {
    try {
      print('===Create Household===');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      //  print('token: $token');

      final response = await dio.post(
        '$myip/api/v1/users/create_house',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(<String, String>{
          'house_name': householdName,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Household created successfully');
        return true; // Creation successful
      } else if (response.statusCode == 400) {
        print("Household already exists");
        return false; // Household already exists
      } else {
        print(
            "Failed to create household with status code: ${response.statusCode}");
        return false; // Household already exists
      }
    } on DioException catch (dioError) {
      print(
          "Dio error during household creation: ${dioError.response?.data ?? dioError.message}");
      print("${dioError.response?.statusCode}");
      return false;
    } catch (error) {
      print("Error during household creation request: $error");
      return false;
    }
  }

  // Join a household
  Future<bool> joinHousehold(String householdName) async {
    try {
      print('===Join Household===');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      //  print('token: $token');

      final response = await dio.post(
        '$myip/api/v1/users/join_house',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(<String, String>{
          'housename': householdName,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully joined the household');
        return true;
      } else if (response.statusCode == 400) {
        print(
            "Failed to join household with status code: ${response.statusCode}");
        return false; // already joined
      } else {
        print(
            "Failed to join household with status code: ${response.statusCode}");
        return false; // already joined
      }
    } on DioException catch (dioError) {
      print(
          "Dio error during join household: ${dioError.response?.data ?? dioError.message}");
      print("${dioError.response?.statusCode}");
      return false;
    } catch (error) {
      print("Error during join household request: $error");
      return false;
    }
  }

  // Create a org
  Future<bool> createOrg(String orgName) async {
    try {
      print('===Create Org===');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final response = await dio.post(
        '$myip/api/v1/users/create_org',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(<String, String>{
          'org_name': orgName,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Org created successfully');
        return true; // Creation successful
      } else if (response.statusCode == 400) {
        print('Org already exists');
        return false; // Household already exists
      } else {
        print("Failed to create org with status code: ${response.statusCode}");
        return false;
      }
    } on DioException catch (dioError) {
      print(
          "Dio error during org creation: ${dioError.response?.data ?? dioError.message}");
      print("${dioError.response?.statusCode}");
      return false;
    } catch (error) {
      print("Error during org creation request: $error");
      return false;
    }
  }

  // Join a org
  Future<bool> joinOrg(String orgName) async {
    try {
      print('===Join Org===');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final response = await dio.post(
        '$myip/api/v1/users/join_org',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        data: jsonEncode(<String, String>{
          'orgname': orgName,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Successfully joined the org');
        return true; // Join successful
      } else if (response.statusCode == 400) {
        print("Failed to join org with status code: ${response.statusCode}");
        return false; // already joined
      } else {
        print("Failed to join org with status code: ${response.statusCode}");
        return false;
      }
    } on DioException catch (dioError) {
      print(
          "Dio error during join org: ${dioError.response?.data ?? dioError.message}");
      print("${dioError.response?.statusCode}");
      return false;
    } catch (error) {
      print("Error during join org request: $error");
      return false;
    }
  }
}
