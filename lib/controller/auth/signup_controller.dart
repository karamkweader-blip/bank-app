import 'package:bank_app/controller/auth/verifycode_controller.dart';
import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/auth/signup_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SignUpController extends GetxController {
  signUp();
  goToSignIn();
}

class SignUpControllerImp extends SignUpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confpassword;

  SignUpRemote signUpRemote = SignUpRemote();

  @override
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
       Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, 
      );
      final response = await signUpRemote.postData(
        username: username.text,
        email: email.text,
        password: password.text,
        confpassword: confpassword.text,
      );
      print(response.body);

      if (response.statusCode == 200) {
          Get.back();
        Get.offNamed(
          AppRoute.verfiyCode,
          arguments: {'type': VerifyCodeType.signUp, 'email': email.text},
        );
        Get.delete<SignUpControllerImp>();
      } else {
          Get.back();
        Get.snackbar("فشل", "حدث خطأ أثناء إنشاء الحساب");
      }
    } else {}
  }

  @override
  goToSignIn() {
    Get.offNamed(AppRoute.login);
  }

  @override
  void onInit() {
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confpassword = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confpassword.dispose();
    super.dispose();
  }
}
