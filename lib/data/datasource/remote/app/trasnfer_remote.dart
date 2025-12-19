import 'dart:convert';
import 'package:bank_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransferRemote {
  static Future<List<Map<String, dynamic>>> getUserAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    final url = Uri.parse('${baseURL}user/accounts-user');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("FULL RESPONSE: $data");

      // ✅ الريسبونس Map وفيه accounts
      if (data is Map<String, dynamic> && data['accounts'] is List) {
        return List<Map<String, dynamic>>.from(data['accounts']);
      }

      return [];
    } else {
      throw Exception("فشل في جلب الحسابات");
    }
  }

  // ===============================
  static Future<Map<String, dynamic>?> searchAccountByIdentifier(
    String accountNumber,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    final url = Uri.parse('${baseURL}user/search-accounts');
    final body = {'account_number': accountNumber}; // ← مهم جداً

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      // حسب الريسبونس: قائمة داخل قائمة
      if (data is List &&
          data.isNotEmpty &&
          data[0] is List &&
          data[0].isNotEmpty) {
        return Map<String, dynamic>.from(data[0][0]);
      }
      return null; // لا يوجد حساب
    } else {  final data = json.decode(response.body);
      print(data);
      throw Exception("فشل في البحث عن الحساب");
    }
  }

  // 3️⃣ تنفيذ التحويل مباشرة بدون موديل
  static Future<bool> transferMoney({
  required String fromAccountId,
  required String toAccountIdentifier,
  required double amount,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("user_token");

  final url = Uri.parse('${baseURL}user/transfer');
  final body = {
    'from_account': fromAccountId,
    'number_account': toAccountIdentifier,
    'amount': amount,
  };

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(body),
  );

  final data = json.decode(response.body);
  print("Transfer response: $data");

  // الآن نقرأ success من result
  if (data['result'] != null && data['result']['success'] == true) {
    return true;
  } else {
    final message = data['result']?['message'] ?? "فشل في تنفيذ التحويل";
    throw Exception(message);
  }
}

}
