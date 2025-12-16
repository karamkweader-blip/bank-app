import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/auth/resetpassword_reomte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ResetPasswordController extends GetxController {
  resetpassword();
}

class ResetPasswordControllerImp extends ResetPasswordController {
  final String token;
  late TextEditingController password;
  late TextEditingController repassword;
  ResetPasswordControllerImp({required this.token});
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  ResetePasswordRemote reset = ResetePasswordRemote();

  @override
  resetpassword() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final response = await reset.postData(
        password: password.text,
        repassword: repassword.text,
        token: token,
      );
      print(response.body);

      if (response.statusCode == 200) {
        Get.back();
        Get.offNamed(AppRoute.successResetpassword);
        Get.delete<ResetPasswordControllerImp>();
      } else {
        Get.back();
        Get.snackbar("فشل"," يجب ان تحتوي كلمة السر على رموز واحرف كبيرة وصغيرة",
);
      }
    } else {
      print("Not Valid");
    }
  }

  @override
  void onInit() {
    password = TextEditingController();
    repassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    password.dispose();
    repassword.dispose();
    super.dispose();
  }
}
