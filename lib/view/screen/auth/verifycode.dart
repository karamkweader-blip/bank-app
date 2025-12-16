import 'package:bank_app/controller/auth/verifycode_controller.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/view/widget/auth/customtextbodyauth.dart';
import 'package:bank_app/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class VerfiyCode extends StatelessWidget {
  const VerfiyCode({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final VerifyCodeType type = args['type'];
    final String email = args['email'];

    VerifyCodeControllerImp controller = Get.put(
      VerifyCodeControllerImp(type: type, email: email),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          'رمز التحقق',
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
            const CustomTextTitleAuth(text: "تحقق من الرمز"),
            const SizedBox(height: 10),
            const CustomTextBodyAuth(
              text: "يرجى إدخال رمز التحقق المرسل إلى بريدك الإلكتروني",
            ),
            const SizedBox(height: 15),
            OTPTextField(
              length: 6,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 50,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              otpFieldStyle: OtpFieldStyle(
                borderColor: const Color(0xFF512DA8),
              ),
              onChanged: (String code) {},
              onCompleted: (String verificationCode) {
                controller.code = verificationCode;
                controller.checkCode();
              },
            ),
            const SizedBox(height: 10),
            InkWell(
              child: Text('اعادة ارسال الكود', style: TextStyle(fontSize: 16)),
              onTap: () {
                controller.resendCode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
