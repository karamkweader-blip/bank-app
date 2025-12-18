import 'package:bank_app/controller/home_controller.dart';
import 'package:bank_app/core/constant/app_links.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class HomeScreen extends StatelessWidget {
  // 1. الحصول على الكنترولر وتجهيزه
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      // 🔑 تم تمرير الـ context هنا إلى الـ AppBar
      appBar: _buildAppBar(context), 
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor));
          }
          if (controller.accounts.isEmpty) {
            return const Center(
                child: Text(
              "لا توجد حسابات لعرضها حالياً.",
              style: TextStyle(fontSize: 16, color: AppColor.grey),
            ));
          }
          return Padding(
            // بادينغ مناسب للشاشة
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "حساباتي",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black),
                ),
                const SizedBox(height: 15),
                // 🔑 عرض الحسابات بشكل أفقي
                _buildHorizontalAccountList(controller.accounts),
              ],
            ),
          );
        },
      ),
    );
  }

  // تصميم الـ AppBar وزر "فتح حساب"
  // 🔑 استقبال الـ context
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("نظام البنوك"),
      centerTitle: true,
      backgroundColor: AppColor.primaryColor,
      actions: [
        TextButton(
          // 🔑 استدعاء الدالة لفتح النافذة
          onPressed: () => _showOpenAccountDialog(), 
          child: const Text(
            "فتح حساب",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  // قائمة الحسابات الأفقية المطلوبة
  Widget _buildHorizontalAccountList(List<AccountModel> accounts) {
    return SizedBox(
      height: 180, // ارتفاع ثابت للكارد (ضروري للقائمة الأفقية)
      child: ListView.builder(
        // 🔑 تفعيل التمرير الأفقي
        scrollDirection: Axis.horizontal, 
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return Padding(
            // 🔑 إضافة مسافة بين الكاردات (Margin)
            padding: const EdgeInsets.only(right: 15), 
            child: AccountCard(account: accounts[index]),
          );
        },
      ),
    );
  }
// النافذة المنبثقة لاختيار نوع الحساب لفتحه
  void _showOpenAccountDialog() {
    // 🔑 استخدام Get.dialog بدلاً من Get.defaultDialog وإعطائه محتوى Dialog كامل
    // هذا غالباً أكثر موثوقية لضمان ظهور النافذة
    Get.dialog(
      AlertDialog(
        title: const Text("اختر نوع الحساب", textAlign: TextAlign.right),
        content: SizedBox(
          width: Get.width * 0.7,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.availableAccountTypes.length,
            itemBuilder: (context, index) {
              final type = controller.availableAccountTypes[index];
              final translatedType = AppLink.getTranslatedAccountType(type);
              
              return ListTile(
                title: Text(translatedType, textAlign: TextAlign.right),
                onTap: () {
                  // استدعاء دالة فتح الحساب
                  controller.openNewAccount(type);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إلغاء"),
          ),
        ],
      ),
      barrierDismissible: true, // يمكن إغلاقه بالضغط خارج النافذة
    );
  }}


  // **تأكد من وجود الاستيرادات التالية في بداية ملف home_screen.dart:**
// import 'package:get/get.dart';
// import '../controller/home_controller.dart';
// import '../data/model/account_model.dart';
// import '../core/constants/app_links.dart';

// تصميم الكارد الواحد للحساب
class AccountCard extends StatelessWidget {
  final AccountModel account;
  // 🔑 الحصول على الكنترولر للوصول إلى دالة فتح التذكرة
  final HomeController controller = Get.find<HomeController>();

   AccountCard({required this.account, super.key});

  // 🔑 دالة عرض النافذة المنبثقة لإدخال عنوان التذكرة
  void _showOpenTicketDialog() {
    String titleText = '';
    Get.dialog(
      AlertDialog(
        title: const Text("فتح تذكرة دعم", textAlign: TextAlign.right),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // عرض رقم الحساب الذي سيتم ربط التذكرة به
            Text("للحساب رقم: ${account.accountNumber}", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            TextField(
              textAlign: TextAlign.right,
              onChanged: (value) => titleText = value,
              decoration: const InputDecoration(
                hintText: "عنوان التذكرة (مثل: مشكلة في الرصيد)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titleText.isNotEmpty) {
                // 🔑 استدعاء دالة openTicket مع تمرير ID الحساب
                controller.openTicket(account.id, titleText); 
              } else {
                 Get.snackbar("تنبيه", "الرجاء إدخال عنوان التذكرة.");
              }
            },
            child: const Text("فتح التذكرة"),
          ),
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // تعريب نوع الحساب للعرض
    final String translatedType = AppLink.getTranslatedAccountType(account.type);
    
    return Container(
      // 🔑 تم تصحيح الارتفاع إلى 180 ليناسب العرض الأفقي
      width: 270, 
      height: 180, 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 🔑 إضافة الصف العلوي (العنوان وزر القائمة)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔑 زر القائمة (Menu Button)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'open_ticket') {
                    _showOpenTicketDialog(); // استدعاء دالة عرض Dialog العنوان
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'open_ticket',
                    child: Text('فتح تذكرة دعم'),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
              // عنوان الحساب
              Text(
                translatedType,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const Spacer(), // لفصل الجزء العلوي عن السفلي
          
          Text(
            account.accountNumber,
            style: const TextStyle(
                color: Colors.white70, fontSize: 16, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                // عرض الرصيد مع رقمين عشريين
                'رصيد: ${account.balance.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 5),
              const Text(
                'JD', // العملة
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}