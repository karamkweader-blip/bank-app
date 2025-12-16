import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInRemote {
  Future<http.Response> postData({
    required String email,
    required String password,
  }) async {
    print("BASE URL USED → ${baseURL}login");

    final response = await http.post(
      
      Uri.parse('${baseURL}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
      
    );
        print("BASE URL USED → ${baseURL}login");

    return response;
  }
}
