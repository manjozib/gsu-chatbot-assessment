import 'package:frontend/app/utils/end_point.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/models/login.dart';
import '../../../data/models/login_response.dart';

class AdminApiLoginService extends GetConnect {

  @override
  void onInit() {
    baseUrl = Endpoint.getAuthApi();
    super.onInit();
  }

  Future<LoginResponse> login(Login login) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode(login.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to login: ${response.reasonPhrase}');
      }
      return LoginResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Error in API call');
    }
  }

}