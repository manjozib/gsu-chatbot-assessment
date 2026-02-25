import 'package:frontend/app/data/models/chart.dart';
import 'package:frontend/app/utils/end_point.dart';
import 'package:get/get.dart';


class ChatApiService extends GetConnect {

  @override
  void onInit() {
    baseUrl = Endpoint.getChatApi();
    super.onInit();
  }

  Future<String> createChat(Chat chat) async {
    final response = await post('$baseUrl/faqs', chat.toJson());
    if (response.status.hasError) {
      throw Exception('Failed to create FAQ');
    }
    return response.body;
  }
}