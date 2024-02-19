import 'dart:convert';
import 'dart:developer';

import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/trip/data/api/api_service.dart';
import 'package:bookihub/src/shared/constant/base_url.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final storage = locator<FlutterSecureStorage>();
  Future<String> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(url, body: {
        "username": email,
        "password": password,
        "userType": "company"
      }).timeout(const Duration(seconds: 35));
      if (response.statusCode != 200) {
        // print(response.reasonPhrase);
        final errorMessage = json.decode(response.body)['error'];
        throw CustomException(errorMessage == 'bad request'
            ? 'User name or password is wrong'
            : 'Failed to login.');
      }
      final jsonData = jsonDecode(response.body)['data'];
      // await storage.write(key: 'accessToken', value: jsonData['accessToken']);
      await storage.write(key: 'refreshToken', value: jsonData['refreshToken']);
      //fetch user session after successfull login
      //within the fetchSession is return user id
      final user = await fetchSession(jsonData['accessToken']);
      return user.toString();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<String> fetchSession(token) async {
    try {
      const url = '$baseUrl/auth/session';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        log(response.reasonPhrase.toString());
        throw CustomException('failed to get session');
      }
      log(response.body);
      final jsonID = jsonDecode(response.body)['data']['id'];

      return jsonID.toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updatePassword(
      String currentPassword, String password, String repeatPassword) async {
    final prefs = await SharedPreferences.getInstance();
    const url = "$baseUrl/auth/update-password";
    final body = {
      "currentPassword": currentPassword,
      "newPassword": password,
      "confirmNewPassword": repeatPassword,
    };
    try {
      final response = await client.put(url,body: body);
      log(body.toString());
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['message'];
        throw CustomException(response.body);
      }
      return jsonDecode(response.body)['message'];
    } catch (e) {
      rethrow;
    }
  }

  Future<String> resetPassword(
      String email, String password, String repeatPassword) async {
    const url = "$baseUrl/auth/reset-password";
    final body = {
      "username": email,
      "newPassword": password,
      "confirmNewPassword": repeatPassword,
    };
    try {
      final response = await http.put(Uri.parse(url),body: body);
      log(response.body);
      if (response.statusCode != 200) {
        final message = jsonDecode(response.body)['error'];
        throw CustomException(message);
      }
      return jsonDecode(response.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
