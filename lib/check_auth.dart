import 'package:bank_app/view/screen/auth/login.dart';
import 'package:bank_app/view/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    print(token);
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
         
          return snapshot.data == true ? HomeScreen() :  Login();
        }
      },
    );
  }
}
