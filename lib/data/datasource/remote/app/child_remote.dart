import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChildRemote {
 Future<http.Response> addChildAccount({
  required int parentAccountId,
  required int childAccountId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("user_token");
  final response = await http.post(
    Uri.parse('${baseURL}user/add-children'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'parent_account_id': parentAccountId,
      'child_account_ids': [childAccountId],
    }),
  );

  print("RESPONSE STATUS → ${response.statusCode}");
  print("RESPONSE BODY → ${response.body}");

  return response;
}

}
