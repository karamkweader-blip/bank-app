import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bank_app/controller/app/transfer_controller.dart';

class TransferScreen extends StatelessWidget {
  TransferScreen({super.key});

  final TransferController controller = Get.put(
    TransferController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحويل أموال"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "الحساب المرسل منه",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () async {
                  await controller.fetchAccounts();
                  _showAccountsBottomSheet(context);
                },
                child: AbsorbPointer(
                  child: Obx(
                    () => TextFormField(
                      decoration: const InputDecoration(
                        hintText: "اختر الحساب",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.keyboard_arrow_down),
                      ),
                      controller: TextEditingController(
                        text: controller.selectedFromAccountText.value,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // الحساب المستفيد
              const Text(
                "الحساب المستفيد",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.toAccountController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'رقم حساب المستفيد',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.searchToAccountLive(value);
                },
              ),

              Obx(() {
                if (controller.searchResults.isEmpty) return const SizedBox();
                final account = controller.searchResults.first;
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    title: Text(account['account_number']),
                    subtitle: Text(
                      '${controller.getAccountTypeArabic(account['type'])} - رصيد: ${account['balance']} JD',
                    ),
                    onTap: () => controller.selectToAccount(account),
                  ),
                );
              }),

              const SizedBox(height: 24),
              const Text(
                "المبلغ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "أدخل المبلغ",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 32),

              // =========================
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.transferMoney,
                  child:
                      controller.isLoading.value
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text("تنفيذ التحويل"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الحسابات
  void _showAccountsBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() {
          if (controller.accounts.isEmpty) {
            return const Center(child: Text("لا يوجد حسابات"));
          }

          return ListView.builder(
            itemCount: controller.accounts.length,
            itemBuilder: (context, index) {
              final acc = controller.accounts[index];
              return Card(
                child: ListTile(
                  title: Text(acc['account_number']),
                  subtitle: Text(
                    "${controller.getAccountTypeArabic(acc['type'])} - رصيد: ${acc['balance']} JD",
                  ),
                  onTap: () {
                    controller.selectFromAccount(
                      acc['id'].toString(),
                      acc['account_number'],
                    );
                    Get.back();
                  },
                ),
              );
            },
          );
        }),
      ),
      isScrollControlled: true,
    );
  }
}
