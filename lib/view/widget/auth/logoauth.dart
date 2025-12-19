import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/core/constant/imgaeasset.dart';
import 'package:flutter/material.dart';

class LogoAuth extends StatelessWidget {
  const LogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundColor: AppColor.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(0), // Border radius
        child: Image.asset(AppImageAsset.logo),
      ),
    );
  }
}
