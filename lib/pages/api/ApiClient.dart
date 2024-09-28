import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//const String backApiUrl = 'http://localhost:3000/api/v1/users';

class AuthService {
  final String backApiUrl = 'http://localhost:3000/api/v1/users/login';

  Future<bool> login(String username, String password) async {
    try {
      print(
          "Attempting to log in with username: $username, password: $password");

      final response = await http.post(
        Uri.parse('$backApiUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        // Assuming the API returns a token on successful login
        String token = jsonDecode(response.body)['token'];

        // Save token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token);

        return true;
      } else {
        print("Login failed with status code: ${response.statusCode}");
        return false;
      }
    } catch (error) {
      print("Error during login request: $error");
      return false;
    }
  }

  // Register method
  Future<bool> register(String username, String password, String name) async {
    final response = await http.post(
      Uri.parse('$backApiUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      // Successful registration
      return true;
    } else {
      return false;
    }
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
