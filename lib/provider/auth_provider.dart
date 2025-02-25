import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task/model/login_response.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = "auth_token";
  Data? _userData;
  bool _isLoading = false;
  String? _token;

  bool get isLoading => _isLoading;
  String? get token => _token;
  Data? get userData => _userData;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: _tokenKey);
    notifyListeners();
  }

  Future<LoginResponse?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://currencyexchangesoftware.eu/pilot/api/userlogin/checklogin"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userName": email,
          "password": password,
          "credentialFlag": "",
          "clientID": "1",
          "branchID": "2",
          "otp": "",
          "resendotp": "",
          "captcha": "",
          "latitude": "",
          "longitude": "",
          "deviceId": "",
          "ipAddress": ""
        }),
      );

      if (response.statusCode == 200) {
        final loginResponse = loginResponseFromJson(response.body);

        if (loginResponse.response) {
          _token = loginResponse.data.token;
          _userData = loginResponse.data;
          await _storage.write(key: _tokenKey, value: _token);
        }
        return loginResponse;
      }
    } catch (error) {
      throw Exception("Login failed: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _token = null;
    _userData = null;
    notifyListeners();
  }
}
