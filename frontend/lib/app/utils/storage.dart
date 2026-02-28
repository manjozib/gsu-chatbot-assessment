import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const _k='jwt';
  static const _ipKey = 'server_ip';
  static const _portKey = 'server_port';


  static saveToken(t)async{
    final p=await SharedPreferences.getInstance();
    p.setString(_k,t);
  }

  static getToken() async {
    final p=await SharedPreferences.getInstance();
    return p.getString(_k);
  }

  static clear() async {
    final p=await SharedPreferences.getInstance();
    p.remove(_k);
  }

  static Future<void> saveServerConfig(String ip, String port) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ipKey, ip);
    await prefs.setString(_portKey, port);
  }

  static Future<String> getServerIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ipKey) ?? '127.0.0.1';
  }

  static Future<String> getServerPort() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_portKey) ?? '8080';
  }
}