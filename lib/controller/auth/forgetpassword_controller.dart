
import 'package:bank_app/controller/auth/checkcode_controller.dart';
import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/auth/forgetpassword_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class ForgetPasswordController extends GetxController {
  checkemail();
}

class ForgetPasswordControllerImp extends ForgetPasswordController {
  late TextEditingController email;
  ForgetPasswordRemote forgetPasswordRemote = ForgetPasswordRemote();
  @override
  checkemail() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final response = await forgetPasswordRemote.postData(email: email.text);
    print(response.body);

    if (response.statusCode == 200) {
      Get.back();
      Get.offNamed(
        AppRoute.checkCode,
        arguments: {'type': CheckCodeType.forgetpassword, 'email': email.text},
      );
      Get.delete<ForgetPasswordControllerImp>();
    } else {
      Get.back();
      Get.snackbar("فشل", "حدث خطأ ");
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }



  // @override
  // void dispose() {
  //   email.dispose();
  //   super.dispose();
  // }
}
