import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetePasswordRemote {
  Future<http.Response> postData({
    required String password,
    required String repassword,
    required String token,
  }) async {
    final response = await http.post(
      Uri.parse('${baseURL}reset-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'password': password,
        'password_confirmation': repassword,
      }),
    );
    return response;
  }
}
