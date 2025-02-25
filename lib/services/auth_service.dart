import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_task/config/app_config.dart';
import 'package:flutter_task/model/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _tokenKey = "auth_token";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Login and store token securely
  static Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/pilot/api/userlogin/checklogin"),
        headers: {"content-Type": "application/json"},
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
          "ipAddress": "",
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        LoginResponse loginResponse = LoginResponse.fromJson(jsonData);

        if (loginResponse.response && loginResponse.data.token.isNotEmpty) {
          await _saveToken(loginResponse.data.token);
          return loginResponse;
        }
      }
      return null;
    } catch (error) {
      throw Exception("API Error: $error");
    }
  }

  /// Save token securely
  static Future<void> _saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieve token securely
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Check if user is logged in (Token exists)
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout and remove token
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }
}
