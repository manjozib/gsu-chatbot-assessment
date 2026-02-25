import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/chat/chat_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  Get.put(ChatController());
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