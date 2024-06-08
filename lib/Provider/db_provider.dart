import 'package:beehub_flutter_app/Screens/Authentication/login.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  static const tokenKey = 'TOKEN';
  static const userIdKey = 'ID';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token = '';

  int _userId = -1;

  String get token => _token;

  int get userId => _userId;

  void saveToken(String token) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(tokenKey, token);
  }

  void saveUserId(int id) async {
    SharedPreferences prefs = await _prefs;
    prefs.setInt(userIdKey, id);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await _prefs;
    
    if (prefs.containsKey(tokenKey)) {
      String data = prefs.getString(tokenKey)!;
      _token = data;
      notifyListeners();
      return data;
    } else {
      _token = '';
      notifyListeners();
      return '';
    }
  }

  Future<int> getUserId() async {
    SharedPreferences prefs = await _prefs;

    if (prefs.containsKey(userIdKey)) {
      int data = prefs.getInt(userIdKey)!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = -1;
      notifyListeners();
      return -1;
    }
  }

  void logOut(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    prefs.clear();
    PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
  }
}
