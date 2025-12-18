import 'dart:convert';
import 'package:bank_app/core/constant/app_links.dart';
import 'package:bank_app/data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:bank_app/data/datasource/remote/remote_data_source.dart';

class RemoteDataSource extends GetxService {
  
  // إنشاء رأس الطلب (Header) مع التوكن
  Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Bearer ${AppLink.staticToken}',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // 1. جلب حسابات المستخدم
  Future<AccountsResponseModel?> getUserAccounts() async {
    try {
      final response = await http.get(
        Uri.parse(AppLink.userAccounts),
        headers: _getHeaders(),
      );
      

      // في حال الاستجابة كانت ناجحة (200 OK)
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return AccountsResponseModel.fromJson(jsonResponse);
      } else {
        // طباعة الخطأ إذا كانت حالة غير ناجحة
        Get.snackbar("خطأ في جلب الحسابات", "رمز الحالة: ${response.statusCode}");
        print("API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      Get.snackbar("خطأ في الاتصال", "تعذر الاتصال بالخادم: $e");
      print("Exception Error: $e");
      return null;
    }
  }

  // 2. فتح حساب جديد
  Future<bool> openNewAccount({required String accountType}) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.openAccount),
        headers: _getHeaders(),
        body: jsonEncode({'type': accountType.toLowerCase()}), // إرسال النوع بالإنجليزية
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          Get.snackbar(
            "تم بنجاح",
            jsonResponse['message'] ?? "تم فتح الحساب بنجاح",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        } else {
          Get.snackbar("فشل", jsonResponse['message'] ?? "فشلت عملية فتح الحساب",
              backgroundColor: Colors.red, colorText: Colors.white);
          return false;
        }
      } else {
        Get.snackbar("خطأ في الخادم", "رمز الحالة: ${response.statusCode}");
        print("API Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      Get.snackbar("خطأ في الاتصال", "تعذر فتح الحساب: $e");
      print("Exception Error: $e");
      return false;
    }
  }
// ملف lib/data/datasource/remote/remote_data_source.dart

// ... (باقي الكود)

  // 3. فتح تذكرة جديدة
  Future<TicketModel?> openNewTicket({
    required int accountId,
    required String title,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppLink.openTicket),
        headers: _getHeaders(),
        body: jsonEncode({
          'title': title,
          'account_id': accountId.toString(),
        }),
      )
      // 🔑 إضافة Timeout لإجبار الطلب على الانتهاء خلال 10 ثواني
      .timeout(const Duration(seconds: 10)); 

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Get.snackbar("نجاح", "تم فتح التذكرة بنجاح: ${jsonResponse['id']}",
            backgroundColor: Colors.blue, colorText: Colors.white);
        return TicketModel.fromJson(jsonResponse);
      } else {
        Get.snackbar("فشل", "فشلت عملية فتح التذكرة. رمز الحالة: ${response.statusCode}");
        print("API Error (Open Ticket): ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      // 🔑 هنا سيتم التقاط SocketException (لا اتصال) أو TimeoutException (تأخير)
      Get.snackbar("خطأ اتصال/خادم", "تعذر الاتصال بفتح التذكرة. الرمز: ${e.runtimeType}");
      print("Exception Error (Open Ticket): $e");
      return null;
    }
  }

// ... (باقي الكود)
  // 4. إضافة رسالة إلى تذكرة موجودة
  Future<bool> addMessageToTicket({
    required int ticketId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        // 🔑 استخدام دالة AppLink لإدراج ID التذكرة في الرابط
        Uri.parse(AppLink.addMessage(ticketId)),
        headers: _getHeaders(),
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 201) {
        // final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Get.snackbar("نجاح", "تم إرسال الرسالة إلى التذكرة رقم $ticketId",
            backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        Get.snackbar("فشل", "فشلت عملية إرسال الرسالة. رمز الحالة: ${response.statusCode}");
        print("API Error (Add Message): ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      Get.snackbar("خطأ", "تعذر الاتصال لإضافة الرسالة: $e");
      print("Exception Error (Add Message): $e");
      return false;
    }
  }


  
}