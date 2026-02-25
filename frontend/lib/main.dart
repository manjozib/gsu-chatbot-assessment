import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/admin/dashboard/admin_dashboard_controller.dart';
import 'app/modules/admin/login/admin_login_controller.dart';
import 'app/modules/chat/chat_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(ChatController());
  Get.put(AdminLoginController());
  Get.put(AdminManagementController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GSU SmartAssist',
      initialRoute: '/chat',
      getPages: AppPages.routes,
      theme: ThemeData(useMaterial3: true),
    );
  }
}