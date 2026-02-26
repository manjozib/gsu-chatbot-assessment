import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/app/utils/storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/faq.dart';
import '../../../data/models/chat_log.dart';
// Import your auth service to get the token
// import '../../../core/services/auth_service.dart';

class AdminManagementController extends GetxController {
  // Replace with your actual base URL
  static const String baseUrl = 'http://10.0.12.59:8081';

  // Observable state
  var isLoadingFaqs = false.obs;
  var isLoadingChatLogs = false.obs;
  var faqs = <Faq>[].obs;
  var chatLogs = <ChatLog>[].obs;

  // Pagination metadata (optional)
  var faqTotalPages = 1.obs;
  var faqCurrentPage = 0.obs;
  var chatTotalPages = 1.obs;
  var chatCurrentPage = 0.obs;

  // Helper to get the authentication token
  Future<String?> get _token async {
    // Retrieve token from your auth service
    // Example: return Get.find<AuthService>().token;
    // For now, we'll assume it's stored somewhere; you must implement this.
    // If not using auth, remove the Authorization header.
    return await Storage.getToken();
  }

  @override
  void onInit() {
    super.onInit();
    // Optionally load data when controller is first used
    // fetchFaqs();
    // fetchChatLogs();
  }

  // -------------------- FAQs --------------------
  Future<void> fetchFaqs({int page = 0, int size = 20}) async {
    isLoadingFaqs.value = true;

    try {
      final token = await Storage.getToken();
      final url = Uri.parse('$baseUrl/api/admin/faqs')
          .replace(queryParameters: {'page': page.toString(), 'size': size.toString()});
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> content = data['content'];
        faqs.value = content.map((json) => Faq.fromJson(json)).toList();
        faqTotalPages.value = data['totalPages'] ?? 1;
        faqCurrentPage.value = data['number'] ?? 0;
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _handleGenericError(e);
    } finally {
      isLoadingFaqs.value = false;
    }
  }

  Future<void> createFaq(Faq faq) async {
    try {
      final token = await Storage.getToken();
      final url = Uri.parse('$baseUrl/api/admin/faqs');
      // Remove id if it's 0 (new item)
      final Map<String, dynamic> data = faq.toJson();
      if (faq.id == 0) data.remove('id');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchFaqs(); // refresh list
        Get.snackbar('Success', 'FAQ created successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _handleGenericError(e);
    }
  }

  Future<void> updateFaq(int id, Faq faq) async {
    try {
      final token = await Storage.getToken();
      final url = Uri.parse('$baseUrl/api/admin/faqs/$id');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(faq.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchFaqs();
        Get.snackbar('Success', 'FAQ updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _handleGenericError(e);
    }
  }

  Future<void> deleteFaq(int id) async {
    print(id);
    try {
      final token = await Storage.getToken();
      final url = Uri.parse('$baseUrl/api/admin/faqs/$id');
      final response = await http.delete(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        await fetchFaqs();
        Get.snackbar('Success', 'FAQ deleted successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _handleGenericError(e);
    }
  }

  // -------------------- Chat Logs --------------------
  // Adjust the endpoint if your backend uses a different path
  Future<void> fetchChatLogs({int page = 0, int size = 20}) async {
    isLoadingChatLogs.value = true;
    try {
      final token = await Storage.getToken();
      final url = Uri.parse('$baseUrl/api/admin/chat-logs')
          .replace(queryParameters: {'page': page.toString(), 'size': size.toString()});
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> content = data['content'];
        chatLogs.value = content.map((json) => ChatLog.fromJson(json)).toList();
        chatTotalPages.value = data['totalPages'] ?? 1;
        chatCurrentPage.value = data['number'] ?? 0;
      } else {
        _handleHttpError(response);
      }
    } catch (e) {
      _handleGenericError(e);
    } finally {
      isLoadingChatLogs.value = false;
    }
  }

  // Optional: load more chat logs when scrolling
  Future<void> loadMoreChatLogs() async {
    if (chatCurrentPage.value < chatTotalPages.value - 1) {
      await fetchChatLogs(page: chatCurrentPage.value + 1);
    }
  }

  // -------------------- Error Handling --------------------
  void _handleHttpError(http.Response response) {
    String message = 'Server error (${response.statusCode})';
    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      if (errorData.containsKey('message')) {
        message = errorData['message'];
      }
    } catch (_) {}
    Get.snackbar('Error', message,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _handleGenericError(Object error) {
    Get.snackbar('Error', 'An unexpected error occurred: $error',
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}


// import 'package:get/get.dart';
//
// import '../../../data/models/chat_log.dart';
// import '../../../data/models/faq.dart';
// import 'admin_dashboard_service.dart';
//
// class AdminManagementController extends GetxController {
//   final  _apiMgtService = Get.put(AdminApiService());
//
//   // FAQs
//   final faqs = <Faq>[].obs;
//   final isLoadingFaqs = false.obs;
//
//   // Chat logs
//   final chatLogs = <ChatLog>[].obs;
//   final isLoadingChatLogs = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchFaqs();
//     fetchChatLogs();
//   }
//
//   // Fetch FAQs
//   Future<void> fetchFaqs() async {
//     isLoadingFaqs.value = true;
//     try {
//       faqs.value = await _apiMgtService.getFaqs();
//       print(faqs);
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoadingFaqs.value = false;
//     }
//   }
//
//   // Create FAQ
//   Future<void> createFaq(Faq faq) async {
//     try {
//       final newFaq = await _apiMgtService.createFaq(faq);
//       faqs.add(newFaq);
//       Get.back(); // close dialog
//       Get.snackbar('Success', 'FAQ created successfully');
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   // Update FAQ
//   Future<void> updateFaq(int id, Faq updatedFaq) async {
//     try {
//       final faq = await _apiMgtService.updateFaq(id, updatedFaq);
//       final index = faqs.indexWhere((f) => f.id == id);
//       if (index != -1) {
//         faqs[index] = faq;
//       }
//       Get.back(); // close dialog
//       Get.snackbar('Success', 'FAQ updated successfully');
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   // Delete FAQ
//   Future<void> deleteFaq(int id) async {
//     try {
//       await _apiMgtService.deleteFaq(id);
//       faqs.removeWhere((f) => f.id == id);
//       Get.snackbar('Success', 'FAQ deleted successfully');
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   // Fetch chat logs
//   Future<void> fetchChatLogs() async {
//     isLoadingChatLogs.value = true;
//     try {
//       chatLogs.value = await _apiMgtService.getChatLogs();
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
//     } finally {
//       isLoadingChatLogs.value = false;
//     }
//   }
// }
