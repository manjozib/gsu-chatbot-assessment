import 'package:frontend/app/utils/storage.dart';

class Endpoint {
  static String? _baseUrl;

  static Future<void> init() async {
    final ip = await Storage.getServerIp();
    final port = await Storage.getServerPort();
    _baseUrl = "http://$ip:$port/api";
  }

  static Future<void> setBaseUrl(String ipAddress, String portNumber) async {
    _baseUrl = "http://$ipAddress:$portNumber/api";
    await Storage.saveServerConfig(ipAddress, portNumber);
  }

  static String get baseUrl {
    if (_baseUrl == null) {
      throw Exception("Endpoint not initialized. Call Endpoint.init()");
    }
    return _baseUrl!;
  }

  static String get adminBaseUrl => "$baseUrl/admin";

  static String getAdminApi() => "$adminBaseUrl/faqs";

  static String getChatLogApi() => "$adminBaseUrl/chat-logs";

  static String getChatApi() => "$baseUrl/chat";

  static String getAuthApi() => "$baseUrl/auth";

  static String getFaqApi() => "$baseUrl/faqs";
}