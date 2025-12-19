import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SendFcmTokenRemote {
  Future<void> postData({required String fcm}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");
    if (token == null) {
      print(" User not logged in, skip sending FCM token.");
      return;
    } else {
      final response = await http.post(
        Uri.parse('${baseURL}user/store-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcm_token': fcm}),
      );
      print(response.body);
    }
  }
}
