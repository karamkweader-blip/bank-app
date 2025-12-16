import 'package:bank_app/controller/home/home_controller.dart';
import 'package:bank_app/core/constant/color.dart';
import 'package:bank_app/view/widget/account_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<HomeController>();

    return Scaffold(
    //   key: controller.scaffoldKey,
    //   drawer: AccountDrawer(),
    //   appBar: AppBar(
    //     backgroundColor: AppColor.primaryColor,
    //     centerTitle: true,
    //     title: const Text(
    //       "Bank System",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //     foregroundColor: Colors.white,
    //     leading: IconButton(
    //       icon: const Icon(Icons.menu, color: Colors.white),
    //       onPressed: controller.openDrawer,
    //     ),
    //     actions: [
    //       IconButton(
    //         icon: Stack(
    //           children: [
    //             const Icon(Icons.notifications, color: Colors.white),
    //             Obx(() {
    //               if (controller.unreadCount > 0) {
    //                 return Positioned(
    //                   right: 0,
    //                   top: 0,
    //                   child: Container(
    //                     padding: const EdgeInsets.all(2),
    //                     decoration: const BoxDecoration(
    //                       color: Colors.red,
    //                       shape: BoxShape.circle,
    //                     ),
    //                     constraints: const BoxConstraints(
    //                       minWidth: 16,
    //                       minHeight: 16,
    //                     ),
    //                     child: Center(
    //                       child: Text(
    //                         '${controller.unreadCount}',
    //                         style: const TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 10,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               }
    //               return const SizedBox.shrink();
    //             }),
    //           ],
    //         ),
    //         onPressed: () async {
    //           Get.toNamed("/notifications");
    //           controller.unreadCount.value = 0;
    //         },
    //       ),
    //     ],
    //   ),

    //   body: Obx(() {
    //     if (controller.isLoading.value) {
    //       return const Center(child: CircularProgressIndicator());
    //     }

    //     if (controller.complaints.isEmpty) {
    //       return const Center(child: Text("لا توجد حسابات لك بعد"));
    //     }

      
    //   }),
     );
  }
}

