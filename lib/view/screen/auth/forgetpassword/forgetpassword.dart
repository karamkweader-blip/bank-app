import 'package:bank_app/controller/auth/forgetpassword_controller.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/core/functions/validinput.dart';
import 'package:bank_app/view/widget/auth/custombuttonauth.dart';
import 'package:bank_app/view/widget/auth/customtextbodyauth.dart';
import 'package:bank_app/view/widget/auth/customtextformauth.dart';
import 'package:bank_app/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    ForgetPasswordControllerImp controller = Get.put(
      ForgetPasswordControllerImp(),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          '14'.tr,
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(color: AppColor.grey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            CustomTextTitleAuth(text: "27".tr),
            const SizedBox(height: 10),
            CustomTextBodyAuth(text: "29".tr),
            const SizedBox(height: 15),
            CustomTextFormAuth(
              valid: (val) {
                return validInput(val!, 5, 100, "email");
              },
              mycontroller: controller.email,
              hinttext: "12".tr,
              iconData: Icons.email_outlined,
              labeltext: "18".tr,
              // mycontroller: ,
            ),
            CustomButtomAuth(
              text: "30".tr,
              onPressed: () {
                controller.checkemail();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
