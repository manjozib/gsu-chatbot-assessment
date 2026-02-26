import 'package:frontend/app/data/models/chat.dart';
import 'package:frontend/app/utils/end_point.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class ChatApiService extends GetConnect {

  @override
  void onInit() {
    baseUrl = Endpoint.getChatApi();
    super.onInit();
  }

  // Future<String> createChat(Chat chat) async {
  //   final response = await post('$baseUrl/faqs', chat.toJson());
  //   if (response.status.hasError) {
  //     throw Exception('Failed to create FAQ');
  //   }
  //   return response.body;
  // }

  Future<String> createChat(Chat chat) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: headers,
        body: jsonEncode(chat.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to chat: ${response.reasonPhrase}');
      }
      final responseBody = jsonDecode(response.body);
      return responseBody['reply'] as String;
    } catch (e) {
      throw Exception('Error in API call');
    }
  }
}