import 'dart:convert';
import 'dart:io';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_dashboard.dart';
import 'package:beehub_flutter_app/Screens/Authentication/login.dart';
import 'package:beehub_flutter_app/Screens/home_page.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  final authUrl = AppUrl.authPath;

  bool _isLoading = false;
  String _resMessage = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  void registerUser(
      {required String username,
      required String fullName,
      required String email,
      required String password,
      BuildContext? context}) async {
    _isLoading = true;
    notifyListeners();

    String url = "$authUrl/signup";

    final body = {
      "username": username,
      "fullName": fullName,
      "email": email,
      "password": password
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (req.statusCode == 200 || req.statusCode == 201) {
        _isLoading = false;
        _resMessage = "Account created!";
        notifyListeners();
        PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
      } else {
        final res = jsonDecode(req.body);

        _resMessage = res['message'];

        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Something went wrong. Please try again";
      notifyListeners();

      print(":::: $e");
    }
  }

  void loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$authUrl/signin";

    final body = {"email": email, "password": password};

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8'
          }).timeout(const Duration(seconds: 3));
      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _isLoading = false;
        _resMessage = "Login successfull!";
        notifyListeners();

        ///Save users data and then navigate to homepage
        final userId = res['id'];
        final token = res['token'];
        final role = res['roles'][0];
        DatabaseProvider().saveToken(token);
        DatabaseProvider().saveUserId(userId);
        DatabaseProvider().saveRole(role);
        String admin = "ROLE_ADMIN";
        if (role == admin) {
          PageNavigator(ctx: context).nextPageOnly(page: const Dashboard());
        } else {
          PageNavigator(ctx: context).nextPageOnly(page: const HomePage());
        }
      } else {
        if (req.statusCode == 403) {
          _resMessage = req.body;
        } else {
          final res = json.decode(req.body);
          _resMessage = res['message'];
        }

        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available`";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again`";
      notifyListeners();

      print(":::: $e");
    }
  }

  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
