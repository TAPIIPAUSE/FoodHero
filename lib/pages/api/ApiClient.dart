import 'dart:convert';
import 'package:foodhero/models/loginresult.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';


class AuthService {
  //final String backApiUrl = 'http://localhost:3000/api/v1/users';

  Future<Loginresult?> login(String username, String password) async {
    try {
      print(
          "Attempting to log in with username: $username, password: $password");
      final dio = Dio();
      final response = await dio.post('http://$myip:3000/api/v1/users/login', data: {'username': username, 'password': password});
      
      // final response = await http.post(
      //   Uri.parse('http://$myip:3000/api/v1/users/login'),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, String>{
      //     'username': username,
      //     'password': password,
      //   }),
      // );
      if (response.statusCode == 200) {
        // Assuming the API returns a token on successful login
        Loginresult loginresult = Loginresult.fromJson(response.data);

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', loginresult.token);
        await prefs.setInt('hID', loginresult.hID);

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
    final response = await http.post(
      Uri.parse('http://$myip:3000/api/v1/users/register'),
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

    if (response.statusCode == 201) {
      String token = jsonDecode(response.body)['token'];
      print('Token received: $token');
      // Save token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
      return true;
    }
    return await register(username, email, password);
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
}
