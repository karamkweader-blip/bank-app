import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgetPasswordRemote {
  Future<http.Response> postData({required String email}) async {
    final response = await http.post(
      Uri.parse('${baseURL}forget-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }
}
