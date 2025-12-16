import 'package:bank_app/controller/auth/checkcode_controller.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/view/widget/auth/customtextbodyauth.dart';
import 'package:bank_app/view/widget/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class CheckCode extends StatelessWidget {
  const CheckCode({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final String email = args['email'];
    final CheckCodeType type = args['type'];

    CheckCodeControllerImp controller = Get.put(
      CheckCodeControllerImp( email: email, type: type),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text(
          'Verification Code',
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
            const CustomTextTitleAuth(text: "Check code"),
            const SizedBox(height: 10),
            const CustomTextBodyAuth(
              text: "Please Enter The Digit Code Sent To Your Email",
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
              onChanged: (String code) {
                // handle validation or checks here
              },
              onCompleted: (String verificationCode) {
                controller.code = verificationCode;
                controller.checkCoderesetpassword();
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
