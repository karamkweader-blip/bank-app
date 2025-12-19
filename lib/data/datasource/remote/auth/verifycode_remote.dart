import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyCodeRemote {
  Future<String?> checkCodeAndGetToken({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('${baseURL}verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final token = json['token'];
      return token;
      // return true; // تحقق ناجح
    } else {
      return null;
      // return false; // تحقق فاشل
    }
  }
}
