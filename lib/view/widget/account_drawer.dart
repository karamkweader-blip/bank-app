import 'package:bank_app/controller/home_controller.dart';
import 'package:bank_app/view/screen/home/language_page.dart';
import 'package:bank_app/view/widget/account_menu-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AccountDrawer extends StatelessWidget {
  const AccountDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            const SizedBox(height: 30),

            AccountMenuItem(
              icon: Icons.language,
              label: "تغيير اللغة",
              onTap: () {
                Get.back();
                Get.to(() => const Language());
              },
            ),


            const SizedBox(height: 20),
            AccountMenuItem(
              icon: Icons.info_outline,
              label: "عن التطبيق",
              onTap: () {
                Get.back();
                Get.defaultDialog(
                  title: "حول التطبيق",
                  middleText:
                      " complaints app   للتواصل karamalah.kweader@gmail.com",
                );
              },
            ),

            const SizedBox(height: 20),
            AccountMenuItem(
              icon: Icons.logout,
              label: "تسجيل الخروج",
              color: Colors.red,
              onTap: () {
                Get.back();
              //  controller.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
