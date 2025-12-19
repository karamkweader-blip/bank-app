import 'package:bank_app/controller/auth/forgetpassword/resetpassword_controller.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/core/functions/validinput.dart';
import 'package:bank_app/view/widget/auth/custombuttonauth.dart';
import 'package:bank_app/view/widget/auth/customtextbodyauth.dart';
import 'package:bank_app/view/widget/auth/customtextformauth.dart';
import 'package:bank_app/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
      final args = Get.arguments as Map;
      final String token = args['token'];
    ResetPasswordControllerImp controller = Get.put(
      ResetPasswordControllerImp(token:token),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          'ResetPassword',
          style: Theme.of(
            context,
          ).textTheme.displayLarge!.copyWith(color: AppColor.grey),
        ),
      ),
      body: Form(
        key: controller.formstate,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              CustomTextTitleAuth(text: "35".tr),
              const SizedBox(height: 10),
              CustomTextBodyAuth(text: "35".tr),
              const SizedBox(height: 15),
              CustomTextFormAuth(
                valid: (val) {
                  return validInput(val!, 8, 50, "password");
                },
                mycontroller: controller.password,
                hinttext: "13".tr,
                iconData: Icons.lock_outline,
                labeltext: "19".tr,
                // mycontroller: ,
              ),
              CustomTextFormAuth(
                valid: (val) {
                  if (val == null || val.isEmpty) {
                    return "can't be Empty";
                  }
                  if (val != controller.password.text) {
                    return "passwords do not match";
                  }
                  return null;
                },
                mycontroller: controller.repassword,
                hinttext: "Re ${"13".tr}",
                iconData: Icons.lock_outline,
                labeltext: "19".tr,
                // mycontroller: ,
              ),
              CustomButtomAuth(
                text: "33".tr,
                onPressed: () {
                  controller.resetpassword();
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
