import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/view/screen/auth/forgetpassword/checkcode.dart';
import 'package:bank_app/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:bank_app/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:bank_app/view/screen/auth/forgetpassword/success_resetpassword.dart';
import 'package:bank_app/view/screen/auth/login.dart';
import 'package:bank_app/view/screen/auth/signup.dart';
import 'package:bank_app/view/screen/auth/verifycode.dart';
import 'package:bank_app/view/screen/home/home.dart';
import 'package:bank_app/view/screen/home_screen.dart';
import 'package:flutter/material.dart';


Map<String, Widget Function(BuildContext)> routes = {
  /////// Auth
  AppRoute.login: (context) => const Login(),
  AppRoute.signUp: (context) => const SignUp(),
  AppRoute.forgetPassword: (context) => const ForgetPassword(),
  AppRoute.verfiyCode: (context) => const VerfiyCode(),
  AppRoute.checkCode: (context) => const CheckCode(),
  AppRoute.resetPassword: (context) => const ResetPassword(),
  AppRoute.successResetpassword: (context) => const SuccessResetPassword(),
  ////inside app
AppRoute.home: (context) =>  HomeScreen(),

};
