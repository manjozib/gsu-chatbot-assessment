import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/faq.dart';
import '../../../models/chat_log.dart';
import 'admin_dashboard_service.dart';

class AdminManagementController extends GetxController {
  final _adminMgtService = Get.put(AdminManagementService());

  var isLoadingFaqs = false.obs;
  var isLoadingChatLogs = false.obs;

  var faqs = <Faq>[].obs;
  var chatLogs = <ChatLog>[].obs;

  var faqTotalPages = 1.obs;
  var faqCurrentPage = 0.obs;
  var chatTotalPages = 1.obs;
  var chatCurrentPage = 0.obs;

  // ---------------- FAQs ----------------
  Future<void> fetchFaqs({int page = 0, int size = 20}) async {
    isLoadingFaqs.value = true;
    try {
      final data = await _adminMgtService.fetchFaqs(page, size);

      final content = data['content'] as List;
      faqs.value = content.map((e) => Faq.fromJson(e)).toList();

      faqTotalPages.value = data['totalPages'] ?? 1;
      faqCurrentPage.value = data['number'] ?? 0;
    } catch (e) {
      _showError(e);
    } finally {
      isLoadingFaqs.value = false;
    }
  }

  Future<void> createFaq(Faq faq) async {
    try {
      await _adminMgtService.createFaq(faq);
      await fetchFaqs();
      _showSuccess('FAQ created successfully');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> updateFaq(int id, Faq faq) async {
    try {
      await _adminMgtService.updateFaq(id, faq);
      await fetchFaqs();
      _showSuccess('FAQ updated successfully');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> deleteFaq(int id) async {
    try {
      await _adminMgtService.deleteFaq(id);
      await fetchFaqs();
      _showSuccess('FAQ deleted successfully');
    } catch (e) {
      _showError(e);
    }
  }

  // ---------------- Chat Logs ----------------
  Future<void> fetchChatLogs({int page = 0, int size = 20}) async {
    isLoadingChatLogs.value = true;
    try {
      final data = await _adminMgtService.fetchChatLogs(page, size);

      final content = data['content'] as List;
      chatLogs.value = content.map((e) => ChatLog.fromJson(e)).toList();

      chatTotalPages.value = data['totalPages'] ?? 1;
      chatCurrentPage.value = data['number'] ?? 0;
    } catch (e) {
      _showError(e);
    } finally {
      isLoadingChatLogs.value = false;
    }
  }

  Future<void> loadMoreChatLogs() async {
    if (chatCurrentPage.value < chatTotalPages.value - 1) {
      await fetchChatLogs(page: chatCurrentPage.value + 1);
    }
  }

  // ---------------- UI Helpers ----------------
  void _showSuccess(String message) {
    Get.snackbar('Success', message,
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _showError(Object error) {
    Get.snackbar('Error', error.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}