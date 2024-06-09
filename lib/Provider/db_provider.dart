import 'package:beehub_flutter_app/Screens/Authentication/login.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  static const tokenKey = 'TOKEN';
  static const userIdKey = 'ID';
  static const roleKey = 'ROLE';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _token = '';

  int _userId = -1;

  String _role = '';

  String get token => _token;

  int get userId => _userId;

  String get role => _role;

  void saveToken(String token) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(tokenKey, token);
  }

  void saveUserId(int id) async {
    SharedPreferences prefs = await _prefs;
    prefs.setInt(userIdKey, id);
  }

  void saveRole(String role) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString(roleKey, role);
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

  Future<String> getRole() async {
    SharedPreferences prefs = await _prefs;
    
    if (prefs.containsKey(roleKey)) {
      String data = prefs.getString(roleKey)!;
      _role = data;
      notifyListeners();
      return data;
    } else {
      _role = '';
      notifyListeners();
      return '';
    }
  }

  void logOut(BuildContext context) async {
    SharedPreferences prefs = await _prefs;
    prefs.clear();
    PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
  }
}
