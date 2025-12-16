import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpRemote {
  Future<http.Response> postData({
    required String username,
    required String email,
    required String password,
    required String confpassword,
  }) async {
    final response = await http.post(
      Uri.parse('${baseURL}register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'email': email,
        'password': password,
        'password_confirmation': confpassword,
      }),
    );
    return response;
  }
}
