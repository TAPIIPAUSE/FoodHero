import 'dart:convert';
import 'package:foodhero/models/hhorginfo_model.dart';
import 'package:foodhero/models/loginresult.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  //final String backApiUrl = 'http://localhost:3000/api/v1/users';
  final dio = Dio();

  Future<Loginresult?> login(String username, String password) async {
    try {
      print(
          "Attempting to log in with username: $username, password: $password");
      final response = await dio.post('$myip/api/v1/users/login',
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        // Assuming the API returns a token on successful login
        Loginresult loginresult = Loginresult.fromJson(response.data);

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', loginresult.token);
        await prefs.setInt('hID', loginresult.hID);
        await prefs.setInt('login_time', DateTime.now().microsecondsSinceEpoch);

        print("hID: ${loginresult.hID}");
        print("token: ${loginresult.token}");

        return loginresult;
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("Error during login request: $error");
      return null;
    }
  }

  // Register method
  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$myip/api/v1/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // String token = jsonDecode(response.body)['token'];
        // print('Token received: $token');
        // Save token in SharedPreferences
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('user_token', token);
        // return true;
        try {
          print("User reegistered successfully");
          return true;
        } catch (e) {
          print("Error during user registration: $e");
          return false;
        }
      } else {
        print(
            "Failed to register user with status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error during user registration: $e");
      return false;
    }

    // return await register(username, email, password);
  }

  // Logout method (removes token)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }

  // Check if user is logged in (token exists)
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    return token != null;
  }

  Future<bool> isTokenExpired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? loginTime = prefs.getInt('login_time');
    if (loginTime == null) {
      return true;
    }
    const int tokenExpirationTime =
        24 * 60 * 60 * 1000; // 24 hours in milliseconds
    int currentTime = DateTime.now().microsecondsSinceEpoch;
    int timeDifference = currentTime - loginTime;
    return timeDifference > tokenExpirationTime;
  }

  
  // get hh/org info
  Future<HHOrgInfo?> getHHOrgInfo() async{
    try{
      print("===HHOrgInfo===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');
      
      final res = await dio.get(
        '$myip/api/v1/users/firstLogin',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");
      
      if (res.statusCode == 200) {
        HHOrgInfo data = HHOrgInfo.fromJson(res.data);
        return data;
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HHOrgInfo: ${e.toString()}');
    }
  }
}
