import 'package:bank_app/check_auth.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/core/localization/translation.dart';
import 'package:bank_app/core/routes/pages_routes.dart';
import 'package:bank_app/core/services/services.dart';
import 'package:bank_app/data/datasource/remote/remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/changelocal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialServices();
    Get.put<RemoteDataSource>(RemoteDataSource(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: controller.language,
      theme: ThemeData(
        fontFamily: "PlayfairDisplay",
        textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColor.black),
            displayMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: AppColor.black),
            bodyLarge: TextStyle(
                height: 2,
                color: AppColor.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14),
            bodyMedium: TextStyle(
                height: 2,
                color: AppColor.grey,
                fontSize: 14)),
        primarySwatch: Colors.blue,
      ),
      home:
const CheckAuth(),
      routes: routes,
    );
  }
}
