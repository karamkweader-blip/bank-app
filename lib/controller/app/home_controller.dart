import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/app/child_remote.dart';
import 'package:bank_app/data/datasource/remote/app/trasnfer_remote.dart';
import 'package:bank_app/data/datasource/remote/auth/logout_remote.dart';
import 'package:bank_app/data/datasource/remote/app/remote_data_source.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/account_model.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  late RemoteDataSource _remote;
  ChildRemote childRemote = ChildRemote();
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxBool isLoading = true.obs;
  var unreadCount = 0.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  LogoutRemote logoutRemote = LogoutRemote();
  final List<String> availableAccountTypes = [
    'savings',
    'checking',
    'loan',
    'investment',
    'composite',
  ];
  RxList<Map<String, dynamic>> childSearchResults =
      <Map<String, dynamic>>[].obs;

  TextEditingController childSearchController = TextEditingController();
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

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
      final result = await _remote.getUserAccounts().timeout(
        const Duration(seconds: 15),
      );

      if (result != null) {
        accounts.value = result.accounts;
      } else {
        // إذا كان الرد null (فشل غير واضح)
        print("API Warning: getUserAccounts returned null or failed silently.");
      }
    } catch (e) {
      // 2. التعامل مع أخطاء الجلب (مثل TimeoutException)
      print(
        "API ERROR - getUserAccounts failed with Exception: ${e.runtimeType} - $e",
      );
      Get.snackbar(
        "خطأ اتصال",
        "فشل في جلب الحسابات، قد تكون المشكلة في الـ Token أو الاتصال.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    Get.back();

    // 1. مؤشر التحميل الصغير لعملية فتح التذكرة
    // Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    TicketModel? result;

    try {
      result = await _remote.openNewTicket(accountId: accountId, title: title);
    } finally {
      // 2. إغلاق مؤشر التحميل الصغير
      Get.back();

      // 3. 🔑 إيقاف مؤشر التحميل الرئيسي (اللف يجب أن يتوقف هنا)
      // هذا السطر يضمن تنظيف حالة التحميل بعد عملية الشبكة الأولى
      isLoading.value = false;
    }

    // 4. إذا تم فتح التذكرة بنجاح، ننتقل مباشرة لإضافة رسالة
    if (result != null) {
      _showAddMessageDialog(result.id);
    }
  }

  void _showAddMessageDialog(int ticketId) {
    String messageText = '';
    Get.dialog(
      AlertDialog(
        title: Text(
          "أرسل رسالة للتذكرة #${ticketId}",
          textAlign: TextAlign.right,
        ),
        content: TextField(
          textAlign: TextAlign.right,
          onChanged: (value) => messageText = value,
          decoration: const InputDecoration(hintText: "اكتب رسالتك..."),
        ),
        actions: [
          // زر الإرسال
          TextButton(
            onPressed: () async {
              if ((Get.isDialogOpen ?? false))
                Get.back(); // غلق Dialog الرسالة أولاً

              if (messageText.trim().isEmpty) {
                Get.snackbar(
                  "تنبيه",
                  "الرجاء كتابة رسالة قبل الإرسال",
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }

              // عرض Loading
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              bool success = false;
              try {
                success = await _remote.addMessageToTicket(
                  ticketId: ticketId,
                  message: messageText.trim(),
                );
              } catch (e) {
                print("API ERROR sending message: $e");
                Get.snackbar(
                  "خطأ",
                  "تعذر إرسال الرسالة، حاول مرة أخرى.",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } finally {
                Get.back();
              }
              if (success) {
                Get.snackbar(
                  "نجاح",
                  "تم إرسال الرسالة إلى التذكرة رقم $ticketId",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("إرسال"),
          ),

          // زر الإلغاء
          TextButton(
            onPressed: () {
              if ((Get.isDialogOpen ?? false)) Get.back();
            },
            child: const Text("إلغاء"),
          ),
        ],
      ),
    );
  }

  logout() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token").toString();
    // prefs.clear();

    final response = await logoutRemote.deletetoken(token: token);
    print(response);
    if (response.statusCode == 200) {
      await prefs.clear();
      Get.back();
      //print(token);
      Get.offAllNamed(AppRoute.login);
    } else {
      print(response.body);
    }
  }

void showAddChildDialog({required int parentAccountId}) {
  childSearchController.clear();
  childSearchResults.clear();

  Get.dialog(
    AlertDialog(
      title: const Text(
        "إضافة حساب ابن",
        textAlign: TextAlign.right,
      ),
      content: SizedBox(
        width: Get.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: childSearchController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: "ابحث برقم الحساب",
                border: OutlineInputBorder(),
              ),
              onChanged:searchChildAccountLive,
            ),

            const SizedBox(height: 10),
            // نتائج البحث
            Obx(() {
              if (childSearchResults.isEmpty) {
                return const SizedBox();
              }
              final account = childSearchResults.first;
              return Card(
                child: ListTile(
                  title: Text(account['account_number']),
                  subtitle: Text(
                    '${account['type']} - رصيد: ${account['balance']}',
                  ),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {
                    selectChildAccount(
                      parentAccountId: parentAccountId,
                      account: account,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            childSearchResults.clear();
            childSearchController.clear();
            Get.back();
          },
          child: const Text("إلغاء"),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}

  Future<void> searchChildAccountLive(String identifier) async {
    if (identifier.isEmpty) {
      childSearchResults.clear();
      return;
    }
    try {
      final result = await TransferRemote.searchAccountByIdentifier(identifier);

      print("CHILD SEARCH RESULT: $result");

      childSearchResults.value = result != null ? [result] : [];
    } catch (e) {
      childSearchResults.clear();
      print("CHILD SEARCH ERROR: $e");
    }
  }


  Future<void> selectChildAccount({
    required int parentAccountId,
    required Map<String, dynamic> account,
  }) async {
    final int childId = account['id']; 

    try {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await childRemote.addChildAccount(
        parentAccountId: parentAccountId,
        childAccountId: childId,
      );

      Get.back();
      Get.snackbar(
        "نجاح",
        "تمت إضافة الحساب كابن بنجاح",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      childSearchResults.clear();
      childSearchController.clear();
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "خطأ",
        "فشل في إضافة الحساب كابن",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print("ADD CHILD ERROR: $e");
    }
  }

  void viewChildAccounts(int parentAccountId) {
    Get.toNamed(
      AppRoute.childAccounts,
      arguments: parentAccountId,
    );
  }
}
