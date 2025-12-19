import 'package:bank_app/data/datasource/remote/app/trasnfer_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  var isLoading = false.obs;

  // ==========================
  // حسابات المستخدم
  // ==========================
  var accounts = <Map<String, dynamic>>[].obs;

  var selectedFromAccountId = ''.obs;
  var selectedFromAccountText = ''.obs;

  // ==========================
  // الحساب المستفيد
  // ==========================
  TextEditingController toAccountController = TextEditingController();
  var toAccount = Rx<Map<String, dynamic>?>(null);
  var searchResults = <Map<String, dynamic>>[].obs;

  // ==========================
  // المبلغ
  // ==========================
  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  // ==========================
  // جلب حسابات المستخدم فقط عند الضغط على DropDown
  // ==========================
Future<void> fetchAccounts() async {
  try {
    isLoading.value = true;
    print("API CALLED"); // ← رح تشوفها أكيد
    final result = await TransferRemote.getUserAccounts();
    accounts.assignAll(result);
  } catch (e) {
    Get.snackbar("خطأ", e.toString());
  } finally {
    isLoading.value = false;
  }
}

  // ==========================
  // اختيار الحساب المرسل منه
  // ==========================
  void selectFromAccount(String accountId, String accountNumber) {
    selectedFromAccountId.value = accountId;
    selectedFromAccountText.value = accountNumber;
  }

  // ==========================
  // البحث المباشر عن حساب المستفيد
  // ==========================
void searchToAccountLive(String identifier) async {
  if (identifier.isEmpty) {
    searchResults.clear();
    return;
  }
  try {
    final result = await TransferRemote.searchAccountByIdentifier(identifier);
    print("SEARCH RESULT: $result");
    searchResults.value = result != null ? [result] : [];
  } catch (e) {
    searchResults.clear();
    print("SEARCH ERROR: $e");
  }
}



  // ==========================
  // اختيار الحساب المستفيد
  // ==========================
  void selectToAccount(Map<String, dynamic> account) {
    toAccount.value = account;
    toAccountController.text = account['account_number'];
    searchResults.clear();
  }

  // ==========================
  // تنفيذ التحويل
  // ==========================
  void transferMoney() async {
    if (selectedFromAccountId.value.isEmpty) {
      Get.snackbar("تنبيه", "الرجاء اختيار الحساب المرسل منه");
      return;
    }
    if (toAccount.value == null) {
      Get.snackbar("تنبيه", "الرجاء اختيار الحساب المستفيد");
      return;
    }
    final amountText = amountController.text.trim();
    if (amountText.isEmpty || double.tryParse(amountText) == null) {
      Get.snackbar("تنبيه", "الرجاء إدخال مبلغ صحيح");
      return;
    }

    final amount = double.parse(amountText);

    try {
      isLoading.value = true;
      final success = await TransferRemote.transferMoney(
        fromAccountId: selectedFromAccountId.value,
        toAccountIdentifier: toAccount.value!['account_number'],
        amount: amount,
      );

      if (success) {
        Get.snackbar("نجاح", "تم تنفيذ التحويل بنجاح");
        amountController.clear();
        toAccountController.clear();
        toAccount.value = null;
        selectedFromAccountId.value = '';
        selectedFromAccountText.value = '';
      } else {
        Get.snackbar("خطأ", "فشل في تنفيذ التحويل");
      }
    } catch (e) {
      Get.snackbar("خطأ", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================
  // ترجمة نوع الحساب للعربي
  // ==========================
  String getAccountTypeArabic(String type) {
    switch (type) {
      case 'loan':
        return 'قرض';
        case 'investment':
        return 'استثمار';
      case 'savings':
        return 'ادخار';
      case 'checking':
        return 'جاري';
      case 'composite':
        return 'مركب';
      default:
        return type;
    }
  }
}
