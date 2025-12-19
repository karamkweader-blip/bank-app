import 'package:bank_app/controller/app/home_controller.dart';
import 'package:bank_app/core/constant/app_links.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/model/account_model.dart';
import 'package:bank_app/view/widget/account_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transfer_page.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      key: controller.scaffoldKey,
      drawer: AccountDrawer(),
      appBar: AppBar(
        title: const Text("Bank System", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: controller.openDrawer,
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications, color: Colors.white),
                Obx(() {
                  if (controller.unreadCount > 0) {
                    return Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '${controller.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
            onPressed: () async {
              Get.toNamed(AppRoute.notifications);
              controller.unreadCount.value = 0;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            );
          }
          if (controller.accounts.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد حسابات لعرضها حالياً.",
                style: TextStyle(fontSize: 16, color: AppColor.grey),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "حساباتي",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
              const SizedBox(height: 15),

              // عرض الحسابات أفقياً
              _buildHorizontalAccountList(controller.accounts),

              const SizedBox(height: 30), // مسافة بين الحسابات والأزرار
              // أزرار التحويل وفتح الحساب
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showOpenAccountDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "فتح حساب",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.to(() => TransferScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "تحويل الأموال",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHorizontalAccountList(List<AccountModel> accounts) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: AccountCard(account: accounts[index]),
          );
        },
      ),
    );
  }

  void _showOpenAccountDialog() {
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
                  controller.openNewAccount(type);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
        ],
      ),
      barrierDismissible: true,
    );
  }
}

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
            Text(
              "للحساب رقم: ${account.accountNumber}",
              style: const TextStyle(fontSize: 14),
            ),
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
    final String translatedType = AppLink.getTranslatedAccountType(
      account.type,
    );

    return Container(
      // 🔑 تم تصحيح الارتفاع إلى 180 ليناسب العرض الأفقي
      width: 270,
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 🔑 إضافة الصف العلوي (العنوان وزر القائمة)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            PopupMenuButton<String>(
  onSelected: (value) {
    if (value == 'open_ticket') {
      _showOpenTicketDialog();
    } else if (value == 'add_child') {
     controller.showAddChildDialog(parentAccountId: account.id);
    } else if (value == 'view_children') {
      controller.viewChildAccounts(account.id);
    }
  },
  itemBuilder: (BuildContext context) {
    List<PopupMenuEntry<String>> items = [
      const PopupMenuItem<String>(
        value: 'open_ticket',
        child: Text('فتح تذكرة دعم'),
      ),
    ];

    // 🔑 فقط للحساب المركب
    if (account.type == 'composite') {
      items.addAll([
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'add_child',
          child: Text('إضافة حساب ابن'),
        ),
        const PopupMenuItem<String>(
          value: 'view_children',
          child: Text('عرض الحسابات الأبناء'),
        ),
      ]);
    }

    return items;
  },
  icon: const Icon(Icons.more_vert, color: Colors.white),
),

              // عنوان الحساب
              Text(
                translatedType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Spacer(), // لفصل الجزء العلوي عن السفلي

          Text(
            account.accountNumber,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'monospace',
            ),
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
                  fontWeight: FontWeight.w600,
                ),
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
