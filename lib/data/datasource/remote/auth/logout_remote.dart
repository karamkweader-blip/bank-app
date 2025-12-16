import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;

class LogoutRemote {
  Future<http.Response> deletetoken({required String token}) async {
    final response = await http.post(
      Uri.parse('${baseURL}logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
