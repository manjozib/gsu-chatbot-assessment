import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const _k='jwt';
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
}