import 'package:bank_app/core/routes/routes.dart';
import 'package:bank_app/core/services/services.dart';
import 'package:bank_app/data/datasource/remote/auth/logout_remote.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var unreadCount = 0.obs;
  LogoutRemote logoutRemote = LogoutRemote();
  MyServices myServices = Get.find();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  logout() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token").toString();
    // prefs.clear();

    final response = await logoutRemote.deletetoken(token: token);
    print(response);
    if (response.statusCode == 200) {
      await prefs.clear();
      Get.back();
      //print(token);
      Get.offAllNamed(AppRoute.login);
    } else {
      print(response.body);
    }
  }

}
