import 'package:bank_app/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationsService {
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");
    final response = await http.get(
      Uri.parse('${baseURL}notifications'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List limitedData = data.take(20).toList();
      return limitedData.map((e) => e as Map<String, dynamic>).toList();
    } else {
      print(response.body);
      throw Exception("فشل تحميل الإشعارات");
    }
  }

  Future<void> markAsRead(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");
    final response = await http.post(
      Uri.parse("${baseURL}mark-is-read"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'notification_id': id}),
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      Get.snackbar('faild', 'erorr');
    }
  }

  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");
    final response = await http.post(
      Uri.parse("${baseURL}mark-is-read"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'mark_all': 1}),
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      Get.snackbar('faild', 'erorr');
    }
  }
}
