import 'package:frontend/app/utils/end_point.dart';
import 'package:get/get.dart';
import '../../../data/models/chat_log.dart';
import '../../../data/models/faq.dart';
import '../../../utils/storage.dart';

class AdminApiService extends GetConnect {
  @override
  void onInit() {
    baseUrl = Endpoint.getAdminApi();
    super.onInit();
  }

  Future<Map<String, String>> _headers() async {
    String? token = await Storage.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Faq>> getFaqs() async {
    print("$baseUrl/faqs?arg0=1&arg1=20");
    final response = await get('$baseUrl/faqs?arg0=1&arg1=20', headers: await _headers());
    print(response.statusCode);
    if (response.status.hasError) {
      throw Exception('Failed to load FAQs');
    }
    return (response.body as List).map((e) => Faq.fromJson(e)).toList();
  }

  Future<Faq> createFaq(Faq faq) async {
    final response = await post(
      '$baseUrl/faqs',
      faq.toJson(),
      headers: await _headers(),
    );
    if (response.status.hasError) {
      throw Exception('Failed to create FAQ');
    }
    return Faq.fromJson(response.body);
  }

  Future<Faq> updateFaq(int id, Faq faq) async {
    final response = await put(
      '$baseUrl/faqs/$id',
      faq.toJson(),
      headers: await _headers(),
    );
    if (response.status.hasError) {
      throw Exception('Failed to update FAQ');
    }
    return Faq.fromJson(response.body);
  }

  Future<void> deleteFaq(int id) async {
    final response = await delete(
      '$baseUrl/faqs/$id',
      headers: await _headers(),
    );
    if (response.status.hasError) {
      throw Exception('Failed to delete FAQ');
    }
  }

  Future<List<ChatLog>> getChatLogs() async {
    print("$baseUrl/chat-logs");
    final response = await get('$baseUrl/chat-logs', headers: await _headers());
    print(response.statusCode);
    if (response.status.hasError) {
      throw Exception('Failed to load chat logs');
    }
    return (response.body as List).map((e) => ChatLog.fromJson(e)).toList();
  }
}




// import 'package:frontend/app/utils/end_point.dart';
// import 'package:get/get.dart';
//
// import '../../../data/models/chat_log.dart';
// import '../../../data/models/faq.dart';
// import '../../../utils/storage.dart';
//
// class AdminApiService extends GetConnect {
//
//   @override
//   void onInit() {
//     baseUrl = Endpoint.getAdminApi();
//     super.onInit();
//   }
//
//   Future<Map<String, String>> _headers() async {
//     String? token = await Storage.getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }
//
//   Future<List<Login>> getFaqs() async {
//     final response = await get('$baseUrl/faqs');
//     if (response.status.hasError) {
//       throw Exception('Failed to load FAQs');
//     }
//     return (response.body as List).map((e) => Login.fromJson(e)).toList();
//   }
//
//   Future<Login> createFaq(Login faq) async {
//     final response = await post('$baseUrl/faqs', faq.toJson());
//     if (response.status.hasError) {
//       throw Exception('Failed to create FAQ');
//     }
//     return Login.fromJson(response.body);
//   }
//
//   Future<Login> updateFaq(int id, Login faq) async {
//     final response = await put('$baseUrl/faqs/$id', faq.toJson());
//     if (response.status.hasError) {
//       throw Exception('Failed to update FAQ');
//     }
//     return Login.fromJson(response.body);
//   }
//
//   Future<void> deleteFaq(int id) async {
//     final response = await delete('$baseUrl/faqs/$id');
//     if (response.status.hasError) {
//       throw Exception('Failed to delete FAQ');
//     }
//   }
//
//   Future<List<ChatLog>> getChatLogs() async {
//     final response = await get('$baseUrl/chat-logs');
//     if (response.status.hasError) {
//       throw Exception('Failed to load chat logs');
//     }
//     return (response.body as List).map((e) => ChatLog.fromJson(e)).toList();
//   }
// }