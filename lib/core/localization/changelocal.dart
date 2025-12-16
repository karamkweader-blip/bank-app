import 'package:bank_app/core/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class LocaleController extends GetxController {
  Locale? language;
  MyServices myServices = Get.find();

  // تغيير اللغة وتخزينها
  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? savedLang = myServices.sharedPreferences.getString("lang");

    if (savedLang != null) {
      language = Locale(savedLang);
    } else {
      //   استخدم لغة الجهاز
      String deviceLang = Get.deviceLocale?.languageCode ?? 'en';
      if (["ar", "en"].contains(deviceLang)) {
        language = Locale(deviceLang);
      } else {
        language = const Locale("en");
      }

      // واحفظ اللغة المختارة تلقائيًا للمرة الجاية
      myServices.sharedPreferences.setString("lang", language!.languageCode);
    }

    super.onInit();
  }
}
