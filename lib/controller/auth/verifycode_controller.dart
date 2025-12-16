import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/data/datasource/remote/auth/resendcode_reomte.dart';
import 'package:bank_app/data/datasource/remote/auth/send_fcm_token_remote.dart';
import 'package:bank_app/data/datasource/remote/auth/verifycode_remote.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VerifyCodeType {signUp, login }

abstract class VerifyCodeController extends GetxController {
  checkCode();
  resendCode();
}

class VerifyCodeControllerImp extends VerifyCodeController {
  final VerifyCodeType type;
  final String email;
  String code = '';
  SendFcmTokenRemote sendFcmTokenRemote = SendFcmTokenRemote();
  final VerifyCodeRemote _remote = VerifyCodeRemote();
  final ResendCodeRemote _resend = ResendCodeRemote();
  VerifyCodeControllerImp({required this.type, required this.email});

  @override
  Future<void> checkCode() async {
    final token = await _remote.checkCodeAndGetToken(email: email, code: code);

    if (token != null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      switch (type) {
        case VerifyCodeType.signUp:
          Get.back();
          Get.offAllNamed(AppRoute.login);
          break;

        case VerifyCodeType.login:
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("user_token", token);

          // var data = await getUserInfo.getData();
          // final currentUserId = data['id'];
          // await prefs.setInt("current_user_id", currentUserId);

          
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await sendFcmTokenRemote.postData(fcm:fcmToken);
          }
          Get.back();
          
          Get.offAllNamed(AppRoute.home);
          break;
      }
    } else {
      Get.snackbar("خطأ", "رمز التحقق غير صحيح");
    }
  }

  @override
  resendCode() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final response = await _resend.postData(email: email);
    print(response.body);

    if (response.statusCode == 200) {
      Get.back();
      Get.snackbar("نجاح", "تم ارسال الكود بنجاح ");
    } else {
      Get.back();
      Get.snackbar("فشل", "حدث خطأ ");
    }
  }
}
