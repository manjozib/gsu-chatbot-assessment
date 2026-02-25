import 'package:get/get.dart';

import '../../../data/models/chat_log.dart';
import '../../../data/models/faq.dart';
import 'admin_dashboard_service.dart';

class AdminManagementController extends GetxController {
  final AdminApiService _apiService = AdminApiService();

  // FAQs
  final faqs = <Faq>[].obs;
  final isLoadingFaqs = false.obs;

  // Chat logs
  final chatLogs = <ChatLog>[].obs;
  final isLoadingChatLogs = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
    fetchChatLogs();
  }

  // Fetch FAQs
  Future<void> fetchFaqs() async {
    isLoadingFaqs.value = true;
    try {
      faqs.value = await _apiService.getFaqs();
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingFaqs.value = false;
    }
  }

  // Create FAQ
  Future<void> createFaq(Faq faq) async {
    try {
      final newFaq = await _apiService.createFaq(faq);
      faqs.add(newFaq);
      Get.back(); // close dialog
      Get.snackbar('Success', 'FAQ created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Update FAQ
  Future<void> updateFaq(int id, Faq updatedFaq) async {
    try {
      final faq = await _apiService.updateFaq(id, updatedFaq);
      final index = faqs.indexWhere((f) => f.id == id);
      if (index != -1) {
        faqs[index] = faq;
      }
      Get.back(); // close dialog
      Get.snackbar('Success', 'FAQ updated successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Delete FAQ
  Future<void> deleteFaq(int id) async {
    try {
      await _apiService.deleteFaq(id);
      faqs.removeWhere((f) => f.id == id);
      Get.snackbar('Success', 'FAQ deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Fetch chat logs
  Future<void> fetchChatLogs() async {
    isLoadingChatLogs.value = true;
    try {
      chatLogs.value = await _apiService.getChatLogs();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingChatLogs.value = false;
    }
  }
}
