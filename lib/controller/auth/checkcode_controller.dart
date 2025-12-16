import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/auth/checkcodeforreset_remote.dart';
import 'package:bank_app/data/datasource/remote/auth/resendcode_reomte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum CheckCodeType {forgetpassword, profile }
abstract class CheckCodeController extends GetxController {
  checkCoderesetpassword();
  resendCode();
}

class CheckCodeControllerImp extends CheckCodeController {
  final CheckCodeType type;
  final String email;
  String code = '';

  final CheckCodeForResetRemote _remote = CheckCodeForResetRemote();
  final ResendCodeRemote _resend = ResendCodeRemote();
  CheckCodeControllerImp({required this.type,required this.email});

  @override
  Future<void> checkCoderesetpassword() async {
    final token = await _remote.checkCodeForReset(email: email, code: code);
    if (token != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
 switch (type) {
        case CheckCodeType.forgetpassword:
        Get.back();
          Get.offAllNamed(AppRoute.resetPassword, arguments: {'token': token});
          break;

        case CheckCodeType.profile:
        Get.back();
          Get.offAllNamed(AppRoute.changePassword, arguments: {'token': token});
          break;
      }
    } else {
      Get.back();
      Get.snackbar("خطأ", "رمز التحقق غير صحيح");
    }
  }
  
  @override
  resendCode() async{
     Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
   final response = await _resend.postData(email: email);
     //print(response.body);

    if (response.statusCode == 200) {
        Get.back();
       Get.snackbar("نجاح", "تم ارسال الكود بنجاح ");
    } else {
        Get.back();
      Get.snackbar("فشل", " يجب ان تحتوي كلمة السر على رموز واحرف كبيرة وصغيرة",
);
    }
  }
}
