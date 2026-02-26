import 'package:frontend/app/data/models/chart.dart';
import 'package:get/get.dart';
import 'chat_service.dart';

class ChatController extends GetxController {
  final _apiService = Get.put(ChatApiService());
  var messages = <Map<String, dynamic>>[].obs;
  final sessionId = 'session-${DateTime.now().millisecondsSinceEpoch}';

  // Create CHAT
  Future<void> createChat(String text) async {
    messages.add({'sender': 'user', 'text': text});
    try {
      Chat c = Chat(message: text, sessionId: sessionId);
      final answer = await _apiService.createChat(c);
      messages.add({'sender': 'bot', 'text': answer});
      Get.back();
      Get.snackbar('Success', 'CHAT created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
