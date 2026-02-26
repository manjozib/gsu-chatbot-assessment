import 'package:flutter/material.dart';
import 'package:frontend/app/data/models/login.dart';
import 'package:get/get.dart';
import '../../../utils/storage.dart';

import 'admin_login_service.dart';

class AdminLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _apiLoginService = Get.put(AdminApiLoginService());
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;

  Future<void> login() async {
    print(emailController.text.isEmpty);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;
    try {
      Login l = Login(email: emailController.text, password: passwordController.text);
      print(l.email);
      final result = await _apiLoginService.login(l);
      print(result.token);
      //save token
      Storage.saveToken(result.token);
      Get.offNamed('/admin/dashboard');
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }

    // Simulation
    // await Future.delayed(const Duration(seconds: 2));



    // On success, navigate to dashboard

  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}