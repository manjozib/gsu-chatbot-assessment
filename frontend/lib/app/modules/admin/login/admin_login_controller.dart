import 'package:flutter/material.dart';
import '../../../models/login.dart';
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
      final result = await _apiLoginService.login(l);
      //save token
      Storage.saveToken(result.token);
      emailController.clear();
      passwordController.clear();
      Get.offNamed('/admin/dashboard');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}