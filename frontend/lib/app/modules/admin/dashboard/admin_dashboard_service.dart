import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../utils/end_point.dart';
import '../../../utils/storage.dart';
import '../../../models/faq.dart';

class AdminManagementService {

  Future<Map<String, dynamic>> _get(String endpoint, {Map<String, String>? query}) async {
    final token = await Storage.getToken();
    final url = Uri.parse(endpoint).replace(queryParameters: query);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    final token = await Storage.getToken();
    final url = Uri.parse(endpoint);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> _put(String endpoint, Map<String, dynamic> body) async {
    final token = await Storage.getToken();
    final url = Uri.parse(endpoint);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    return _processResponse(response);
  }

  Future<void> _delete(String endpoint) async {
    final token = await Storage.getToken();
    final url = Uri.parse(endpoint);

    final response = await http.delete(
      url,
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return json.decode(response.body);
    } else {
      try {
        final error = json.decode(response.body);
        throw error['message'] ?? 'Server error (${response.statusCode})';
      } catch (_) {
        throw 'Server error (${response.statusCode})';
      }
    }
  }

  // ---------------- FAQs ----------------
  Future<Map<String, dynamic>> fetchFaqs(int page, int size) {
    return _get(Endpoint.getAdminApi(), query: {
      'page': page.toString(),
      'size': size.toString(),
    });
  }

  Future<void> createFaq(Faq faq) async {
    final data = faq.toJson();
    if (faq.id == 0) data.remove('id');
    await _post(Endpoint.getAdminApi(), data);
  }

  Future<void> updateFaq(int id, Faq faq) async {
    await _put('${Endpoint.getAdminApi()}/$id', faq.toJson());
  }

  Future<void> deleteFaq(int id) async {
    await _delete('${Endpoint.getAdminApi()}/$id');
  }

  // ---------------- Chat Logs ----------------
  Future<Map<String, dynamic>> fetchChatLogs(int page, int size) {
    return _get(Endpoint.getChatLogApi(), query: {
      'page': page.toString(),
      'size': size.toString(),
    });
  }
}