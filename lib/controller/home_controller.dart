import 'package:bank_app/data/datasource/remote/remote_data_source.dart';
import 'package:get/get.dart';
import '../data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bank_app/data/datasource/remote/remote_data_source.dart'; 
import '../data/model/account_model.dart';
import 'package:flutter/material.dart'; // نحتاج هذه المكتبة لاستخدام Dialogs و CircularProgressIndicator


class HomeController extends GetxController {

late RemoteDataSource _remote; 

 RxList<AccountModel> accounts = <AccountModel>[].obs;
 RxBool isLoading = true.obs; // يبدأ التحميل عند التهيئة
 
 final List<String> availableAccountTypes = [
 'savings',
 'checking',
 'loan',
 'investment',
 'composite',
 ];

 @override
 void onInit() {
    _remote = Get.find<RemoteDataSource>(); 
 fetchUserAccounts(); // جلب الحسابات عند بدء تشغيل الكنترولر
 super.onInit();
 }
// داخل HomeController.dart

// دالة جلب الحسابات (يجب أن تبدأ بـ true وتنتهي بـ false)
Future<void> fetchUserAccounts() async {
isLoading.value = true; // 1. يبدأ التحميل
try {
// 🔑 إضافة Timeout هنا لضمان عدم التعليق اللانهائي
final result = await _remote.getUserAccounts().timeout(const Duration(seconds: 15)); 

if (result != null) {
accounts.value = result.accounts;
} else {
// إذا كان الرد null (فشل غير واضح)
 print("API Warning: getUserAccounts returned null or failed silently.");
}
} catch (e) {
// 2. التعامل مع أخطاء الجلب (مثل TimeoutException)
 print("API ERROR - getUserAccounts failed with Exception: ${e.runtimeType} - $e");
 Get.snackbar("خطأ اتصال", "فشل في جلب الحسابات، قد تكون المشكلة في الـ Token أو الاتصال.",
backgroundColor: Colors.red, colorText: Colors.white);
 } finally {
isLoading.value = false; // 3. 🔑 إيقاف التحميل بعد الجلب
}
}

 // دالة فتح حساب جديد
 Future<void> openNewAccount(String type) async {
    // يجب وضع مؤشر تحميل هنا إذا كانت العملية طويلة
 bool success = await _remote.openNewAccount(accountType: type);
if (success) {
 fetchUserAccounts(); // تحديث الحسابات بعد الفتح
 Get.back(); 
 }
 }

 // دالة فتح تذكرة جديدة
  Future<void> openTicket(int accountId, String title) async {
    // إغلاق Dialog العنوان قبل المتابعة
    if (Get.isDialogOpen ?? false) Get.back(); 
    
    // 1. مؤشر التحميل الصغير لعملية فتح التذكرة
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false); 
    
    TicketModel? result; 
    
    try {
        result = await _remote.openNewTicket(
            accountId: accountId,
            title: title,
        );
    } 
    finally {
        // 2. إغلاق مؤشر التحميل الصغير 
        if (Get.isDialogOpen ?? false) Get.back(); 
        
        // 3. 🔑 إيقاف مؤشر التحميل الرئيسي (اللف يجب أن يتوقف هنا)
        // هذا السطر يضمن تنظيف حالة التحميل بعد عملية الشبكة الأولى
        isLoading.value = false; 
    }

    // 4. إذا تم فتح التذكرة بنجاح، ننتقل مباشرة لإضافة رسالة
    if (result != null) {
      _showAddMessageDialog(result.id);
    }
  }

 // دالة مساعدة لفتح Dialog إضافة الرسالة
 void _showAddMessageDialog(int ticketId) {
  isLoading.value = false; // 🛑 1. تأكيد إيقاف التحميل الرئيسي قبل فتح الديالوغ
 String messageText = '';
 Get.dialog(
 AlertDialog(
title: Text("أرسل رسالة للتذكرة #${ticketId}", textAlign: TextAlign.right),
  content: TextField(
 textAlign: TextAlign.right,
 onChanged: (value) => messageText = value,
 decoration: const InputDecoration(hintText: "اكتب رسالتك..."),
),
 actions: [
  // داخل HomeController.dart - TextButton "إرسال"

TextButton(
onPressed: () async {
 // نغلق Dialog الرسالة أولاً
 Get.back(); 

 Get.dialog(const Center(child: CircularProgressIndicator()),
  barrierDismissible: false);

try {
if (messageText.isNotEmpty) {
 await _remote.addMessageToTicket(
 ticketId: ticketId,
message: messageText,
 ).timeout(const Duration(seconds: 15)); // ⏰ حد أقصى 15 ثانية
}

} catch (e) {
print("====================================================================================API ERROR - addMessageToTicket failed: $e");
Get.snackbar("خطأ إرسال", "فشل الإرسال أو تجاوز الحد الزمني (15 ثانية).",
 backgroundColor: Colors.orange, colorText: Colors.white);
 }
 finally {
if (Get.isDialogOpen ?? false) Get.back(); 
isLoading.value = false;

}
},

child: const Text("إرسال"),
),
 TextButton(
              onPressed: () {
                  // 🔑 إذا ضغط إلغاء، يجب إيقاف التحميل الرئيسي أيضاً
                  Get.back(); // إغلاق الـ Dialog
                  isLoading.value = false; // 🔑 تأكيد إيقاف اللف عند الإلغاء
              }, 
              child: const Text("إلغاء")
          ),
 ],
),
);
    
    // 4. 🔑 هذا السطر يضمن أن مؤشر التحميل يتوقف عند فتح Dialog الرسالة 
    // إذا كنت تستخدم مؤشر تحميل يغطي الشاشة كلها في HomeScreen
 }
}